# 9 map

Go 语言中提供的映射关系容器为 `map` ，其内部使用 `散列表（hash）` 实现。它是一种无序的基于 `key-value` 的数据结构。

Go 语言中的 map 是引用类型，必须初始化之后才能使用。

## 9.1 map 定义

Go 语言中 map 的定义语法为：`map[keyType]valueType`，其中：

* keyType 表示键的类型
* valueType 表示值的类型

map 类型变量默认初始值为 nil (引用类型的默认初始值都为 nil), 需要使用 `make()` 函数来分配内存，语法格式为：

```go
make(map[keyType]valueType , cap )
```

上述格式中，`cap` 表示 map 的容量，不是必须的，map 可以动态扩容。但我们通常会在初始化的时候就指定一个合适的容量，因为这样会比动态扩容的执行效率高。

```go
package main

import "fmt"

func main() {

	// 声明一个键为 string 类型，值为 int 类型的 map
	var b map[string]int
	// true
	fmt.Println(nil == b)

	// 通过 make 初始化 map, 并指定其长度为 10。 map 可以自动扩容，但不如声明时指定容量的执行效率高。
	b = make(map[string]int, 10)
	b["aa"] = 100
	b["bb"] = 100

	//map[aa:100 bb:100]
	fmt.Println(b)
}
```


## 9.2 map 的基本使用

### 9.2.1 增值和取值

```go
package main

import "fmt"

func main() {

	var b map[string]int
	// true
	fmt.Println(nil == b)

	b = make(map[string]int, 10)
	b["aa"] = 100
	b["bb"] = 100

	// 获取键对应的值时，使用 map名称[键名] 的格式
	fmt.Println(b["aa"])

	// 不确定是否存在某个键时，使用这种方式获取其值。ok 表示是否有该键，v 表示如果有该键时的值
	v, ok := b["cc"]
	if !ok {
		fmt.Println("b 中不存在键 cc")
	} else {
		fmt.Println("cc对应的值为：", v)
	}
}
```

### 9.2.1 删除某个键值对

删除时使用内置函数 `delete`, 该函数的定义如下：

```go
func delete(m map[Type]Type1, key Type)
```

如果被删除的键存在，直接删除，不存在，则不执行任何操作。

```go
package main

import (
	"fmt"
)

func main() {
	scoreMap := make(map[string]int, 10)
	scoreMap["张三"] = 93
	scoreMap["李四"] = 94
	scoreMap["王五"] = 95

	delete(scoreMap, "张三")
}
```

## 9.3 map 的遍历

### 9.3.1 `for-range` 遍历

```go
package main

import "fmt"

func main() {
	scoreMap := make(map[string]int, 10)
	scoreMap["张三"] = 93
	scoreMap["李四"] = 94
	scoreMap["王五"] = 95

	for k, v := range scoreMap {
		fmt.Println(k, v)
	}
}
```

### 9.3.2 只遍历 key

```go
package main

import (
	"fmt"
)

func main() {
	scoreMap := make(map[string]int, 10)
	scoreMap["张三"] = 93
	scoreMap["李四"] = 94
	scoreMap["王五"] = 95

	for k := range scoreMap {
		fmt.Println(k, scoreMap[k])
	}
}
```

### 9.3.3 只遍历 value

```go
package main

import (
	"fmt"
)

func main() {
	scoreMap := make(map[string]int, 10)
	scoreMap["张三"] = 93
	scoreMap["李四"] = 94
	scoreMap["王五"] = 95

	for _, v := range scoreMap {
		fmt.Println(v)
	}
}
```

### 9.3.4 按照指定顺序遍历

Go 语言中没有 map 专用的排序，需要借助切片的排序实现。

```go
package main

import (
	"fmt"
	"math/rand"
	"sort"
	"time"
)

func main() {
	//初始化随机种子
	rand.Seed(time.Now().UnixNano())

	scoreMap := make(map[string]int, 150)

	for i := 0; i < 100; i++ {
		// 生成 stu 开头的字符串.此处的 %2d 表示使用两位数表示，不足两位则左边补0
		key := fmt.Sprintf("stu%02d", i)
		// 生成 0-99 的随机整数
		value := rand.Intn(100)
		scoreMap[key] = value
	}

	// 取出 map 中的所有 key 存入切片
	keys := make([]string, 0, 200)
	for k := range scoreMap {
		keys = append(keys, k)
	}

	// 对切片进行排序
	sort.Strings(keys)

	// 对排序后的切片进行遍历，并取 map 中的值
	for _, k := range keys {
		fmt.Println(k, scoreMap[k])
	}
}
```

## 9.4 其他相关

### 9.4.1 元素为 map 的切片

```go
package main

import (
	"fmt"
)

func main() {

	// 构建一个切片，容量为 3，元素为 map[string]string
	var mapSlice = make([]map[string]string, 3)
	for index, v := range mapSlice {
		fmt.Printf("index:%d, value:%v \n", index, v)
	}

	fmt.Println()

	// 对切片中的元素进行初始化, 不初始化会报错——map、slice、channel 使用前必须初始化
	mapSlice[0] = make(map[string]string, 10)
	mapSlice[0]["name"] = "张三"
	mapSlice[0]["password"] = "123456"
	mapSlice[0]["address"] = "济南"

	for index, v := range mapSlice {
		fmt.Printf("index:%d, value:%v\n", index, v)
	}
}
```

运行结果如下：

```go
index:0, value:map[] 
index:1, value:map[] 
index:2, value:map[] 

index:0, value:map[address:济南 name:张三 password:123456]
index:1, value:map[]
index:2, value:map[]
```

### 9.4.2 值为切片类型的 map

```go
package main

import "fmt"

func main() {
	// 构建一个 map, 容量为 3，元素类型为 []string 切片
	var sliceMap = make(map[string][]string, 3)
	// map[]
	fmt.Println(sliceMap)

	k := "中国"
	value, ok := sliceMap[k]
	if !ok {
		value = make([]string, 0, 2)
	}

	value = append(value, "北京", "上海")
	sliceMap[k] = value
	// map[中国:[北京 上海]]
	fmt.Println(sliceMap)
}
```

```go
package main

import "fmt"

func main() {
	// 构建一个 map, 容量为 3，元素类型为 []string 切片
	var sliceMap = make(map[string][]int, 3)
	sliceMap["北京"] = []int{1, 2, 3, 4, 5}
	// map[北京:[1 2 3 4 5]]
	fmt.Println(sliceMap)
}
```

## 9.5 作业

### 9.5.1 判断字符串中汉字的数量

思路：

* 依次获取每个字符
* 判断字符是不是汉字
* 把汉字出现的次数累加

```go
package main

import (
	"fmt"
	"unicode"
)

func main() {
	s1 := "我是 CnPeng,我在济南"
	var count int

	for _, c := range s1 {
		// 判断是不是汉字
		if unicode.Is(unicode.Han, c) {
			count++
		}
	}
	fmt.Println(count)
}
```

### 9.5.2 统计单词出现的次数：

```go
package main

import (
	"fmt"
	"strings"
)

func main() {
	s1 := "how do you do "
	strSlice := strings.Split(s1, " ")

	strMap := make(map[string]int, 10)
	for _, w := range strSlice {
		if _, ok := strMap[w]; !ok {
			strMap[w] = 1
		} else {
			strMap[w]++
		}
	}
	for k, v := range strMap {
		fmt.Println(k, v)
	}
}
```

### 9.5.2 回文判断

一个字符串从左向右读和从右向左读含义一致，就称为回文。如：

“上海自来水来自海上”、“山西运煤车煤运西山”、“黄山落叶松叶落山黄”

```go
package main

import "fmt"

func main() {
	s1 := "山西运煤车煤运西山"
	// 规律：s1[0]==s[len(ss)-1]
	// 		s1[1]==s[len(ss)-1-1]
	// 		s1[2]==s[len(ss)-1-2]
	// 		s1[3]==s[len(ss)-1-3]
	// 。。。s1[i]==s[len(ss)-1-i]

	// 将字符串转换成 rune 切片
	r := make([]rune, 0, len(s1))
	for _, c := range s1 {
		r = append(r, c)
	}

	// 只比较前面一半和后面一个就可以
	for i := 0; i < len(r)/2; i++ {
		if r[i] != r[len(r)-1-i] {
			fmt.Println("不是回文")
			return
		}
	}
}
```
