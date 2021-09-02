# 概述
context也是并发环境的一个常用标准库，它用于在并发环境下在协程之间安全的传递某些上下文信息。

一个经典的应用场景是服务器模型，当服务器处理接收到的请求时，通常需要并发的运行多个子任务，例如访问服务器，请求授权等。而这些任务都会以子协程的方式运行，也就是说一个请求绑定了多个协程，这些协程需要共享或传递某些请求相关的数据；此外当请求被撤销时，也需要有一种机制保证每个子协程能够安全的退出。而context包就给提供了上面说到的这些功能。
# Context
Context是一个上下文对象，其声明如下：

```
type Context interface {
    Deadline() (deadline time.Time, ok bool)
    // 获取deadline
    Done() <-chan struct{}
    // 
    Err() error
    Value(key interface{}) interface{}
}
```
## 创建Context
在context中有两种基础的Context，分别通过Backgroud和TODO函数创建，下面是具体的函数声明：

```
func Background() Context

func TODO() Context
```
通常情况下，使用Backgroud函数即可，调用函数可以得到一个Context，但是这个Context不能够直接使用，只是作为一个基础的根Context使用，所有的Context都需要从这个Context上衍生。
# 衍生 Context
要创建一个可使用的Context，你需要使用下面的三个函数，在根Context衍生出新的Context。当然，由于Context是以树状结构存在的，你也可以通过调用这些函数在任何一个Context上创建子Context。

## WithCancel
WithCancel会返回一个可以取消的Context，函数声明如下：

```
func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
```
函数接收一个Contex作为参数，返回两个值，第一个是新创建的Context，结构上来看，这个Context是输入Context的子节点；第二个参数是cancel函数，用于向这个Context发送cancel信号。由于Context存在继承关系，当父节点调用cancel子节点的cancel也会被调用。
### CancelFunc & Done
这里介绍一下CancelFunc，Done这一对函数，类似于signal，wait；CancelFunc函数会向Context发送cancel信号；而Done方法返回一个通道，若当前Context被cancel，那么这个通道会被关闭；也就是说，通过CancelFunc和Done的协作，可以对子协程传递cancel信号，一个常用的代码段如下：

```
func Stream(ctx context.Context, out chan<- Value) error {
     for {
             v, err := DoSomething(ctx)
          	if err != nil {
          	    return err
          	}
          	select {
          	case <-ctx.Done():
          		return ctx.Err()
          	case out <- v:
          	}
       }
}
```
子协程不停地运行并检查当前任务是否被取消，若被取消则结束当前任务并返回。
## WithDeadLine & WithTimeout
和WithCancel类似，WithDeadLine和WithTimeout额外接收一个参数分别是消亡时间和超时时间。也就是说对于这两类Context，即使不主动取消，当发生超时时，该Context也会接收到cancel信号。函数声明如下：

```
func WithDeadline(parent Context, d time.Time) (Context, CancelFunc)

func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
```
同样的，即使设置了很大的值，但是子Context的deadline和timeout也不会超过父Context的值。

## WithValue
这类Context用于在同一个上下文中传递数据，这个Context是不可取消的，其函数声明如下：

```
func WithValue(parent Context, key, val interface{}) Context
```
除了Context参数外，还接收key和val参数用于保存数据，数据以键值对的方式存储；然后可以通过Context.Value(key)来获取对应的值。
# 一些建议
- 子协程不能cancel父协程的Context
- Context需要显式的传递，而不是作为某个类型的一个字段