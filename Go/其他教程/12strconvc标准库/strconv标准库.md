### Go是强类型语言

Go是强类型的语言,  换句话说, 不同类型的变量之间不能随意转换

比如:  int8  int16 int32 int64 之间虽然可以进行转换, 但是 int 和 string之间就不能随意转换



### strconv

strconv包实现了基本**数据类型与其字符串**表示的转换

主要有以下常用函数： `Atoi()`、`Itia()`、parse系列、format系列、append系列 



* string 转int

```go
func Atoi(s string) (i int, err error)
```

* int 转  string

```go
func Itoa(i int) string
```



> **无论是 Atoi  还是 Itoa, 其中的 i 表示 int , a代表string,  之所以用a代表string , 是因为在C语言中, 没有string,  所有C语言不得不使用array表示字符串**



* 将字符串转换成指定的值

```go
ParseBool()
ParseFloat()
ParseInt()
ParseUint()
```



* 将其他类型的值, 格式化为string

```go
func FormatBool(b bool) string
func FormatInt(i int64, base int) string
func FormatUint(i uint64, base int) string
func FormatFloat(f float64, fmt byte, prec, bitSize int) string
```



* 其他

```go
// 返回一个字符是否是可打印的，和unicode.IsPrint一样，r必须是：字母（广义）、数字、标点、符号、ASCII空格。
func IsPrint(r rune) bool

// 返回字符串s是否可以不被修改的表示为一个单行的、没有空格和tab之外控制字符的反引号字符串。
func CanBackquote(s string) bool
```













































