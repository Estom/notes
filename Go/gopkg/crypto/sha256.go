package main

import (
	"crypto/sha256"
	"fmt"
	"io"
)

func main() {
	h := sha256.New()
	io.WriteString(h, "demo")
	fmt.Printf("%x\n", h.Sum(nil))
}
