package main

import (
	"encoding/xml"
	"fmt"
	"os"
)

type Loc struct {
	Country  string
	Province string
}

type City struct {
	Loc
	ID     int    `xml:"-"`                // 不输出
	People int    `xml:"people,omitempty"` // 值为空时不输出
	Name   string `xml:"name"`
}

func main() {
	//
	// 序列化
	//
	c := City{ID: 1, Name: "西安"}
	c.Loc = Loc{"中国", "陕西"}
	b, _ := xml.Marshal(c)
	os.Stdout.Write(b) // <City><Country>中国</Country><Province>陕西</Province><name>西安</name></City>

	fmt.Println()
	b, _ = xml.MarshalIndent(c, "", "    ")
	fmt.Println(string(b))
	// <City>
	//    <Country>中国</Country>
	//    <Province>陕西</Province>
	//    <name>西安</name>
	// </City>

	//
	// 转义
	//
	s := `<x>233</x>`                // 将字符串中的 xml 保留字符转义
	xml.Escape(os.Stdout, []byte(s)) // &lt;x&gt;233&lt;/x&gt;
}
