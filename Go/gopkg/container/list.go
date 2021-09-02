// container/list 是链表的实现
// 链表中的元素类型不要求相同，十分灵活
package main

import (
	"container/list"
	"fmt"
)

func main() {
	l := list.New()


	mid := l.PushBack(2)
	back := l.PushBack(3)
	front := l.PushFront(1)

	fmt.Println(mid.Prev().Value) // 1
	fmt.Println(mid.Next().Value) // 3

	fmt.Println(l.Front().Value) // 1	// 链表第一个元素
	fmt.Println(l.Back().Value)  // 3	// 链表最后一个元素

	front = l.InsertBefore(0, front) // 在指定节点前插入元素
	back = l.InsertAfter(4, back)    // 在指定节点后插入元素

	l.MoveToBack(front) // 移动到表尾
	l.MoveToFront(back) // 移动到表头
	printList(l)        // 4 1 2 3 0

	cpl := list.New()
	cpl.PushBack("strEle") // 字符串元素
	cpl.PushBackList(l)    // PushFrontList
	printList(cpl)         // strElement 4 1 2 3 0

	l.Init() // 初始化或清空链表
}

func printList(l *list.List) {
	for e := l.Front(); e != nil; e = e.Next() {
		fmt.Print(e.Value, " ")
	}
}
