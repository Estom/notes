# 概述
sort包实现了对列表的排序以及在有序列表上的二分查找等操作
## 通用排序函数
### 接口实现
要使用sort包的各个函数，需要实现sort.Interface，定义如下：

```
type Interface interface {
        Len() int            // 返回当前元素个数
        Less(i, j int) bool. // 判断第i个元素是小于第j个元素
        Swap(i, j int)       // 交换两个元素
}
```
### Sort
sort包最核心的函数，Sort，用于对一个列表上的元素进行排序，Sort函数会在原有列表上进行排序，函数声明如下：

```
func Sort(data Interface)
```
### Stable
相较于Sort函数，Stable函数也用于对一个列表进行排序，但是它额外提供保证排序算法是稳定的，也就是排序前后值相同的两个元素相对位置不发生变化，函数声明和Sort类似。

```
func Stable(data Interface)
```
### Slice
Slice函数用于对一个Slice进行排序，这是实际使用中更为常用的一个函数，函数接收两个参数。第一个是需要排序的Slice；第二个是Slice元素比较函数，它类似于前面sort.Interface里的Less方法。函数声明如下：

```
func Slice(slice interface{}, less func(i, j int) bool)
```

### Reverse
Reverse函数用于翻转一个列表并返回翻转后的列表，函数声明如下：

```
func Reverse(data Interface) Interface
```


### IsSorted
IsSorted函数用于判断一个列表是否有序，函数声明如下：

```
func IsSorted(data Interface) bool
```

### Search
Search函数可以在一个有序列表上进行二分查找操作，它接收两个参数，第一个为从第一个元素开始搜索的元素个数；第二个参数是一个函数，通过接收一个函数f作为参数，找到使得f(x)==true的元素，函数声明如下：

```
func Search(n int, f func(int) bool) int
```

## 特定类型方法

除了上面的通用函数之外，sort包还对几个常用基础类型（int，float，string和slice）的排序提供了支持，对于每个类型，分别实现了上一节的各个函数。具体函数定义见 [Package sort](https://golang.org/pkg/sort/)

# 使用示例
下面以Slice排序为例进行说明，示例中声明了一个类型Person，根据Person.Age字段对数据进行排序。

```
package main

import (
	"sort"
	"fmt"
)

type Person struct {
	Name string
	Age int
}


func main() {

	data := []Person{
		{"Alice", 20},
		{"Bob", 15},
		{"Jane", 30},
	}

	sort.Slice(data, func(i, j int) bool {
		return data[i].Age < data[j].Age
	})

	for _, each := range data {
		fmt.Println("Name:", each.Name, "Age:", each.Age)
	}
}
```