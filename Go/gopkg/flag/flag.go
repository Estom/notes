// flag 包提供很多解析命令行参数的函数
// 常用解析、绑定等等
package main

import (
	"flag"
	"fmt"
	"time"
)

var name = flag.String("name", "", "-name=cola")
var age int

func main() {
	//
	// 命令行参数解析
	//
	flag.IntVar(&age, "age", 0, "-age=10")                  // 将命令行的值绑定到变量上
	t := flag.Duration("spent", 1*time.Second, "-spent=1s") // 单位必须正确："ns", "us" (or "µs"), "ms", "s", "m", "h"
	flag.Parse()
	flag.PrintDefaults()
	//   -age int
	//        -age=10
	//  -name string
	//        -name=cola
	//  -spent duration
	//        -spent=1s (default 1s)

	fmt.Println(flag.Parsed()) // true
	fmt.Println(*t)

	//
	// 命令行参数数量
	//
	// go run flag.go -name go 233
	fmt.Println(flag.Arg(0))  // 233 	// 获取第 i+1 和非 flag 命令行参数值
	fmt.Println(flag.Args())  // [233] 	// 全部非 flag 命令行参数值
	fmt.Println(flag.NArg())  // 1
	fmt.Println(flag.NFlag()) // 1		// 成功解析 1 个 flag
}
