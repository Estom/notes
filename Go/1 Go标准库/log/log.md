# 概述
log 模块用于在程序中输出日志，它的使用十分简单，类似于fmt中的Print，一个最简单的示例如下：

```
package main

import "log"

func main() { 
    log.Print("Hello World")
}
```
上面的程序会在命令行打印一条日志:

```
>>> 2018/05/16 16:48:06 Hello World
```

# Logger
Logger是写入日志的基本组件，log模块中存在一个标准Logger，可以直接通过log进行访问，所以在上一节的例子中可以直接使用log.Print进行日志进行输出。但是在实际使用中，不同类型的日志可能拥有需求，仅标准Logger不能满足日志记录的需求，通过创建不同的Logger可以将不同类型的日志分类输出。使用logger前需要首先通过New函数创建一个Logger对象，函数声明如下：

```
func New(out io.Writer, prefix string, flag int) *Logger
```
函数接收三个参数分别是日志输出的IO对象，日志前缀和日志包含的通用信息标识位，通过对它们进行设置可以对Logger进行定制。其中IO对象通常是标准输出os.Stdout，os.Stderr，或者绑定到文件的IO。日志前缀和信息标识位可以对日志的格式进行设置。

一条日志由三个部分组成，其结构如下：

```
{日志前缀} {标识1} {标识2} ... {标识n} {日志内容}
```

- 日志前缀，通过prefix参数设置，可以是任意字符串
- 标识，通过flags参数设置，当某个标识被设置，会在日志中进行显示，log模块中定义了如下标识，多个标识通过按位或进行组合：
	- Ldate 显示当前日期（当前时区）
	- Ltime 显示当前时间（当前时区）
	- Lmicroseconds 显示当前时间（微秒）
	- Llongfile 包含路径的完整文件名
	- Lshortfile 不包含路径的文件名
	- LUTC Ldata和Ltime使用UTC时间
	- LstdFlags 标准Logger的标识，等价于 Ldate | Ltime

```
package main

import (
"os"
"log"
)

func main() {
    prefix := "[THIS IS THE LOG]"
    logger := log.New(os.Stdout, prefix, log.LstdFlags | log.Lshortfile)
    logger.Print("Hello World")
}
```
上面的程序将会输出如下内容，可以看到日志由上述三个部分组成。

```
[THIS IS THE LOG]2018/05/16 17:12:19 log.go:11: Hello World
```

# 更多的输出方式
log模块中日志输出分为三类，Print，Fatal，Panic。Print是普通输出；Fatal是在执行完Print之后，执行 os.Exit(1)；Panic是在执行完Print之后调用panic()方法。

除了基础的Print之外，还有Printf和Println方法对输出进格式化，对于Fatal和Panic也是类似，具体的函数声明 [Log Index](https://www.godoc.org/log#pkg-index)
## 日志分级
Go的log模块没有对日志进行分级的功能，对于这部分需求可以在log的基础上进行实现，下面是一个简单的INFO方法实现。

```
package main

import (
    "os"
    "log"
)

func main() {
    var (
	logger = log.New(os.Stdout, "INFO: ", log.Lshortfile)
	infof = func(info string) {
		logger.Print(info)
	}
    )
    infof("Hello world")
}
```


