// fmt 包不仅能格式化、输出
// 还能从指定的文件中读取文本
// 读写十分方便
package main

import (
	"fmt"
	"os"
)

func main() {
	err := fmt.Errorf("open file failed")
	fmt.Printf("%T %[1]v \n", err)            // *errors.errorString open file failed
	fmt.Fprintf(os.Stdout, "write to file\n") // 将格式化后字符串输出到指定文件

	var name string
	var age int
	fmt.Fscan(os.Stdin, &name, &age) // 从指定文件中读取文本，默认按照空白（包括换行符）进行分割，自定义格式可使用 Fscanf
	fmt.Println(name, age)

	var month, day int
	n, err := fmt.Scanf("%d,%d", &month, &day) // 从标准输入中读取文本，默认也是空白分割。此时输入必须包含逗号，否则返回 err：input does not match format
	fmt.Println(n, err, month, day)            // 输入 1 1 时，month 可以先解析到

	s := fmt.Sprintf("you intputed: %s %d", name, age) // 返回格式化后的字符串，而非输出
	fmt.Println(s)

	str := "name: wuYin, age:20"
	fmt.Sscanf(str, "name:%s, age:%d", name, age) // 按照指定的格式冲文本中提取数据，并存入参数中
	fmt.Println("parsed:", name, age)
}
