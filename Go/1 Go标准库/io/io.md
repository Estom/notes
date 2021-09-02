# 概述
IO是操作系统的基础概念，是对输入输出设备的抽象。Go语言的io库对这些功能进行了抽象，通过统一的接口对输入输出设备进行操作。

# Reader
Reader对象是对输入设备的抽象，一个Reader可以绑定到一个输入对象，并在这个输入设备上读取数据，其声明如下：

```
type Reader interface {
    Read(p []byte) (n int, err error)
}
```
除了基础的Reader类之外，io包中还有LimitReader，MultiReader和TeeReader。其中LimitReader只读取指定长度的数据；MultiReader用于聚合多个Reader，并依次进行读取；TeeReader将一个输入绑定到一个输出。具体声明如下：

```
func LimitReader(r Reader, n int64) Reader

func MultiReader(readers ...Reader) Reader

func TeeReader(r Reader, w Writer) Reader
```
这些衍生Reader都以包装的方式进行使用，也就是传入一个Reader，在这个Reader上增加额外功能，然后返回这个新Reader。下面是一个简单的使用实例。

```
package main

import (
	"io"
	"strings"
	"os"
)

func main() {
	r := strings.NewReader("some io.Reader stream to be read\n")
	lr := io.LimitReader(r, 4)
	io.Copy(os.Stdout, lr)
}
```
## ReadAtLeast & ReadFull
这两个函数用于从Reader里面读取数据到指定缓冲区，ReadAtLeast会读取至少n个字节的数据，ReadFull会读取直到数据填满整个缓冲区。其函数声明如下：

```
func ReadAtLeast(r Reader, buf []byte, min int) (n int, err error)

func ReadFull(r Reader, buf []byte) (n int, err error)
```


# Writer
Writer对象是对输出设备的抽象，一个Writer可以绑定到一个输出对象，并在这个输出设备上写入数据，其声明如下：

```
type Writer interface {
    Write(p []byte) (n int, err error)
}
```
和Reader类似，Writer也有MultiWriter，可以同步输出到多个Writer，声明如下：

```
func MultiWriter(writers ...Writer) Writer
```
## WriteString
WriteString函数用于向某个Writer写入一个字符串，其声明如下：

```
func WriteString(w Writer, s string) (n int, err error)
```

# ReadWriter
整合了Reader和Writer，可以同时进行读取和写入操作，声明如下：

```
type ReadWriter interface {
        Reader
        Writer
}
```

# Copy
io的一个常用操作就是数据的复制，io包中提供了多个复制函数，直接将数据从Writer复制到Reader。
## Copy
Copy是最基础的复制函数，读取Writer中的数据，直到EOF，并写入Reader，函数声明如下：

```
func Copy(dst Writer, src Reader) (written int64, err error)
```
## CopyBuffer
CopyBuffer函数在Copy的基础上可以指定数据缓冲区。每次调用Copy函数时，都会生成一块临时的缓冲区，会带来一定的分配开销；CopyBuffer可以多次复用同一块缓冲区，其函数声明如下：

```
func CopyBuffer(dst Writer, src Reader, buf []byte) (written int64, err error)
```

## CopyN
CopyN在Copy的基础上，可以额外指定拷贝制定字节的数据，其函数声明如下：

```
func CopyN(dst Writer, src Reader, n int64) (written int64, err error)
```
# 更多内容
io库中还有许多本文未涉及的内容，包括PipeReader，PipeWriter，ByteReader，ByteWriter等针对具体类型的实例和一些辅助函数。详见 [golang/io](https://golang.org/pkg/io/)