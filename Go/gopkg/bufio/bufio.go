// 缓冲包 bufio 常用函数
// bufio 中与 io.Reader 和 io.Writer 打交道
// 可以从 Reader 中缓冲读数据
// 也可以累积数据，最后 flush 写到 Writer 中
package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strings"
)

func main() {

	//
	// 缓冲读
	//
	strR := strings.NewReader("cache and name things") // 21 字节
	bufR := bufio.NewReader(strR)                      // 从现有 reader 中创建缓冲 Reader，会尽可能多的读取底层 reader 中的数据
	b := make([]byte, 20)                              // 指定读取 20 字节
	bufR.Read(b)                                       // 将字节读如缓冲区，底层 reader 已读空
	fmt.Println(string(b))                             // cache and name thing
	fmt.Println(bufR.Buffered())                       // 1	// bufR 还剩 1 字节

	strR.Reset("cache and name things")
	bufR = bufio.NewReaderSize(strR, 10) // 缓冲区的最小长度是 10，bufR 还是会尽可能多的区读底层 reader 的数据
	b = make([]byte, 12)
	bufR.Read(b)
	fmt.Println(string(b)) // cache and na

	// 缓冲只读
	peekB, _ := bufR.Peek(2)   // Read() 在读取数据后会将该片缓冲区清除，而 Peek() 不会
	fmt.Println(string(peekB)) // me

	//
	// 分割读
	//
	strR.Reset("name: 吴_胤")
	bufR = bufio.NewReader(strR)
	// r, _ := bufR.ReadRune()      // 读 Unicode 字符
	r, _ := bufR.ReadByte()         // 读取下一个字节，没有则返回 EOF
	fmt.Println(string(r))          // n
	bufR.UnreadByte()               // 还原已读取的最后一个字节
	runes, _ := bufR.ReadBytes(':') // 读取数据直到指定分割字符出现，返回读取到的字节 slice
	fmt.Println(string(runes))      // name:
	str, _ := bufR.ReadString('_')  // 分割后返回字符串
	fmt.Printf("%q\n", str)         // " 吴_"

	strR.Reset("a_b")
	bufR = bufio.NewReader(strR)
	line, _ := bufR.ReadSlice('_') // ReadSlice 返回的 slice 值在下次 ReadSlice 后会被修改（引用），一般用得少
	fmt.Println(string(line))      // a_
	bufR.ReadSlice('_')            // 返回的 slice 会按序填充到 line 中
	fmt.Println(string(line))      // b_	// _ 被保留了下来

	//
	// 缓冲写
	//
	w := bytes.NewBuffer(nil)
	bufW := bufio.NewWriter(w)
	bufW.Write([]byte("PUBG")) // 将字节写入缓冲区
	bufW.WriteByte('&')        // 写一个字节
	// bufW.WriteRune('&') 	   // 写一个 Unicode 字符
	bufW.WriteString("CSGO")
	fmt.Println(bufW.Buffered())  // 9
	fmt.Println(bufW.Available()) // 4087(4KB-9B) // 缓冲区中剩余缓冲字节数
	bufW.Flush()                  // 将缓冲区的数据写到底层 writer，完成数据的真正写入
	fmt.Println(string(w.Bytes()))
	bufW = bufio.NewWriterSize(os.Stdout, 10)  // 缓冲区的长度至少是 10 字节
	bufW.Write([]byte("more than 10 runes\n")) // 19 nil

	//
	// 可读可写缓冲
	//
	bufRW := bufio.NewReadWriter(bufR, bufW)
	fmt.Println(bufRW.ReadRune()) // m  //可读
	w = bytes.NewBuffer([]byte("magic"))
	bufW = bufio.NewWriter(w)
	bufRW.Flush()
	fmt.Println(string(w.Bytes())) // magic // 可写
}
