// log 包有大量的日志操作函数
// 还可以自定义 logger
package main

import (
	"log"
	"os"
)

func main() {
	// log 格式常量
	// Ldate	年/月/日
	// Ltime    时:分:秒
	// LstdFlags Ldate & Ltime
	// Lmicroseconds	毫秒	// 精细化的时间点
	// Llongfiles 		完整文件名：行号

	log.Printf("log print")

	// 自定义 logger
	f, _ := os.OpenFile("demo.log", os.O_WRONLY, 0666)
	l := log.New(f, "pre_", log.Ltime|log.Lmicroseconds) // 指定前缀和日志格式，并输出到指定的 writer
	l.Println("log txt to writer")                       // 输出到文件
	l.SetPrefix("x_")
	l.SetFlags(log.Llongfile)
	l.SetOutput(os.Stdout) // 修改 logger 的 writer 目标

	log.SetFlags(log.Ltime | log.Llongfile) // 设定 log 格式
	log.Fatalf("error occurred, exit now")  // Printf(); os.Exit(1)
}
