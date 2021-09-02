package main

import (
	"errors"
	"fmt"
)

func main() {
	fmt.Printf("%T\n", errors.New("err occurred")) // *errors.errorString
	fmt.Printf("%T\n", fmt.Errorf("err occurred")) // *errors.errorString
}
