# 概述
container/heap包对通用堆进行了定义并实现了标准堆操作函数，以此为基础可以很容易对各类堆和优先队列进行实现。
# 类型接口
heap包中最核心的就是heap.Interface接口，堆的基础存储是一个树形结构，可以用数组或是链表实现。通过heap的函数，可以建立堆并在堆上进行操作；要使用heap包的函数，你的类需要实现heap.Interface接口，定义如下：

```
// heap.Interface
type Interface interface {
        sort.Interface
        Push(x interface{})       // 在Len()位置插入一个元素
        Pop() interface{}         // 删除并返回Len()-1位置的元素
}

// sort.Interface
type Interface interface {
        Len()                     // 获取当前对象的长度
        Swap(i, j interface{})    // 交换i,j位置两个元素的位置
        Less(i, j interface{})    // 比较i位置元素的值是否小于j位置元素
}
```
在实现了这些接口之后，就可以被heap包提供的各个函数进行操作，从而实现一个堆。
# 成员函数
heap包中提供了几个最基本的堆操作函数，包括Init，Fix，Push，Pop和Remove。这些函数都通过调用前面实现接口里的方法，对堆进行操作。

## Init
Init函数用于堆初始化，接受一个实现了heap.Interface的对象，并初始化为一个堆，所有的堆在使用之前都需要进行初始化，Init函数定义为：

```
func Init(h Interface)
```


## Fix
Fix函数用于单次对堆进行调整，接收一个堆对象以及一个位置参数i，其函数定义如下：

```
func Fix(h Interface, i int)
```

如果你还记得如何维护一个堆，那么应该可以很容易理解这个函数的作用。实际上，每次在堆上插入一个元素后，堆结构会被破坏，需要通过Fix函数将这个元素交换到合适的位置，以保证堆的正确性。

## Push&Pop
Push和Pop是一对标准堆操作，Push向堆添加一个新元素，Pop弹出并返回堆顶元素，而在push和pop操作不会破坏堆的结构；具体函数定义如下：

```
func Pop(h Interface) interface{}
func Pop(h Interface) interface{}
```

## Remove
Remove函数用于删除堆上特定位置的元素，这个位置是指元素在堆上的排序，其函数定义如下：

```
func Remove(h Interface, i int) interface{}
```

# 使用实例
下面是一个简单的例子对上面的内容进行回顾，代码实现了一个小顶堆，堆中元素为长方形类，按照面积大小进行排序，使用slice作为基础存储。首先是类定义和接口实现，需要实现前面说到的五个接口。

```
type Rectangle struct {
    height int
    width int
}

func (rec *Rectangle) Area() {
    return rec.height * rec.width

type RecHeap []Rectangle

func (h RecHeap) Len() {
     return len(h)
}

func (h RecHeap) Swap(i, j interface{}) {
     h[i], h[j] = h[j], h[i]
}

func (h RecHeap) Less(i, j interface{}) {
     return h[i].Area() < h[j].Area()
}

func (h *RecHeap) Push(h interface{}) {
     *h = append(*h, h.(Rectangle)
}

func (h *RecHeap) Pop(h interface{}) {
     n := len(*h)
     x := *h[n-1]
     *h = *h[:n-1]
     return x
}
```
完成了接口定义之后就可以通过heap包提供的函数进行堆的操作了，首先使用Init进行初始化，然后通过Push进行元素的插入，Pop进行元素的删除，需要注意的一点是，heap包并没有提供Top这样一个函数获取当前堆顶元素，你可以通过获取slice[0]来获取。
```
import (
     "fmt"
     "container/heap"
)

func main() {
     hp := &[]RecHeap{}
     for i := 2; i <= 5; i++ {
          *hp = append(*hp, Rectangle{i, i})
          // {2, 2}, {3, 3}, {4, 4}, {5, 5}
     }
     heap.Init(hp)                         // 初始化
     heap.Push(hp, Rectangle{1, 1})
     fmt.Printf("minimum: %d\n", (*hp)[0]) // Rectangle{1, 1}
     res := heap.Pop(hp)
     fmt.Printf("minimum: %d\n", (*hp)[0]) // Rectangle{2, 2}
}
```


你也可以通过修改Less方法将其变为一个大顶堆。

# 参考文献
- [container/heap](https://golang.org/pkg/container/heap/#Interface)
