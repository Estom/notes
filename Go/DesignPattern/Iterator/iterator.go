package iterator

import "fmt"

//迭代器模式：使用相同的方式 迭代不同类型的集合 或者隐藏集合类型的具体实现

//聚合
type Aggregate interface {
	Iterator() Iterator
}

type Iterator interface {
	First()
	IsDone() bool
	Next() interface{}
}

//NewNumbers
func NewNumbers(start, end int) *Numbers {
	return &Numbers{
		start: start,
		end:   end,
	}
}

type Numbers struct {
	start, end int
}

//NumbersIterator implement Iterator interface
func (n *Numbers) Iterator() Iterator {
	return &NumbersIterator{
		numbers: n,
		next:    n.start,
	}
}

//NumbersIterator
type NumbersIterator struct {
	numbers *Numbers
	next    int
}

func (i *NumbersIterator) First() {
	i.next = i.numbers.start
}

func (i *NumbersIterator) IsDone() bool {
	return i.next > i.numbers.start
}

func (i *NumbersIterator) Next() interface{} {
	if !i.IsDone() {
		next := i.next
		i.next++
		return next
	}
	return nil
}

//迭代打印
func IteratorPrint(i Iterator) {
	for i.First(); !i.IsDone(); {
		c := i.Next()
		fmt.Printf("%#v\n", c)
	}
}
