### 一. package

Go语言中,为我们提供了多个内置包, 如fmt , os , io等等

我们也可以定义自己的包,  一个package . 可以简单的理解成它是用来存放 `*.go`文件的文件夹

所有的`*.go`文件的第一行都要添加如下的代码

```go
package 包名
```



### 二. 包名的命名规范

* **同一个文件夹下直接包含的文件只能属于一个package, 同一个package不能在多个文件夹下**
* 包名可以不和文件夹的名字一样
* 包名中不能含有`-` 符号
* 只有 `package main` 才会被编译成可执行的文件



### 三. 可见性

如果包内的内容想对外暴露可见, 要求将变量名 / 函数名 / 结构体名**首字母大写**



### 四. 包的导入

```go
// 单行导入
//import "code.github.com/changwu/2020-03-17/helloworld"

// 单行导入+自定义包名
 import hw "code.github.com/changwu/2020-03-17/helloworld"

// 单行导入+匿名导入
 import _ "code.github.com/changwu/2020-03-17/helloworld"

import (
	// 多行导入
	//"code.github.com/changwu/2020-03-17/helloworld"
    
	// 多行导入+自定义包名
	//"code.github.com/changwu/2020-03-17/helloworld"
    
	// 多行导入+匿名导入
	//_ "code.github.com/changwu/2020-03-17/helloworld"
)

func main(){
	hw.SayHello()
}

// 补充: 
点（.）标识的包导入后，调用该包中函数时可以省略前缀包名。点（.）操作的语法为：
import (
. "package1"
. "package2"
. "package3" ... )
```

### 五. `init()`

包内部都会有一个`init()` , 每次导入时都会先触发被导入包的`init()`的调用, 再触发自己的`init()`的调用

```go
import (
	hw "code.github.com/changwu/2020-03-17/helloworld"
	"fmt"
)

func init(){
	fmt.Println("this is structToJson init()")
}


func main(){
	/**
	  this is hello world init()
	  this is structToJson init()
	 */
	hw.SayHello()
}
```



#### 5.1 init()函数的执行时机

```go
全局变量 -->  init() --> main()
```



#### 5.2 是否可以主动调用`init()`方法

不可以