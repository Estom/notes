# 概述
Ring是一种循环链表结构，没有头尾，从任意一个节点出发都可以遍历整个链。其定义如下，Value表示当前节点的值：

```
type Ring struct {
        Value interface{} 
}
```
# 类型方法
## New
Ring.New用于创建一个新的Ring，接收一个整形参数，用于初始化Ring的长度，其方法定义如下：

```
func New(n int) *Ring
```

## Next & Prev
作为一个链表，最重要的操作进行遍历，可以通过Next和Prev方法获取当前节点的上一个节点和下一个节点，方法定义如下：

```
func (r *Ring) Next() *Ring
func (r *Ring) Prev() *Ring
```
通过这两个方法可以对一个ring进行遍历，首先保存当前节点，然后依次访问下一个节点，直到回到起始节点，代码实现如下：

```
p := ring.Next()
//  do something with first element
for p != ring {
    // do something with current element
    
    p = p.Next()
}
```
## Link & Unlink
Link将两个ring连接到一起，而Unlink将一个ring拆分为两个，移除n个元素并组成一个新的ring，这两个操作组合起来可以对多个链表进行管理，方法声明如下：

```
func (r *Ring) Link(s *Ring) *Ring
func (r *Ring) Unlink(n int) *Ring
```
## Do
前面通过Next方法对ring进行了遍历，由于这类操作的广泛存在，所以Ring包中还提供了一个额外的方法Do，方法接收一个函数作为参数，方法声明如下：


```
func (r *Ring) Do(f func(interface{}))
```
在调用Ring.Do时，会依次将每个节点的Value当做参数调用这个函数，实际上这是策略方法的应用，通过传递不同的函数，可以在同一个ring上实现多种不同的操作。下面展示一个简单的遍历打印程序。
```
package main

import (
	"container/ring"
	"fmt"
)

func main() {
	r := ring.New(10)

	for i := 0; i < 10; i++ {
		r.Value = i
		r = r.Next()
	}

	sum := SumInt{}
	r.Do(func(i interface{}) {
		fmt.Println(i)
	})
}
```

除了简单的无状态程序外，也可以通过结构体保存状态，例如下面是一个对ring上值求和的程序。

```
package main

import (
	"container/ring"
	"fmt"
)

type SumInt struct {
	Value int
}

func (s *SumInt) add(i interface{}) {
	s.Value += i.(int)
}

func main() {
	r := ring.New(10)

	for i := 0; i < 10; i++ {
		r.Value = i
		r = r.Next()
	}

	sum := SumInt{}
	r.Do(sum.add)
	fmt.Println(sum.Value)
}
```

