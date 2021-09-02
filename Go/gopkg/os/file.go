package main

import (
	"fmt"
	"log"
	"os"
)

var cont = `
bcd
f hij
`

func main() {

	//
	// 文件的创建
	//
	os.Mkdir("demo", 0777)
	os.MkdirAll("./demo/demo1", 0777) // 注意权限
	f, err := os.Create("demo.txt")   // 覆盖性地创建文件
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()       // 关闭文件指针
	fmt.Println(f.Fd())   // 文件句柄
	fmt.Println(f.Name()) // demo.txt

	//
	// 文件写
	//
	f.Write([]byte(cont))         // 写数据
	f.WriteAt([]byte("\nend"), 9) // 从指定字节处开始写，会把 j 覆盖掉
	f.WriteString("\n new start") // 写入字符串
	f.Sync()                      // 强制将内存中的文件内容写回磁盘

	newF := os.NewFile(f.Fd(), "demo_son.txt") // 使用现有的文件描述符创建新文件，但不保存
	defer newF.Close()

	//
	// 文件读
	//
	f, _ = os.Open("demo.txt")                                  // 只读模式打开文件
	f, _ = os.OpenFile("demo.txt", os.O_CREATE|os.O_RDWR, 0777) // 文件不存在则创建、追加方式、读写，指定权限打开文件

	b := make([]byte, 3)          // Read 的目缓存，长度需大于 0
	fmt.Println(f.Read(b))        // 3
	fmt.Printf("%q\n", string(b)) // "\nbc"

	n, _ := f.ReadAt(b, 6)            // 从指定的真实内容下标开始读取
	fmt.Printf("%q\n", string(b[:n])) // " hi"

	f.Seek(1, 0) // 将文件指针移动到指定位置，0:相对文件开始位置；1:相对当前位置；2:相对结尾位置
	n, _ = f.Read(b)
	fmt.Printf("%q\n", string(b[:n])) // "bcd"

	f.Truncate(2) // 将文件截断到只有 2 字节
	f.Seek(0, 0)
	n, _ = f.Read(b)
	fmt.Printf("%q\n", string(b[:n])) // "\nb"

	//
	// 文件信息
	//
	info, _ := f.Stat()
	fmt.Println("size:", info.Size()) // 2 bytes
	fmt.Println(info.IsDir())         // false
	fmt.Println(info.Mode().Perm())   // -rwxrwxrwx

	//
	// 文件状态检测
	//
	_, err = os.Open("not_exist.file")
	fmt.Println(os.IsExist(err))    // false
	fmt.Println(os.IsNotExist(err)) // true
	_, err = os.Open("/etc/hosts")
	fmt.Println(err, os.IsPermission(err)) // false	// ...
	fmt.Println(os.IsPathSeparator('/'))   // true	// 是目录分隔符
	info2, _ := f.Stat()
	fmt.Println(os.SameFile(info, info2)) // true	// 判断两个文件信息是否相同

	// r, w, _ := os.Pipe() // 生成一对只读只写的文件指针

	//
	// 文件删除
	//
	os.Truncate("demo.txt", 2) // 直接将文件截断到 2 字节
	os.Remove("demo/")         // 删除文件，但不能删除非空目录
	os.RemoveAll("demo/")      // 删除目录及其子目录（强制删除）
}
