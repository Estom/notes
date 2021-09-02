// strings 包使用示例
package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {

	//
	// 包含与判断
	//
	fmt.Println(strings.Contains("mix", ""))              // true // "mix" 认为包含 "" 空串
	fmt.Println(strings.ContainsAny("mix", "xml"))        // true // 'x'
	fmt.Println(strings.ContainsRune("吴胤", '胤'))          // true
	fmt.Println(strings.HasPrefix("err: failed", "err:")) // true
	fmt.Println(strings.HasSuffix("err: failed", "fail")) // false
	fmt.Println(strings.EqualFold("Go", "go"))            // true // 转为全小写检查 UTF8 编码的底层 Unicode 是否一致

	//
	// 计数与索引
	//
	fmt.Println(strings.Count("hello", "l"))           // 2
	fmt.Println(strings.Count("hello", ""))            // 6
	fmt.Println(strings.Index("winner", "in"))         // 1
	fmt.Println(strings.Index("winner", "f"))          // -1 // 不存在返回 -1
	fmt.Println(strings.IndexAny("winner", "air"))     // 1
	fmt.Println(strings.IndexRune("winner", 'r'))      // 5
	fmt.Println(strings.LastIndex("winner", "i"))      // 1
	fmt.Println(strings.LastIndexAny("winner", "min")) // 3
	// 遍历返回符合 index 的 rune 位置
	index := func(r rune) bool {
		if r > 'b' {
			return true
		}
		return false
	}
	fmt.Println(strings.IndexFunc("abcd", index))      // 2 // c
	fmt.Println(strings.LastIndexFunc("abcda", index)) // 3 // d

	//
	// 连接与切割
	//
	fmt.Println("ba" + strings.Repeat("na", 2))                     // banana
	fmt.Println(strings.Join([]string{"hello", "world", "!"}, "-")) // hello-world-!
	fmt.Printf("%q\n", strings.Split("a,b,c", ""))                  // ["a" "," "b" "," "c"]
	fmt.Printf("%q\n", strings.Split("a,b,c", ","))                 // ["a" "b" "c"]
	fmt.Printf("%q\n", strings.SplitN("a,b,c", ",", 2))             // ["a" "b,c"]     // 最多保留 2 个子串，前 2-1 个是分割后的有效子串
	fmt.Printf("%q\n", strings.SplitAfter("a,b,c", ","))            // ["a," "b," "c"] // 保留 sep 切割字符
	fmt.Printf("%q\n", strings.SplitAfterN("a,b,c", ",", 2))        // ["a," "b,c"]
	fmt.Printf("%q\n", strings.Fields("I  am   best"))              // ["I" "am" "best"] // 按空格分割字符串
	// 自定义分割字符串的逻辑函数
	// 遍历参数字符串的每个字符，若符合 split 逻辑则按该字符分割，且该字符保留
	split := func(r rune) bool {
		if r > 'b' {
			return true
		}
		return false
	}
	fmt.Printf("%q\n", strings.FieldsFunc("vavbve", split)) // ["a" "b"]

	//
	// 大小写处理
	//
	fmt.Println(strings.Title("hello"))   // Hello
	fmt.Println(strings.ToLower("HellO")) // hello
	fmt.Println(strings.ToTitle("ǳ"))     // ǲ
	fmt.Println(strings.ToUpper("ǳ"))     // Ǳ	// 某些特殊的 Unicode 字符并不一致

	//
	// trim 处理
	//
	// 将 string 开头和结尾包含字符集的字符全部过滤掉
	fmt.Println(strings.Trim("anhellok ", "ak "))      // nhello
	fmt.Println(strings.TrimLeft("anhellok ", "ak "))  // nhellok
	fmt.Println(strings.TrimRight("anhellok ", "ak ")) // anhello
	// trim 所有大写字母 // A:65, a:97
	trimF := func(r rune) bool {
		if r < 'Z' {
			return true
		}
		return false
	}
	fmt.Println(strings.TrimFunc("HellO", trimF))         // ell
	fmt.Println(strings.TrimLeftFunc("HellO", trimF))     // ellO
	fmt.Println(strings.TrimRightFunc("HellO", trimF))    // Hell
	fmt.Printf("%q\n", strings.TrimSpace(" \t TLV \n\r")) // "TLV"

	//
	// 遍历与替换
	//
	mapRune := func(r rune) rune {
		return r + 1 // return r + math.MaxInt32  // 处理不正确会丢弃该字符
	}
	fmt.Println(strings.Map(mapRune, "abc吴"))             // bcd吵
	rp := strings.NewReplacer("x", "X", "y", "Y")         // 配对出现的旧-新字符串
	fmt.Println(rp.Replace("six year"))                   // siX Year
	rp.WriteString(os.Stdout, "six year\n")               // siX Year 将替换后的字符串输出 Writer
	fmt.Println(strings.Replace("wow what", "w", "W", 2)) // WoW what // n<0 则全部替换

	//
	// Reader 相关
	//
	rStr := "wuYin吴" // [119 117 89 105 110 229 144 180]
	r := strings.NewReader(rStr)

	// reader 中未读取的字符串长度
	fmt.Println(r.Len()) // 8（5+3）
	b := make([]byte, 2)

	// 从 reader 中读取全部字符串到 b 中，返回实际读取的字节数 n 和错误 err
	n, err := r.Read(b)
	fmt.Println(err, n, b) // nil 2 [119 117] // rStr = "" 则出错 EOF

	// 从指定的 offset 位置开始读取内容到 b
	// offset < 0 || offset > (len(rStr) - len(b)) 则报错 EOF
	n, err = r.ReadAt(b, 3)
	fmt.Println(err, n, b) // nil 2 [105 110]

	oneByte, err := r.ReadByte()
	fmt.Println(err, oneByte) // nil 89 // 此时 reader 中的数据 0,1,3,4 的数据都已被读取

	oneRune, size, err := r.ReadRune()
	fmt.Println(err, oneRune, size) // nil 105 1

	r.Seek(2, 1) // 将 seeker 向后挪 2 位
	oneByte, err = r.ReadByte()
	fmt.Println(err, oneByte) // nil 144

	r.UnreadByte() // seeker 从 180 回滚到 114
	oneByte, err = r.ReadByte()
	fmt.Println(err, oneByte) // nil 144
}
