# 概述
path包提供了许多辅助函数来处理UNIX系统文件路径，
# 辅助函数
一个unix文件路径有如下格式`<DirName>/<BaseName>`分别对应于目录路径和基础路径，当这个路径表示一个文件时，BaseName就对应于文件名。

其中Base函数获取一个路径的BaseName，Dir函数获取一个路径的DirName；具体函数声明如下：

```
func Base(path string) string

func Dir(path string) string
```
在UNIX文件系统中，一个完整文件名由文件名和文件后缀组成，比如.go，.c；Ext函数可以用于获取路径中的后缀名。

```
func Ext(path string) string
```
对于一个目录和文件还有绝对路径和相对路径的概念，绝对路径就是从根目录开始的完整路径，比如`/a/b/c`；相对路径就是相对于当前目录的路径，比如`a/b/c`，`../a/b/c`。使用IsAbs可以判断一个路径是否是绝对路径；具体函数声明如下：

```
func IsAbs(path string) bool
```
最后，path包还提供了两个函数用于组合和拆分一个文件路径。Split函数将路径拆分为目录名和文件名；Join函数以`/`为分隔符将多个字符串进行连接；函数声明如下：

```
func Split(path string) (dir, file string)

func Join(elem ...string) string
```

# 实例

```
package main

import (
	"path"
	"fmt"
)

func main() {
	p := "foo/bar.tar"
	
	sDir, sBase := path.Split(p)

	fmt.Println(sDir)
	fmt.Println(sBase)
	fmt.Println(path.Ext(p))
}
```


