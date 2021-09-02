# 概述
suffixarray模块提供了基于前缀数组的子串检索功能，能够在byte数组中检索指定子串，并获得其索引下标。

# 创建前缀数组
可用通过New方法创建一个前缀数组，方法声明如下：

```
func New(data []byte) *Index
```
此外可以通过其Bytes方法，获取原始byte数组，方法声明如下：

```
func (x *Index) Bytes() []byte
```

# 数据检索
Index对象上提供了两种检索方法，FindAllIndex和Lookup。

其中FindAllIndex接收一个正则表达式，并返回长度不超过n的匹配索引列表，n<0时返回全部结果，方法声明如下：

```
func (x *Index) FindAllIndex(r *regexp.Regexp, n int) (result [][]int)
```

而Lookup方法接收一个byte列表，返回长度不超过n的匹配索引列表，n<0时返回全部结果，方法声明如下：

```
func (x *Index) Lookup(s []byte, n int) (result []int)
```

下面是一个简单的使用实例

```
package main

import (
	"index/suffixarray"
	"fmt"
	"sort"
)

func main() {

	source := []byte("hello world, hello china")
	index := suffixarray.New(source)

	offsets := index.Lookup([]byte("hello"), -1)

	sort.Ints(offsets)

	fmt.Printf("%v", offsets)

}
```

