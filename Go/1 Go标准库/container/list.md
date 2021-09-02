# 概述
container/list包实现了基本的双向链表功能，包括元素的插入、删除、移动功能
# 链表元素
链表中元素定义如下：

```
type Element struct {
     Value interface{}
}

func (e *Element) Next() *Element
func (e *Element) Prev() *Element
```
通过Value属性来获取元素的值，此外Element还有两个方法Next和Prev分别获取当前元素的前一个元素和后一个元素。
# 成员函数
## 初始化
可以通过调用New函数或者Init方法来初始化一个空的list，此外Init也可以重置一个list。函数声明如下：

```
func New() *List
func (l *List) Init() *List
```

## 遍历
对于链表来说，遍历是最常用的操作，遍历操作一共三步：

- 第一步，获取一个遍历起始点；使用Front或Back获取一个链表的头和尾，其函数声明如下：

```
func (l *List) Front() *List
func (l *List) Back() *List
```
- 第二步，从当前元素转到下一个元素；使用Element上的Prev和Next方法向前或向后移动一个元素。
- 第三步，遍历结束条件；遍历结束条件需要人为判断，一般比较当前元素是否为结束元素。
## 插入
container/list中提供了两种插入方法，InsertAfter和InsertBefore，分别用于在一个元素前或后插入元素，方法声明如下：

```
func (l *List) InsertAfter(v interface{}, mark *Element) *Element
func (l *List) InsertBefore(v interface{}, mark *Element) *Element
```
## 添加
PushBack和PushFront用于在一个链表的头和尾添加元素（此外还有一次性添加一个list的PushBackList和PushFrontList），方法声明如下：

```
func (l *List) PushBack(v interface{}) *Element
func (l *List) PushFront(v interface{}) *Element
```
## 删除
可以通过Remove方法，删除链表上指定元素，方法声明如下：

```
func (l *List) Remove(e *Element) interface{}
```
# 使用实例
实际上，将前面的内容整合起来，就可以实现一个简单的遍历链表的功能。下面是一个简单的遍历实现
```
package main


import (
"fmt"
"container/list"
)


func main() {
	link := list.New()

	for i := 0; i <= 10; i++ {
		link.PushBack(i)
	}//

	for p := link.Front(); p != link.Back(); p = p.Next() {
		fmt.Println("Number", p.Value)
	}

}
```
# 参考文献
- [container/list](https://golang.org/pkg/container/list/#List.MoveAfter)
