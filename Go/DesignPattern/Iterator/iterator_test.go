/**
* @Author:zhoutao
* @Date:2020/12/12 下午12:04
* @Desc:
 */

package iterator

//以相同的方式迭代不同类型的集合

func ExampleIterator() {
	var aggregate Aggregate
	aggregate = NewNumbers(1, 10)

	IteratorPrint(aggregate.Iterator())
}
