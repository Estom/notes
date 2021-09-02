package main

import (
	"fmt"
	"os"
	"time"
)

var txtFile = "/Users/wuyin/Go/src/gopkg/os/demo.txt"

func main() {

	// cd
	oldPwd, _ := os.Getwd()
	_ = os.Chdir("/Users")
	newPwd, _ := os.Getwd()
	fmt.Println(oldPwd, newPwd) // /Users/wuyin/Go/src/gopkg/os /Users

	// chmod
	oldF, _ := os.Stat(txtFile)
	_ = os.Chmod(txtFile, 0777)
	newF, _ := os.Stat(txtFile)
	fmt.Println(oldF.Mode(), newF.Mode()&0777) // -rw-r--r-- -rwxrwxrwx

	// chown
	_ = os.Chown(txtFile, 501, 501)

	// chtime
	_ = os.Chtimes(txtFile, time.Now(), time.Now())

	//
	// 运行时环境变量读写、格式化
	//
	os.Setenv("user_name", "wuYin")
	fmt.Println(os.Getenv("user_name"))             // wuYin
	fmt.Println(os.ExpandEnv("go path is $GOPATH")) // 环境变量替换映射
	s := "$sh is better than $$go"                  // $$ 不再解析
	fmt.Println(os.Expand(s, mapping))              // shell is better than go
	os.Clearenv()                                   // 清除当前程序的环境变量
	fmt.Println(os.Environ())                       // []

	fmt.Println(os.Getuid(), os.Getgid())       // 501 20		// 当前调用者的 uid gid
	fmt.Println(os.Getgroups())                 // [20, 501...] // 当前用户的所有组
	fmt.Println("main goroutine:", os.Getpid()) // 11624
	go func() {
		fmt.Println("parent goroutine:", os.Getppid()) // 11712	// 并不是 11624
	}()
	time.Sleep(100 * time.Millisecond)

	//
	// 系统设置
	//
	fmt.Println(os.Getpagesize()) // 4096 		// 系统内存页大小：4KB
	fmt.Println(os.Hostname())    //  fuwafuwa 	// 计算机名字
	fmt.Println(os.TempDir())     // /tmp		// 获取系统的 tmp 目录

	defer func() {
		fmt.Println("os.Exit() exit immediately, defer not exec") // 没有输出
	}()
	os.Exit(233) // 直接退出，defer 都不执行
}

func mapping(s string) string {
	m := map[string]string{"go": "golang", "sh": "shell"}
	return m[s]
}
