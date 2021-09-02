### 一、Context简介:

context是Go在1.7版本中加入的新的标准库,  它定义了Context的类型, **专门用来简化处理单个请求的多个goroutine之间的请求域的数据和取消信号,  截止时间等相关的操作**



### 二、Context接口

```go
type Context interface {
    // 返回context被取消的时间, 也就是完成工作时,调用cancel的时间
	Deadline() (deadline time.Time, ok bool)
	
    // 调用Done()方法会返回channel, 这个channel会在当前工作完成,或者被cannel()之后关闭
    // 多次调用Done() 返回同一个channel
	Done() <-chan struct{}
	
    // 如果channel被取消了, 返回canceled错误
    // 如果channel超时了, 返回DeadlineExceeded 错误
	Err() error
	
    // 用于传递跨越API和进程间请求域的数据
    // Value方法会在Context中返回键值对的值
    // 对于Context来说, 多次使用相同的key调用Value, 得到的结果也相同
	Value(key interface{}) interface{}
}
```

### 三、重要API之 Background() 和 TODO()

在正式看Context接口前我们先看Go的这两个内置函数 `Background() 和 TODO()`

因为通常我们在构建Context时会使用这个内置函数

```go
// 传入一个父Context, 返回父节点的副本
ctx, cancel := context.WithCancel(context.Background())
```

* `Background()`主要用于main函数、初始化以及测试代码中，作为Context这个树结构的最顶层的Context，也就是根Context。 
* `TODO()`，它目前还不知道具体的使用场景，如果我们不知道该使用什么Context的时候，可以使用这个。 
* `background`和`todo`本质上都是`emptyCtx`结构体类型，是一个不可取消，没有设置截止时间，没有携带任何值的Context。 



### 四、goroutine之间的通信

Go 提供Context包，目的是实现不同goroutine之间的通信

那么让不同的goroutine之间配合工作我们有哪些实现方式呢？ 

#### 4.1 使用`sync.WaitGroup`实现

```go
import (
	"fmt"
	"sync"
)

var wait sync.WaitGroup

func SayHi() {
	fmt.Println("hi!")
	wait.Done()
}

func main() {
	wait.Add(1)
	go SayHi()
	wait.Wait()
	fmt.Println("main end")
}
```

#### 4.2 使用一个全局变量当作标志位

```go
var wait sync.WaitGroup
var exit bool

func SayHi() {
	for {
		fmt.Println("hi")
		time.Sleep(time.Second)
		if exit {
			break
		}
	}
	wait.Done()
}

func main() {
	wait.Add(1)
	go SayHi()
	time.Sleep(time.Second*5)
	exit = true
	wait.Wait()
	fmt.Println("main end")
}
```

#### 4.3 手动使用channel控制不同goroutine之间的通信

```go
var wait sync.WaitGroup
var exit bool

func SayHi(exitChan chan struct{}) {
LOOP:
	for {
		fmt.Println("hi")
		time.Sleep(time.Second)
		select {
		case <-exitChan:
			break LOOP
		default:

		}
	}
	wait.Done()
}

func main() {
	var exitChan = make(chan struct{})
	wait.Add(1)
	go SayHi(exitChan)
	time.Sleep(time.Second*5)
	exitChan <- struct{}{}
	close(exitChan)
	wait.Wait()
	fmt.Println("main end")
}
```

#### 4.4 使用context 实现

使用context控制goroutine之间的关系,  明显要更加优雅一些

```go

var wait sync.WaitGroup

func SayHi(ctx context.Context) {
LOOP:
	for {
		fmt.Println("hi")
		time.Sleep(time.Second)
		select {
		case <-ctx.Done():
			break LOOP
		default:
		}
	}
	wait.Done()
}

func main() {
	ctx,cancel := context.WithCancel(context.Background())
	wait.Add(1)
	go SayHi(ctx)
	time.Sleep(time.Second*5)
	cancel()
	wait.Wait()
	fmt.Println("main end")
}

```



### 五、With系列函数

#### 5.1 WithCancel

```go
func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
```

接收一个父Context , 返回一个子Context的副本, 当调用cancel()函数 , 或者是关闭父context的Done通道是, 将关闭副本的Done()通道, 从而实现在 main goroutine中实现对其子goroutine的控制

示例: 在main goroutine中, 控制当达到一定的条件时, 所有的子go rountine退出

```go
func gen(ctx context.Context) <-chan int {
	dst := make(chan int)
	n := 1
	go func() {
		for {
			select {
			case <-ctx.Done():
				return // return结束该goroutine，防止泄露
			case dst <- n:
				n++
			}
		}
	}()
	return dst
}

func main() {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel() // 当我们取完需要的整数后调用cancel

	// 循环从channel中往外读值
	for n := range gen(ctx) {
		fmt.Println(n)
		// 当n==5时, 调用cancel
		if n == 5 {
			break
		}
	}
}
```



#### 5.2 WithDeadline 和 WithTimeout

```go
 // 指定一个明确的时间 	
 d := time.Now().Add(50 * time.Millisecond)
 ctx, cancel := context.WithDealline(context.Background(),d)

 // 指定一个相对的时间, 一般在设置超时时间使用
  ctx, cancel := context.WithDealline(context.Background(),time.Millisecond*50)
```



* WithDeadline

当时间过期, 或者是cancel()函数被调用了, 或者是父Context的上下文的Done通道被关闭了, 以最先发生的情况为准, 控制ctx.Done()的下一步行为

```go
func main() {
	d := time.Now().Add(50 * time.Millisecond)
	ctx, cancel := context.WithDeadline(context.Background(), d)

	// 尽管ctx会过期，但在任何情况下调用它的cancel函数都是很好的实践。
	// 如果不这样做，可能会使上下文及其父类存活的时间超过必要的时间。
	defer cancel()

    // 使用select让主程序等待
    // 等待1s后退出, 或者第二种情况, 超时后设置ctx.Done()返回空的结构体, 表示完成
	select {
	case <-time.After(1 * time.Second):
		fmt.Println("oversleep")
	case <-ctx.Done():
		fmt.Println(ctx.Err())
	}
}

// 输出结果:
context deadline exceeded
```



* WithTimeout

使用场景:  比如正常情况下, 我们在一个无限循环中去获取一个数据库的连接需要10毫秒 ,  但是也不排出有超时的可能,  如果一直获取失败,  我们也得退出循环, 节省资源,  现在就能使用 WithTimeout去控制超时的动作

```go
var wg sync.WaitGroup

func worker(ctx context.Context) {
LOOP:
	for {
		fmt.Println("db connecting ... ")
		time.Sleep(time.Millisecond * 10)

		select {
		case <-ctx.Done():
			break LOOP
		default:
		}
	}
	fmt.Println("done")
	wg.Done()
}

func main() {
	// 创建context, 并设置50毫秒的超时世
	ctx, cancel := context.WithTimeout(context.Background(), time.Millisecond*50)
	wg.Add(1)
	go worker(ctx)
	time.Sleep(time.Second * 5)
	cancel()
	wg.Wait()
	fmt.Println("over")
}

```

#### 5.3 WithValue

使用场景,  比如一个请求来了我们将它放入goroutine中处理,  Server在 main goroutine, 如果想传递给处理请求的goroutine值的话, 我们可以使用WithValue

```go
type TraceCode string
var wg sync.WaitGroup

func worker(ctx context.Context) {
    // 构建相应的key
	key:=TraceCode("trance_code")
    // 根据指定的key,从Context里面取出数据
	tranceCode,ok :=ctx.Value(key).(string)
	if !ok{
		fmt.Println("invalid trace code")
	}

LOOP:
	for {
		fmt.Println("trance_code: ",tranceCode)
		time.Sleep(time.Millisecond * 10)
		select {
		case <-ctx.Done():
			break LOOP
		default:
		}
	}
	fmt.Println("done")
	wg.Done()
}

func main() {
	// 创建context, 并设置50毫秒的超时世
	ctx, cancel := context.WithTimeout(context.Background(), time.Millisecond*50)
	ctx = context.WithValue(ctx,TraceCode("trance_code"),"123456")
	wg.Add(1)
	go worker(ctx)
	time.Sleep(time.Second * 5)
	cancel()
	wg.Wait()
	fmt.Println("over")
}

```



### 六、Context使用的注意事项

* 推荐用参数的形式, 显示的传递Context
* 以Context作为参数的函数, 应该将Context放置在第一位
* 如果一个函数需要接收一个Context,  我们还不知道传递什么Context, 不要传递nil , 传递context.TODO()
* Context的**Value相关方法应该传递请求域的必要数据**, 不应该用于传递可选参数
* Context是线程安全的, 可以放心的再多个goroutine中使用



### 七、客户端超时取消案例

Server端,  随机产生 慢响应和快响应

```go

func indexHandler(w http.ResponseWriter , r *http.Request){
//	number:= rand.Intn(2)
	number:= 0
	if number == 0 {
		time.Sleep(time.Second*5)
		fmt.Fprintf(w,"slow response")
		return
	}
	fmt.Fprintf(w,"quick response")

}

func main() {
	http.HandleFunc("/", indexHandler)
	err:=http.ListenAndServe(":8888", nil)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
}
```

客户端,

```go
 // 为了方便传递参数, 用结构体封装 响应 和 err
type respData struct {
	resp *http.Response
	err  error
}

var wg sync.WaitGroup

func doCall(ctx context.Context) {
	transport := http.Transport{
		DisableKeepAlives: true,
	}
	// 频繁的请求可以自定义全局的client, 使用自定义的协议, 开启长连接
	client := http.Client{
		Transport: &transport,
	}
	
    // 创建chan , 用于当前goroutine和发送请求的goroutine通信
	respchan := make(chan *respData, 1)
	
    // 构造请求对象
	req, err := http.NewRequest("GET", "http://localhost:8888/", nil)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}

	wg.Add(1)
	defer wg.Wait()

	// 在新的goroutine中 发送请求,获取响应
	go func() {
		resp, err := client.Do(req)
		if err != nil {
			fmt.Printf("error: %v\n", err)
			return
		}
		fmt.Println("response: ", resp)
        // 为了方便传递参数, 用结构体封装 响应 和 err , 返回时为了高效,而使用指针
		rd := &respData{
			resp: resp,
			err:  err,
		}
        // 把结果写出去
		respchan <- rd
		wg.Done()
	}()

	// 添加超时的机制
	select {
	case <-ctx.Done():
		fmt.Println("请求超时了")
	case result := <-respchan:
		fmt.Println("成功访问服务端")
		if result.err != nil {
			fmt.Println("出现错误,", result.err)
			return
		}
		defer result.resp.Body.Close()
		bytes, _ := ioutil.ReadAll(result.resp.Body)
		fmt.Println("resp: ", string(bytes))
	}

}

func main() {
	// 定义一个100ms的超时请求
	ctx, cancel := context.WithTimeout(context.Background(), time.Millisecond*100)
	defer cancel()
	doCall(ctx)
}
```













































































