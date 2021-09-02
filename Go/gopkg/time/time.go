// time 包中常用函数
package main

import (
	"fmt"
	"time"
)

const DATETIME_LAYOUT = "2006-01-02 15:04:05"

func main() {

	// UTC 新年
	newYear := time.Date(2019, time.January, 1, 0, 0, 0, 0, time.UTC) // 2018-01-01 00:00:00 +0000 UTC

	//
	// 时间间隔
	//
	PrintTime(time.Now().Add(1 * time.Hour))
	PrintTime(time.Now().AddDate(1, 1, 2)) // years, months, days
	now := time.Now()
	time.Sleep(50 * time.Millisecond)  // 将当前 goroutine 暂停指定时长，阻塞调用。time.After() 是非阻塞操作
	fmt.Println(time.Since(now))       // 54.843979ms
	fmt.Println(time.Now().Sub(now))   // 54.666399ms			// 简写
	fmt.Println(time.Now().UnixNano()) // 1536804136936030000 	// 常用作 rand 的 seed

	//
	// 时间格式与单位
	//
	fmt.Println(time.Parse(DATETIME_LAYOUT, "2018-01-01 00:12:12"))
	d, _ := time.ParseDuration("1h2m22s12ms") // 1:2:22:012	// 合法单位：
	fmt.Println(d.Hours())                    // 1.0394477777777777
	fmt.Println(d.Minutes())                  // 62.36686666666667
	fmt.Println(d.Seconds())                  // 3742.012
	fmt.Println(d.Nanoseconds())              // 3742012000000
	fmt.Println(d.String())                   // 1h2m22.012s
	now = time.Now()
	fmt.Println(now.Month()) // September

	//
	// 时区相关
	//
	l, _ := time.LoadLocation("PRC")    // People's Republic of China
	fmt.Println(newYear.In(l))          // 2019-01-01 08:00:00 +0800 CST	// 将 time 转换为指定时区时间
	fmt.Println(newYear.In(time.Local)) // Local 等效
	fmt.Println(newYear.Local())        // 2019-01-01 08:00:00 +0800 CST	// 返回本地时间 UTC+8=CST
	fmt.Println(time.Now().Location())  // Local   							// 返回时间所在时区
	fmt.Println(time.Now().ISOWeek())   // 2018 37 							// 返回 time 在一年中的星期数
	b, err := newYear.MarshalJSON()
	fmt.Println(string(b), err)    // "2019-01-01T00:00:00Z" <nil>
	fmt.Println(time.Now().Zone()) // CST 28800(8 * 3600)	// 返回时区，向东的秒偏移量

	//
	// 计时器
	//
	timer := time.NewTimer(time.Second)
	_ = <-timer.C // 阻塞 1s
	ch1 := make(chan int)
	go func(chan int) {
		time.Sleep(3 * time.Second)
		ch1 <- 0
	}(ch1)
	select {
	case <-ch1:
		fmt.Println("goroutine done")
	case <-time.After(2 * time.Second): // 等效于 time.NewTimer().C
		fmt.Println("timeout1")         // 检测到 ch1 处理超时
	}
	f := func() {
		fmt.Println("timeout2")
	}
	time.AfterFunc(time.Second, f) // f 的执行是异步的，相当于后台的定时任务 // 返回的 timer 能 Reset() 和 Stop() 计时器
	time.Sleep(2 * time.Second)

	//
	// 定时器
	//
	ticker := time.NewTicker(time.Second)
	go func() {
		for t := range ticker.C {
			PrintTime(t)
		}
	}()
	<-time.After(4 * time.Second)
	ticker.Stop() // 关闭 ticker 不再产生新的 tick，但是不会关闭 ticker 的 channel，可能造成 goroutine 的内存泄漏

	sTicker := time.Tick(time.Second) // 直接返回对 ticker 的 channel，这种定时器一般无需 Stop()
	for t := range sTicker {
		PrintTime(t)
	}

}

func PrintTime(t time.Time) {
	fmt.Println(t.Format(DATETIME_LAYOUT))
}
