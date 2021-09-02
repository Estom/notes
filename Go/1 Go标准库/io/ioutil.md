# 概述
前面的io包提供了对输入输出设备最基本的抽象，而ioutil在io包的基础上提供了一系列的函数来应对具体的场景。
# 数据读取
ioutil一共提供了三个数据读取的函数，分别是：
- ReadAll，从一个io.Reader读取所有数据，并返回一个字节数组
- ReadllDir，从一个目录读取数据，并得到这个目录里的文件对象列表
- ReadFile，读取指定文件的内容，并返回一个字节数组

其函数声明如下：

```
func ReadAll(r io.Reader) ([]byte, error)

func ReadDir(dirname string) ([]os.FileInfo, error)

func ReadFile(filename string) ([]byte, error)
```


可以看到上面的三个函数分别对应于三个特定的场景，下面以ReadFile为例对其使用进行说明

```
package main

import (
     "fmt"
     "io/ioutil"
)

func main() {
    content, err := ioutil.ReadFile("demo.txt")
    
    if err != nil {
        fmt.Fatal(err) 
    }
    
    fmt.Print(content)
}
```

# 临时文件
ioutil也支持创建临时目录和文件，分别通过TempDir和TempFile函数实现，文件和目录不会自动销毁，需要使用者自行对创建的临时文件进行处理，可以使用`os.Remove()`删除文件。

使用TempDir可以创建一个临时的目录，函数接收父目录名和目录前缀名作为参数，创建一个临时目录并返回它的名字，具体函数声明如下：


```
func TempDir(dir, prefix string) (name string, err error)
```

使用TempFile可以创建一个临时的文件，同样可以指定路径和文件名前缀，函数返回这个文件对象，可以直接对文件进行读写。具体函数声明如下：


```
func TempFile(dir, prefix string) (f *os.File, err error)
```

# 文件写入
和文件读取类似，WriteFile可以对文件进行写入，函数接收三个参数，分别是要写入的文件名，写入的数据，以及一个文件信息标识位。具体的标识位可以见文档 [FileMode](https://golang.org/pkg/os/#FileMode)。WriteFile函数声明如下：
```
func WriteFile(filename string, data []byte, perm os.FileMode) error
```