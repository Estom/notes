package main

import (
	"crypto/md5"
	"fmt"
	"io"
)

func main() {
	h := md5.New()
	io.WriteString(h, "demo")
	fmt.Printf("%x\n", h.Sum(nil)) // New()  Sum()
}
