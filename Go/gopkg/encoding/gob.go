// go binary 二进制编码解码
// gob 的数据都是直接面向二进制的 Reader 和 Writer，通过实例化后 encoder 和 decoder 来操作数据
package main

import (
	"encoding/gob"
	"fmt"
	"os"
)

type Color struct {
	Red    int
	Yellow int
	Blue   int
}

func main() {
	colors := []Color{{0, 0, 0}, {255, 255, 255}}
	f, _ := os.OpenFile("color.gob", os.O_CREATE|os.O_WRONLY, 0666)
	defer f.Close()

	enc := gob.NewEncoder(f) // 为 writer 创建一个二进制流的编码器
	_ = enc.Encode(colors)

	f, _ = os.Open("colors.gob")
	dec := gob.NewDecoder(f)
	var newColors []Color
	fmt.Println(dec.Decode(&newColors)) // invalid argument	// 单个 struct 可以，数组不行，暂时无解
}
