

### 一. 时间类型

获取到年月日, 时分秒

```go
func main() {
	now := time.Now()
	//current time 2020-04-02 08:08:06.8322921 +0800 CST m=+0.006981901 
	fmt.Printf("current time %v \n",now)
	year := now.Year()
	month := now.Month()
	day := now.Day()

	hour := now.Hour()
	minute := now.Minute()
	second := now.Second()
	//2020-04-02 08-08-06 
	fmt.Printf("%d-%02d-%02d %02d-%02d-%02d \n",year,month,day,hour,minute,second)
}
```



### 二. 时间戳

时间戳指的是 从1970年1月1日(08:00:00GMT)到现在的毫秒数

```go
func main() {
	now := time.Now()
	// 时间戳
	unix := now.Unix()
	// 纳秒的时间戳
	nano := now.UnixNano()
	fmt.Printf(" %v \n",unix)// 1585786306 
	fmt.Printf(" %v \n",nano)// 1585786306678067200
}
```



### 三. 时间间隔

Go定义了时间间隔类型常量, 我们可以直接使用`time.Duration`

```go
const (
	Nanosecond  Duration = 1
	Microsecond          = 1000 * Nanosecond
	Millisecond          = 1000 * Microsecond
	Second               = 1000 * Millisecond
	Minute               = 60 * Second
	Hour                 = 60 * Minute
)
```



### 四. 时间计算

#### 4.1 当前时间加一小时

```go
func main() {
	now := time.Now()
	later := now.Add(time.Hour) // 当前时间加1小时后的时间
	fmt.Println(later)
}
```

#### 4.2 两时间之差

```go
// 返回一个时间差  t-u
func (t Time) Sub(u Time) Duration
```

#### 4.3 判断两时间是否相等

本方法不同于简单的 t==u , 内部的实现考虑了时区的影响

```go
func (t Time) Equal(u Time) bool
```

#### 4.4 判断时间的前后

```go
func (t Time) Before(u Time) bool
func (t Time) After(u Time) bool
```



### 五. 定时器

如下是定时器demo, 每秒都会执行一次任务

```go
func myTick(){
	ticker := time.Tick(time.Second)
	for i:=range ticker{
		fmt.Println(i)
	}
}

```



### 六. 格式化

Go诞生于2009年11月10日 

Go 语言的格式化和其他语言是不同的,  格式按照美国人为了好记忆的日期书写顺序写的一个1234567。1月2号下午3时4分5秒 06年 7时区 

```go
func formatDemo() {
	now := time.Now()
	// 格式化的模板为Go的出生时间2006年1月2号15点04分 Mon Jan
	// 24小时制
	fmt.Println(now.Format("2006-01-02 15:04:05.000 Mon Jan"))
	// 12小时制
	fmt.Println(now.Format("2006-01-02 03:04:05.000 PM Mon Jan"))
	fmt.Println(now.Format("2006/01/02 15:04"))
	fmt.Println(now.Format("15:04 2006/01/02"))
	fmt.Println(now.Format("2006/01/02"))
}

// 解析字符串格式的时间
func Parse(){
    now := time.Now()
	fmt.Println(now)
	// 加载时区
	loc, err := time.LoadLocation("Asia/Shanghai")
	if err != nil {
		fmt.Println(err)
		return
	}
	// 按照指定时区和指定格式解析字符串时间
	timeObj, err := time.ParseInLocation("2006/01/02 15:04:05", "2019/08/04 15:14:20", loc)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(timeObj)
	fmt.Println(timeObj.Sub(now))
}
```



























































