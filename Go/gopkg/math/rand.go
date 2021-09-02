package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {

	// 伪随机数
	fmt.Println(rand.Float32())   // 0.6046603			// 精确到小数点的后 8 位（4*8=32）
	fmt.Println(rand.Float64())   // 0.9405090880450124	// 精确到小数点的后 16 位
	fmt.Println(rand.Int())       // 6129484611666145821
	fmt.Println(rand.Intn(233))   // 81
	fmt.Println(rand.Int31n(233)) // 195

	fmt.Println(rand.Perm(4)) // [3 1 2 0]	// 随机打散 [0,n) 的整数序列

	// 设置 rand 的种子值，一般使用当前的纳秒时间戳
	rand.Seed(time.Now().UnixNano())
	fmt.Println(rand.Uint64()) // 每次随机的值都不同

	r := rand.New(rand.NewSource(233)) // 产生新的 rand 实例，并以 src 作为随机数生成器
	r.Seed(time.Now().UnixNano())
	fmt.Println(r.Int())
}
