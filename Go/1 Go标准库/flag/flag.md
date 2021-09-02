# 概述
在运行命令行程序时，通常通过命令行参数对程序运行进行配置。在go程序中使用flag包，可以快速构建命令行程序，对于程序使用者只需要声明所需命令行参数。
# 使用示例
创建命令行程序可以分为两步:

- 声明命令行参数
- 运行`flag.Parse`，对参数进行解析

然后就可以读取命令行参数了。例如如下程序可以创建一个命令行程序`demo --foo hello --bar world`

```
package main

import (
     "fmt"
     "flag"
)

func main() {
   foo := flag.String("foo", false, "Foo")
   bar := flag.String("bar", "", "Bar")
   
   flag.Parse()
   fmt.Print(*foo, *bar)
}
```
# VarXXX 和 XXX
flag包中对多中提供了两类参数声明函数，下面以String类型为例，两个函数声明如下：

```
func String(name string, value string, usage string) *string

func StringVar(p *string, name string, value string, usage string)
```
String函数接收三个参数，分别是命令行参数名，即`--<name>`；参数默认值；参数描述，也就是help命令显示的帮助描述；并返回对应参数值的指针。StringVar与之不同在于将返回值改为函数参数。

除了对string类型的支持外，flag包还提供了多个类似的函数用于解析不同类型的参数，函数名进行对应的替换即可，包括：

- Int，Int64，Uint
- Bool
- Float
- Duration

# 其他
以上几乎就是使用flag包的全部了，flag包中的其他函数可以直接对其底层实现进行操作，普通命令行程序中不会使用。

在实际使用中，建议将参数声明部分放到var代码段中，对上面的代码进行修改后如下所示。

```
package main

import (
     "fmt"
     "flag"
)

var (
   foo = flag.Bool("foo", false, "Foo")
   bar = flag.String("bar", "", "Bar")
)

func main() {
   flag.Parse()
   fmt.Print(*foo, *bar)
}
```
