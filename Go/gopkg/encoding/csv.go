// Comma-Separated Values
// 逗号分割值文件
package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strings"
)

func main() {

	// 单行读取
	r := strings.NewReader("a,b,c")
	csvR := csv.NewReader(r)
	records, _ := csvR.Read()
	fmt.Println(records) // [a b c]

	// 全部读取
	f, _ := os.Open("demo.csv")
	csvR = csv.NewReader(f)
	fmt.Println(csvR.ReadAll()) // [[...]]

	// 单行写入
	w := csv.NewWriter(os.Stdout)
	_ = w.Write(records)
	w.Flush() // a,b,c	// 类 Flush() 函数将缓冲区的数据写入真实文件，勿忘

	// 批量写入
	strs := [][]string{{"x", "y", "z"}, {"X", "Y", "Z"}}
	w.WriteAll(strs)
	w.Flush()
	// x,y,z
	// X,Y,Z
}
