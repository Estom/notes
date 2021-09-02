package main

import (
	"fmt"
	"os"
	"path"
	"path/filepath"
)

func main() {
	//
	// path 操作
	//
	// 获取最后一个元素的路径
	fmt.Println(path.Base(""), path.Base("/users/root"), path.Base("////")) // . root /

	// 清除路径中无用的字符，返回最短路径
	fmt.Println(path.Clean("users/root/.bashrc/..")) // users/root
	fmt.Println(path.Clean("/users/../usr///local")) // /usr/local

	// 获取最后一个元素所在目录
	fmt.Println(path.Dir(""), path.Dir("users/root/.bashrc")) // . users/root

	// 获取文件扩展名
	fmt.Println(path.Ext("/tmp/me.jpeg"), path.Ext("users/root/.bashrc")) // .jpeg .bashrc

	// 判断是否为绝对路径
	fmt.Println(path.IsAbs("/opt")) // true

	// 连接路径，返回的结果是 Clean 过的
	fmt.Println(path.Join("/opt", "..//deploy")) // deploy

	// 正则匹配路径
	fmt.Println(path.Match("\\root", "root"))          // true nil
	fmt.Println(path.Match("*", "root/.bash_profile")) // false nil		// * 不匹配 /

	// 分割路径中的目录与文件
	fmt.Println(path.Split("/root/images/selfie.jpeg")) // /root/images/ selfie.jpeg

	//
	// filepath 操作
	//
	fmt.Println(filepath.Rel("/home", "/home/"))     // . nil
	fmt.Println(filepath.Rel("/home", "/home/logs")) // logs nil
	// 遍历操作
	filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		fmt.Println("walk", path)
		fmt.Println("walk", info.Size())
		return nil
	})
}
