### flag标准库简介

flag标准库，是Go为我们提供的原生的命令行解析，用它开发命令行工具将更为简单

文档： <https://studygolang.com/pkgdoc> 



### flag的参数类型

flag包支持的命令行参数类型有`bool`、`int`、`int64`、`uint`、`uint64`、`float` `float64`、`string`、`duration`。

| flag参数     | 有效值                                                       |
| ------------ | ------------------------------------------------------------ |
| 字符串flag   | 合法字符串                                                   |
| 整数flag     | 1234、0664、0x1234等类型，也可以是负数。                     |
| 浮点数flag   | 合法浮点数                                                   |
| bool类型flag | 1, 0, t, f, T, F, true, false, TRUE, FALSE, True, False。    |
| 时间段flag   | 任何合法的时间段字符串。如”300ms”、”-1.5h”、”2h45m”。 合法的单位有”ns”、”us” /“µs”、”ms”、”s”、”m”、”h”。 |

###注册flag参数的方式

#### 将结果保存在 `*type`指针中

```go
	import "flag"
	
	// flag.type 的返回值是指针
	var ip = flag.Int("flagname", 1234, "help message for flagname")
	ip := flag.Int("flagname", 1234, "help message for flagname")
```

#### 将结果保存在变量中

```go
	var flagvar int
	flag.IntVar(&flagvar, "flagname", 1234, "help message for flagname")
```

#### 自定义flag类型

```go
// 默认值就是该变量的初始值。
flag.Var(&flagVal, "name", "help message for flagname")
```



### `flagParse()`

**所有的flag完成注册之后， 使用函数`flag.Parse()` 进行解析**

解析后，注册进flag的参数可以通过`flag.Args() ` 或者`flag.Args(i)`取出

- `-flag xxx` （使用空格，一个`-`符号）
- `--flag xxx` （使用空格，两个`-`符号）
- `-flag=xxx` （使用等号，一个`-`符号）
- `--flag=xxx` （使用等号，两个`-`符号）



其他flag函数

```go
flag.Args()  ////返回命令行参数后的其他参数，以[]string类型
flag.NArg()  //返回命令行参数后的其他参数个数
flag.NFlag() //返回使用的命令行参数个数
```



### 示例

```go
func main() {
	//定义命令行参数方式1
	var name string
	var age int
	var married bool
	var delay time.Duration
	flag.StringVar(&name, "name", "张三", "姓名")
	flag.IntVar(&age, "age", 18, "年龄")
	flag.BoolVar(&married, "married", false, "婚否")
	flag.DurationVar(&delay, "d", 0, "延迟的时间间隔")

	//解析命令行参数
	flag.Parse()
	fmt.Println(name, age, married, delay)
	//返回命令行参数后的其他参数
	fmt.Println(flag.Args())
	//返回命令行参数后的其他参数个数
	fmt.Println(flag.NArg())
	//返回使用的命令行参数个数
	fmt.Println(flag.NFlag())
}
```

命令行参数提示：

```go
$ ./flag_demo -help
Usage of ./flag_demo:
  -age int
        年龄 (default 18)
  -d duration
        时间间隔
  -married
        婚否
  -name string
        姓名 (default "张三")
```

正常使用命令行flag参数 

```go
$ ./flag_demo -name 沙河娜扎 --age 28 -married=false -d=1h30m
沙河娜扎 28 false 1h30m0s
[]
0
4
```











### os.Args

如果不想使用flag标准库可以使用os.Args简单的获取到命令行参数

```go
func main() {
	if len(os.Args) > 0{
		for index,args :=range os.Args{
			fmt.Printf("index: %v value:%v",index,args)
		}
	}
}
```

os.Args中，存储启动编译好的go文件时输入的所有参数， **第一个参数是可执行文件本身**