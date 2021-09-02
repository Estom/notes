# 概述
字符串是一个十分常用的基础类型，strings包提供了很多函数对string类型变量的操作。这些函数的调用方式大多类似，通过传入一个字符串为参数，在字符串上进行相应的处理。这些函数主要可以分为下面几类：

- 字符串搜索和匹配
- 字符串拆分
- 字符串修改
- 其他独立的函数

# 字符串搜索与匹配
strings.Contains可以检测字符串是否包含某个子串；strings.ContainsRune可以检测字符串是否包含某个字符；strings.ContainsAny可以检测字符串是否包含字符集中的某个字符。详细函数声明如下：

```
func Contains(s, substr string) bool

func ContainsRune(s string, r rune) bool

func ContainsAny(s, chars string) bool
```
除了简单的判断字符串包含，使用strings.Index可以在字符串中搜索某个子串，并得到对应子串起始索引下标，若不存在对应子串则返回-1。函数声明如下：

```
func Index(s, substr string) int
```
除了对子串进行搜索之外，也可以对某个字节，字符，字符集合进行搜索。具体声明如下：

```
func IndexByte(s string, c byte) int   // 字节搜索

func IndexRune(s string, r rune) int。  // 字符搜索

func IndexAny(s, chars string) int。    // 字符集合搜索，匹配chars中的任何一个字符
```
上述的所有搜索操作都返回第一个匹配的索引；除此之外，strings包也提供了一系列函数获取对应元素的最后一个匹配项的索引下标。对应于每个Index函数，都有一个LastIndex函数。例如Index返回第一个匹配的子串的起始索引，LastIndex返回最后一个匹配子串的起始索引。详细函数声明如下：

```
func LastIndex(s, substr string) int

func LastIndexByte(s string, c byte) int   

func IndexAny(s, chars string) int。    
```
# 字符串拆分
字符串拆分是字符串的常见操作。strings支持两类拆分操作：Split和SplitAfter。两者的区别在于Split拆分后的结果中不包含分隔符；而SplitAfter包含分隔符。例如`strings.Split("a,b,c", ",")`结果为`["a", "b", "c"]`;`strings.SplitAfter("a,b,c", ",")`结果为`["a,", "b,", "c"]`。函数声明如下：

```
func Split(s, sep string) []string

func SplitAfter(s, sep string) []string
```

前面的Split和SplitAfter都只能指定一个分隔符，那么如果希望指定一类分隔符应该怎么做呢。在strings模块中，提供了FieldsFunc函数，通过传递一个函数来确定一个字符是否为分隔符。下面来看一个例子，所有非数字和非字母的字符都被认为是分隔符而被跳过。

```
package main

import (
	"fmt"
	"strings"
	"unicode"
)

func main() {
	str := "  hello&$ world"

	f := func(c rune) bool {
		return !unicode.IsLetter(c) && !unicode.IsNumber(c)
	}
	fmt.Printf("%q", strings.FieldsFunc(str, f))
}
```

函数声明如下：

```
func FieldsFunc(s string, f func(rune) bool) []string
```
实际使用中，也可以使用Fields函数，对字符串中空格进行删除，相当于FieldsFunc(s, unicode.IsSpace)

```
func Fields(s string) []string
```
# 字符串修改

Trim系列函数可以删除字符串首尾的连续多余字符，包括：

- Trim，删除字符串首尾的多余字符
- TrimLeft，删除字符串首的多余字符
- TrimRight，删除字符串尾部的多余字符
- TrimSpace，删除字符串首尾的空格

函数声明如下：

```
func Trim(s string, cutset string) string

func TrimLeft(s string, cutset string) string

func TrimRight(s string, cutset string) string

func TrimSpace(s string) string
```


除此之外，还可以通过传递函数的方式对删除字符进行更精确的选择，这里不再展开，具体见[TrimFunc](https://golang.org/pkg/strings/#TrimFunc)。

除了对字符进行删除之外，strings包也可以字符串进行格式化，通过一系列函数提供了支持，其中最为常用的是`ToLower`和`ToUpper`分别用于将字符串转化为小写和大写字母，函数声明如下：

```
func ToLower(s string) string

func ToUpper(s string) string
```

# 其他函数
除了上述几类函数之外，strings包还提供了下面几个实用函数：

- Join，将多个字符串组装成一个字符串，子串间通过分隔符连接（split的逆操作）；
- Compare，通过字典序比较两个字符串的大小等价于>,<,==运算；
- Count，统计字符串中指定子串的数量，
- Replace，替换字符串中的对应子串

函数声明如下：

```
func Join(a []string, sep string) string

func Compare(a, b string) int

func Count(s, substr string) int
```

