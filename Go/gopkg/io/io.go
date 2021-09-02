// io 包常用函数
package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"
)

func main() {

	//
	// Copy
	//
	r := strings.NewReader("MS微软")
	fmt.Println(io.CopyN(os.Stdout, r, 2)) // 2, nil
	fmt.Println(io.Copy(os.Stdout, r))     // 6, nil // 返回真正写入的字节数

	//
	// Read
	//
	// 至少要读多少
	r.Reset("Amazon亚马逊")
	bs := make([]byte, 20)
	n, err := io.ReadAtLeast(r, bs, 20)
	if err == io.ErrUnexpectedEOF {
		fmt.Printf("read %d, want 20\n", n) // read 15, want 20
		bs = bs[:n]                         // 修剪读取到的 bytes		// 十分有必要的截取操作
	}

	// 精确读多少
	r.Reset("Google谷歌")
	bs = make([]byte, 13)           // io.ReadFull 用于精确读取指定长度的字节数据
	fmt.Println(io.ReadFull(r, bs)) // 12 unexpected EOF

	// 读哪个区间的数据
	r.Reset("Facebook脸书")
	sectionR := io.NewSectionReader(r, 2, 20) // [2, 2+20)
	bs = make([]byte, 20)
	n, err = sectionR.Read(bs)  // 读取完毕返回 EOF
	fmt.Println(n, err)         // 12 EOF
	fmt.Println(string(bs[:n])) // cebook脸书

	// 双向读写
	r.Reset("gopher")
	teeR := io.TeeReader(r, os.Stdout) // gopher // 读取 r 中的内容输出到 w
	bs = make([]byte, 10)
	fmt.Println(teeR.Read(bs)) // 6 nil // 从源 r 中读取数据并缓存在 p 中，再将 p 中的数据写出到 w

	//
	// Reader Writer 的封装
	//
	fmt.Println(io.WriteString(os.Stdout, "io.WriteString")) // 14 nil

	// LimitReader
	f, _ := os.Open("lyrics.txt")
	bs = make([]byte, 2*3)
	lr := io.LimitedReader{R: f, N: 2 * 3} // 限定读取字节数的 Reader
	lr.Read(bs)
	fmt.Println(lr.N, string(bs)) // 0 告诉 // 每次读取后，N 限定字节数都会递减，N<=0 表示读取完毕

	// MultiReader
	r.Reset("Apple苹果")
	multiR := io.MultiReader(r, f) // 顺序读取多个 reader
	bs = make([]byte, 3)
	var cont []byte
	for {
		n, err := multiR.Read(bs)
		if err == io.EOF {
			break // 读取结束
		}
		cont = append(cont, bs[:n]...) // n 不一定是 3，获取真正读取到字节
	}
	fmt.Println(string(cont))

	// 	MultiWriter
	multiW := io.MultiWriter(os.Stdout, os.Stderr) // 顺序写入多个 writer
	multiW.Write(cont)
	fmt.Println()

	//
	// pipe
	//
	pr, pw := io.Pipe()
	go func() {
		defer pw.Close()
		pw.Write([]byte("Name is 吴胤"))
	}()
	out := make([]byte, 20)
	n, _ = pr.Read(out)
	fmt.Println(n, string(out[:n])) // 14 Name is 吴胤

	//
	// ioutil
	//
	f, _ = os.Open("lyrics.txt")
	b, err := ioutil.ReadAll(f) // 读取 r 中全部的数据直到读取失败，或者读取完毕
	if err == nil {
		fmt.Println(string(b))
	}

	files, _ := ioutil.ReadDir(".") // 读取目录下所有子目录和文件的信息
	for _, f := range files {
		fmt.Println(f.Name())
	}

	bs, _ = ioutil.ReadFile("lyrics.txt") // 直接读取文件
	fmt.Println(string(bs))

	tmpDir, _ := ioutil.TempDir(".", "tmp_d_")      // 创建临时文件夹
	tmpFile, _ := ioutil.TempFile(tmpDir, "tmp_f_") // 创建临时文件
	tmpFile.WriteString("sharks")
}
