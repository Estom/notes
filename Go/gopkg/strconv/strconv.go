// strconv 包使用示例
package main

import (
	"fmt"
	"strconv"
)

func main() {

	//
	// 将值格式化为字符串：Format*()
	//
	fmt.Printf("%q\n", strconv.Itoa(233))                      // "233"   // 等同于 FormatInt(n, 10)
	fmt.Printf("%q\n", strconv.FormatBool(true))               // "true"
	fmt.Printf("%q\n", strconv.FormatInt(8, 2))                // "1000"  // trick: 数字的转换可顺便作为进制的转换
	fmt.Printf("%q\n", strconv.FormatFloat(1.239, 'f', 2, 64)) // "1.24"  // 按照指定格式 f 和指定浮点数经度 2 来格式化浮点数

	//
	// 将字符串解析为值：Parse*()
	//
	fmt.Println(strconv.Atoi("1")) // nil 1 // 若无法转换则 err != nil 且 i 为 0(int 零值)
	// 解析为 true  的字符串：1, t, T, TRUE, true, True
	// 解析为 false 的字符串：0, f, F, FALSE, false, False
	fmt.Println(strconv.ParseBool("true"))         // true nil
	fmt.Println(strconv.ParseBool("1"))            // true nil
	fmt.Println(strconv.ParseBool("0"))            // false nil
	fmt.Println(strconv.ParseInt("010101", 2, 8))  // 21 nil	// 将字符串解释为 2 进制，转为 int8 类型（精度跟随）
	fmt.Println(strconv.ParseFloat("1.233e2", 64)) // 123.3 nil

	//
	// 将各种类型的值转为 string 类型后，对 []byte 进行追加操作
	//
	b := []byte{'a'}                                              // [97]
	fmt.Printf("%q\n", strconv.AppendBool(b, true))               // "atrue"
	fmt.Printf("%q\n", strconv.AppendFloat(b, 1.239, 'e', 2, 64)) // "a1.24e+00
	// 整数的底层进制限制在 [0, 36] 之间，其中 36=（10个数字+26个字母）
	fmt.Printf("%q\n", strconv.AppendInt(b, 233, 2))         // "a11101001" // 底层进制：0<base<=36(10 + 26)
	fmt.Printf("%q\n", strconv.AppendUint(b, 233, 36))       // "a6h"
	fmt.Println(string(strconv.AppendQuote(b, "what	a"))) // a"what\ta"  // 将字符串用 "" 括起来后追加，特殊字符会被转义
	fmt.Println(string(strconv.AppendQuoteRune(b, '吴')))     // a'吴'

	//
	// 字符串的引号相关
	//
	// 加引号
	fmt.Println(strconv.Quote(strconv.Quote("China No.1"))) // "\"China No.1\""
	fmt.Println(strconv.QuoteRune('x'))                     // 'x'
	// 解引号
	fmt.Println(strconv.Unquote("\"x\"")) // x nil
	// 判断字符串能否由反引号 `` 所表示，字符串中不能包含 ` 和除 \t 以外的其他转义字符
	fmt.Println(strconv.CanBackquote("C:\\Win32\t")) // true
	fmt.Println(strconv.CanBackquote("C:\\Win32\a")) // false
	fmt.Println(strconv.CanBackquote("C:\\Win32`"))  // false
	// 判断字符是否可打印 / 是否为转义字符
	fmt.Println(strconv.IsPrint(' '), strconv.IsPrint('\n')) // true false
}
