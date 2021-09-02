// builtin 包含大量内建函数
// 内建函数经常用
package main

import "fmt"

func main() {

	//
	// append
	//
	s1 := []int{1, 2, 3, 4}
	fmt.Println(len(s1), cap(s1), &s1[0]) // 4 4 0x18140
	s1 = append(s1, 5)                    // 容量不足以容纳新元素，则创建新的底层数组，并拷贝数据
	fmt.Println(len(s1), cap(s1), &s1[0]) // 5 8 0x1a040 // 底层数组容量增长机制：短 slice 成倍增长，特长 slice 按 1.25 倍增长等
	s2 := s1[2:4]
	s3 := append(s1, s2...)
	fmt.Println(len(s3), cap(s3)) // 7 8
	fmt.Println(&s1[0], &s3[0])   // 0x1a040 0x1a040 // 容量足够，s3 与 s1 共享同一个底层数组
	fmt.Println(s3)               // [1 2 3 4 5 3 4]

	//
	// len cap make
	//
	arr1 := [...]int{1, 2, 3}
	fmt.Println(len(arr1), cap(arr1))   // 3 3
	fmt.Println(len(&arr1), cap(&arr1)) // 3 3	// 数组指针 ok
	fmt.Println(len(s2), cap(s2))       // 2 6
	bufCh := make(chan int, 3)
	bufCh <- 1
	fmt.Println(len(bufCh), cap(bufCh)) // 1, 3

	//
	// close
	//
	close(bufCh) // 只能关闭双向 channel 或只发送 c chan<- Type

	//
	// copy
	//
	src := []int{1, 2, 3, 4}
	dst := make([]int, 2)
	fmt.Println(copy(dst, src))         // 2	// 返回 Min(len(src), len(dst))
	fmt.Println(dst)                    // [1 2]
	fmt.Println(copy(src[1:], src[:3])) // slice 复制本身时需注意左开右闭
	fmt.Println(src)                    // [1 1 2 3]

	//
	// delete
	//
	var users map[int]string
	delete(users, 1) // ok
	// users[1] = "name" // panic: assignment to entry in nil map

	// make
	// slice、map、chan 声明

	//
	// new() // 返回指向该类型零值的指针
	//
	u := new(User)
	fmt.Printf("%T\n", u) // *main.User

	//
	// panic 与 recover
	//
	f1 := func() {
		// defer FILO 顺序调用
		defer func() {
			if v := recover(); v != nil {
				fmt.Println("recovered:", v) // exec 3
			}
		}()
		defer func() {
			fmt.Println("f1 defer1 called") // exec 2
		}()
		fmt.Println("before panic") // exec 1
		panic(0)

		// panic 之后的代码不会被执行
		defer func() {
			fmt.Println("f1 defer2 called")
		}()
	}
	f2 := func() {
		defer func() {
			fmt.Println("f2 defer called") // exec 5
		}()
		f1()
		fmt.Println("after f1() called") // exec 4 // 如果 f1() 中没有 recover() 恢复，调用者 f2() 的逻辑不会再继续向下执行
	}
	f2()
	// before panic
	// f1 defer1 called
	// recovered: 0
	// after f1() called	// 有 recover 继续向下执行
	// f2 defer called

}

type User struct {
	Name string
	Age  int
}
