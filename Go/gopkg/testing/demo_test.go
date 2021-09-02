package testing

import (
	"fmt"
	"testing"
)

func Benchmark(b *testing.B) {
	// 对于 N 的每次迭代，都是完整的执行流程
	b.Logf("N: %d\n", b.N)   // N 是基准测试的迭代运行次数 N:1
	b.Errorf("err occurred") // err occurred
	// b.FailNow() 			 // 测试失败并停止执行
	// b.Fail() 			 // 测试失败但继续执行
	if b.Failed() {
		fmt.Println("fail() 使测试函数失败，但是依旧会执行后边的代码")
	}
	b.Log("benchmark log")
	b.SetBytes(1000) // 每秒处理的字节数
}

func Test(t *testing.T) {
	t.Parallel()
}
