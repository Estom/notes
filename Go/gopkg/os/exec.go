// os/exec 负责运行系统命令
package main

import (
	"bytes"
	"fmt"
	"os/exec"
)

func main() {
	//
	// 执行外部命令
	//
	args := []string{"-r", "echo date(\"Y-m-d H:i:s\", time());"}
	cmd := exec.Command("php", args...)
	out, err := cmd.Output()
	fmt.Println(err, string(out)) // 在 err == nil 时调用 err.Error() 会 panic

	// Run() 是阻塞命令，会将命令运行的结果输出到 cmd.Stdout 指向的内存
	cmd = exec.Command("echo", "demo")
	var cmdBuf bytes.Buffer
	cmd.Stdout = &cmdBuf
	fmt.Println(cmd.Run())       // nil
	fmt.Println(cmdBuf.String()) // demo

	// 模拟阻塞运行
	cmd.Start()
	cmd.Wait()

	// 查询系统命令文件位置
	fmt.Println(exec.LookPath("echo")) // /bin/echo <nil>
}
