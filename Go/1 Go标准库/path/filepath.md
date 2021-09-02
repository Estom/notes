# 概述
`filepath`包的功能和`path`包类似，但是对于不同操作系统提供了更好的支持。filepath包能够自动的根据不同的操作系统文件路径进行转换，所以如果你有跨平台的需求，你需要使用`filepath`。
# 与`path`包相同的函数
`filepath`包中的函数和path包很类似，其中对应函数的功能相同，只是一个可以跨平台，一个不能，所以这里不详细展开，可以从 [path](https://github.com/preytaren/go-doc-zh/blob/master/path/path.md) 中获取这些函数的详细说明。主要函数如下：

- func Base(path string) string
- func Dir(path string) string
- func Ext(path string) string
- func Join(elem ...string) string
- func Split(path string) (dir, file string)

# 其他函数
剩下的还有两个函数值得一说，一个是`Abs`函数，可以将一个文件路径转换为绝对路径。函数声明如下：

```
func Abs(path string) (string, error)
```

另一个是`Walk`函数，和`filepath`包中的其他函数不同，它并不对文件路径字符串进行操作，而可以访问更多文件信息。它通过遍历的方式对目录中的每个子路径进行访问，函数接收两个参数，一个是路径名，另一个是遍历函数`WalkFunc`，函数声明如下：

```
func Walk(root string, walkFn WalkFunc) error

type WalkFunc func(path string, info os.FileInfo, err error) error
```
WalkFunc接收三个参数，分别是当前子路径，路径的`FileInfo`对象，以及一个可能的访问错误信息。下面是一个简单的示例，打印了当前目录的所有文件。

```
package main

import (
	"path/filepath"
	"os"
	"fmt"
)

func main() {

	filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		fmt.Println(info.Name())
		return nil
	})
}
```

