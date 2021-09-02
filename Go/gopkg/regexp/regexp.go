// regexp 包负责正则表达式的匹配与搜索
package main

import (
	"fmt"
	"regexp"
	"strings"
)

func main() {
	b := []byte("my score is 201.29 and 10.223")
	re := "[0-9]+[.][0-9]+"

	//
	// 匹配
	//
	fmt.Println(regexp.Match(re, b))               // true nil
	fmt.Println(regexp.MatchString(re, string(b))) // true nil

	floatRe, _ := regexp.Compile(re) // 返回正则对象
	floatRe = regexp.MustCompile(re) // 失败则 panic

	//
	// find
	//
	fmt.Printf("%s\n", floatRe.Find(b))        // 返回第一个匹配到的 []byte	// 201.29
	fmt.Printf("%s\n", floatRe.FindAll(b, -1)) // [201.29 10.223]
	fmt.Println(floatRe.FindIndex(b))          // 返回匹配到的结果的首尾下标	// [12 18]
	fmt.Println(floatRe.FindAllIndex(b, -1))   // [[12 18] [23 29]]

	//
	// replace
	//
	fmt.Println(floatRe.ReplaceAllString(string(b), "_")) // my score is _ and _
	charsRe := regexp.MustCompile("[a-z]*")
	fmt.Println(charsRe.ReplaceAllStringFunc(string(b), strings.ToUpper)) // MY SCORE IS 201.29 AND 10.223

}
