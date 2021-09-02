# 8 指针、make、new

## 8.1 指针（pointer）

Go 语言中没有指针操作，只需要记住两个符号即可：

* `&` 取内存地址
* `*` 根据地址取值

```go
package main

import "fmt"

func main() {
	a := 18
	// 获取 a 的地址值并复制给 p
	p := &a

	//  p 的类型：*int，p 的取值：0xc000018078
	fmt.Printf("p 的类型：%T，p 的取值：%v\n", p, p)

	b := *p
	// b 的类型：int，b 的取值：18
	fmt.Printf("b 的类型：%T，b 的取值：%v\n", b, b)
}
```

指针传值示例：

```go
package main

import "fmt"

func main() {
	a := 10
	modify1(a)
	// 10
	fmt.Println(a)

	modify2(&a)
	// 100
	fmt.Println(a)
}

func modify1(x int) {
	x = 100
}

// 需要传入一个 int 变量的地址值
func modify2(x *int) {
	*x = 100
}
```

## 8.2 make 和 new 

先看一段代码，

```go
package main

import "fmt"

func main() {

	var a *int
	*a = 100
	fmt.Println(a)

	var b map[string]int
	b["xxx"] = 100
	fmt.Println(b)
}
```

执行上面的代码会触发 panic （即异常）。错误信息为：panic: runtime error: invalid memory address or nil pointer dereference.——非法的内存地址或者空指针引用。这是因为：

在 Go 语言中，引用类型数据声明之后还必须初始化，初始化的操作就是为其分配内存空间。**`new` 和 `make` 的作用就是为引用类型数据分配内存空间。**
> 值类型数据声明之后系统会默认为其分配内存。

### 8.2.1 new

`new` 用来构建内存地址类型数据。 

```go
package main

import "fmt"

func main() {

	// 构建一个 int 类型的内存地址
	a := new(int)
	*a = 100

	// a 表示的内存地址：0xc0000b4008 , a 的值：100
	fmt.Printf("a 表示的内存地址：%p , a 的值：%d\n", a, *a)
}
```

### 8.2.2 make

make 也是用于分配内存的， 只用于 `slice`、`map` 以及 `channel` 的内存创建，而且他的返回值就是这三种类型本身，而不是他们的指针。make 函数的函数签名如下：

```go
func make ( t Type, size ...IntegerType) Type
```

我们在使用  `slice`、`map` 以及 `channel`  时都需要使用 make 进行初始化，然后才可以对他们进行操作。

```go
package main

import "fmt"

func main() {

	// 声明一个键为 string 类型，值为 int 类型的 map
	var b map[string]int
	// 通过 make 初始化 map, 并指定其容量为 10
	b = make(map[string]int, 10)
	b["xxx"] = 100

	// map[xxx:100]
	fmt.Println(b)
}
```

### 8.2.3 new 和 make 的区别

* make 和 new 都是用来申请内存地址的
* new 通常用于给基本数据类型申请内存，返回的是对应类型的指针，如 `*string`、`*int`
* make 专用于给 map、slice、channe 申请内存空间，返回的是对应的类型本身