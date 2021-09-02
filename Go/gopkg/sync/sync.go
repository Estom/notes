// sync 主要提供原子操作、互斥锁、读写锁
package main

import (
	"fmt"
	"sync"
	"sync/atomic"
	"time"
)

func main() {

	//
	// Mutex
	//
	m := new(sync.Mutex)
	c1, c2 := 0, 0
	ch := make(chan int, 200)
	for i := 0; i < 100; i++ {
		go click(&c1, ch)
	}
	for i := 0; i < 100; i++ {
		go clickWithMutex(&c2, m, ch)
	}
	for i := 0; i < 200; i++ { // 循环阻塞等待两百次任务完成
		<-ch
	}
	fmt.Printf("c1: %d   c2:%d\n", c1, c2) // c1: 56108   c2:10000  // 在多个 goroutine 中对同一变量进行操作时，一定要加锁

	// RWMutex 读写锁
	c3 := 0
	rwLocker := new(sync.RWMutex)
	clickWithRWMutex(&c3, rwLocker, ch)
	fmt.Printf("c3: %d\n", c3)

	//
	// Once
	//
	once := new(sync.Once) // 保证 func 只会执行一次
	for i := 0; i < 3; i++ {
		go func(i int) {
			once.Do(func() {
				fmt.Println("once done: ", i)
			})
			fmt.Println("i: ", i)
			ch <- 1
		}(i)
	}
	for i := 0; i < 3; i++ {
		<-ch
	}

	//
	// WaitGroup
	//
	wg := new(sync.WaitGroup)
	for i := 0; i < 3; i++ {
		wg.Add(1) // 添加指定个元素到 WaitGroup 中
		go Process(wg, i)
	}
	wg.Wait() // 阻塞直到 WaitGroup 中所有任务完成

	//
	// 原子操作
	//
	var u1 uint32
	atomic.AddUint32(&u1, 2)                 // 原子操作只针对长度固定的数据
	fmt.Println(u1)                          // 2
	fmt.Println(atomic.SwapUint32(&u1, 100)) // 2	// 返回旧数据
	fmt.Println(u1)                          // 100
	fmt.Println(atomic.LoadUint32(&u1))      // 互斥读：在读取期间，程序的其他部分无法再对变量进行读写操作
}

func clickWithRWMutex(total *int, rwLocker *sync.RWMutex, ch chan int) {
	for i := 0; i < 1000; i++ {
		rwLocker.Lock()
		*total++
		rwLocker.Unlock()
		if i == 500 {
			rwLocker.RLock()
			fmt.Println(*total) // 501	// 只保证读，不保证写...惊不惊喜意不意外
			rwLocker.RUnlock()
		}
	}
	ch <- 1
}

func click(total *int, ch chan int) {
	for i := 0; i < 1000; i++ {
		*total += 1
	}
	ch <- 1
}

func clickWithMutex(total *int, m *sync.Mutex, ch chan int) {
	for i := 0; i < 1000; i++ {
		m.Lock()
		*total += 1
		m.Unlock()
	}
	ch <- 1
}

// 这里必须传入指针，对 wg 变量进行修改
func Process(wg *sync.WaitGroup, id int) {
	time.Sleep(1 * time.Second)
	fmt.Printf("task %d is done\n", id)
	wg.Done()
}
