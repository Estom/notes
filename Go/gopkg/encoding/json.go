// json 包有面向字符串和 struct 的序列化与反序列化
// 还有面向字节流的编码器和解码器
// 最后还有 HTMLEscape
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"os"
	"strings"
)

type User struct {
	Name string   `json:"name"`
	Age  int      `json:"age"`
	Tags []string `json:"tags"`
}

func main() {
	//
	// 序列化
	//
	u := User{
		Name: "pike",
		Age:  60,
		Tags: []string{"C", "C++", "Go"},
	}
	b, _ := json.Marshal(u)                 // JSON 序列化
	fmt.Println(string(b))                  // {"name":"pike","age":60,"tags":["C","C++","Go"]}
	b, _ = json.MarshalIndent(u, "", "   ") // struct + 缩进 -> []byte
	var user User                           // 序列化与反序列化是针对 struct <-> []byte 而言的
	_ = json.Unmarshal(b, &user)            // JSON 反序列化

	s := `{"name":"wuYin", "age":"20"}`
	dst := bytes.NewBuffer(nil)
	json.Indent(dst, []byte(s), "_", "++++") // []byte(s) + 缩进 -> buffer
	fmt.Println(dst.String())
	// {
	// _++++"name": "wuYin",
	// _++++"age": "20"
	// _}

	//
	// 流式编码解码器
	//
	// decoder 是从流中按序列读取数据，不会识别除目标结构以外的其他字符   ,  // 此处的 , 是无法解析的
	streamJSON := `{"name":"pike","age":20,"tags":["C","C++","Go"]}{"name":"ken","age":20,"tags":["C","C++","Go"]}`
	// 指向输入流的流式编码器
	dec := json.NewDecoder(strings.NewReader(streamJSON))
	for {
		var u User
		err := dec.Decode(&u)
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err) // 遇到未知错误
		}
		fmt.Println(u)
	}

	// 指向输出流的流式编码器
	enc := json.NewEncoder(os.Stdout)
	if err := enc.Encode(u); err != nil {
		fmt.Println(err)
	}

	//
	// 格式化
	//
	// 专门针对 JSON 的 copy 操作
	buff := bytes.NewBuffer(nil)
	_ = json.Compact(buff, b)
	fmt.Println(buff.String()) // 此处把 JSON 的缩进清除了
	// 转义 < > &
	s = `{"name":"<script>alert('f**k')</script>", "age:1&1"}`
	json.HTMLEscape(buff, []byte(s))
	fmt.Println(string(buff.Bytes())) // {"name":"\u003cscript\u003ealert('f**k')\u003c/script\u003e", "age:1\u00261"}
}
