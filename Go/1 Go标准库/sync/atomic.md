# 概述
为了保证并发安全，除了使用临界区之外，还可以使用原子操作。顾名思义这类操作满足原子性，其执行过程不能被中断，这也就保证了同一时刻一个线程的执行不会被其他线程中断，也保证了多线程下数据操作的一致性。

在atomic包中对几种基础类型提供了原子操作，包括int32，int64，uint32，uint64，uintptr，unsafe.Pointer。对于每一种类型，提供了五类原子操作分别是

- Add,            增加和减少
- CompareAndSwap, 比较并交换
- Swap,           交换
- Load ,          读取
- Store,          存储

具体函数名由原子操作名和类型关键字组成，例如对于int32的Add操作，函数名为AddInt32，其他函数名以此类推，后文中仅以int32类型系列函数为例进行说明，其他类型函数功能类似。

# AddInt32
AddInt32可以实现对元素的原子增加或减少，其函数定义如下，函数接收两个参数，分别是需要修改的变量的地址和修改的差值，函数会直接在传递的地址上进行修改操作，此外函数会返回修改之后的新值：

```
func AddInt32(addr *int32, delta int32) (new int32)
```

传递一个正整数增加值，负整数减少值，函数的通常使用方法如下。需要注意的是当你处理unint32和unint64时，由于delta参数类型被限定，不能直接传输负数，所以需要利用二进制补码机制，其中N为需要减少的正整数值。

```
package main

import (
	"sync/atomic"
	"fmt"
)

func main() {
	var a int32
	a += 10
	atomic.AddInt32(&a, 10)
	fmt.Println(a == 20) // true

	var b uint32
	b += 20
	atomic.AddUint32(&b, ^uint32(10-1))
	// 等价于 b -= 10
	// atomic.Adduint32(&b, ^uint32(N-1))
	fmt.Println(b == 10) // true
}

```


# CompareAndSwapInt32
CompareAndSwapInt32函数接收三个参数，一个是需要交换（赋值）的变量地址，然后是一个待比较的值（旧值），最后是需要交换的值（新值），函数返回一个布尔值表示交换结果。函数声明如下：

```
func CompareAndSwapInt32(addr *int32, old, new int32) (swapped bool)
```

比较并交换（Compare and Swap，CAS）是一个常用的原子操作，首先判断当前变量的值和旧值是否相等（也就是变量值是否被其他线程所修改），如果相等则用新值替换掉原来的值，否则就不进行替换操作。
# SwapInt32
类似于CAS，Swap也是将一个新值赋给某变量，区别在于CAS会比较当前变量与旧值，来决定赋值与否；Swap会直接执行赋值操作，并将原值作为返回值返回，其函数声明如下：

```
func SwapInt32(addr *int32, new int32) (old int32)
```

# LoadInt32 &  StoreInt32
Load和Store操作对应与变量的原子性读写，许多变量的读写无法在一个时钟周期内完成，而此时执行可能会被调度到其他线程，无法保证并发安全。函数的类型声明如下：

```
func LoadInt32(addr *int32) (val int32)

func StoreInt32(addr *int32, val int32)
```

Load函数参数为需要读取的变量地址，返回值为读取的值；Store函数参数为需要存储的变量地址，以及需要写入的值，不同于CAS，Store操作不关心变量的原始值是否被修改，只是简单的执行写入，所以Store函数总能成功返回。