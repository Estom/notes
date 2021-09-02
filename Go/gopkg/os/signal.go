// os/signal 用于程序运行时的信号捕获、处理
package main

import (
	"fmt"
	"os"
	"os/signal"
)

func main() {
	signalCh := make(chan os.Signal)
	signal.Notify(signalCh, os.Interrupt)
	s := <-signalCh
	fmt.Println("I catch signal: ", s.String())
}
