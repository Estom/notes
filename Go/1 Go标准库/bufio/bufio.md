# 概述
bufio模块通过对io模块的封装，提供了数据缓冲功能，能够一定程度减少大块数据读写带来的开销。

实际上在bufio各个组件内部都维护了一个缓冲区，数据读写操作都直接通过缓存区进行。当发起一次读写操作时，会首先尝试从缓冲区获取数据；只有当缓冲区没有数据时，才会从数据源获取数据更新缓冲。
# Reader
可以通过`NewReader`函数创建bufio.Reader对象，函数接收一个io.Reader作为参数；也就是说，bufio.Reader不能直接使用，需要绑定到某个io.Reader上。函数声明如下：

```
func NewReader(rd io.Reader) *Reader

func NewReaderSize(rd io.Reader, size int) *Reader // 可以配置缓冲区的大小
```
相较于io.Reader，bufio.Reader提供了很多实用的方法，能够更有效的对数据进行读取。首先是几个基础方法，它们能够对Reader进行细粒度的操作：

- Read，读取n个byte数据
- Discard，丢弃接下来n个byte数据
- Peek，获取当前缓冲区内接下来的n个byte，但是不移动指针
- Reset，清空整个缓冲区

具体的方法声明如下：

```
func (b *Reader) Read(p []byte) (n int, err error)

func (b *Reader) Discard(n int) (discarded int, err error)

func (b *Reader) Peek(n int) ([]byte, error)

func (b *Reader) Reset(r io.Reader)
```
除了上面的基础操作之外，bufio.Reader还提供了多个更高抽象层次的方法对数据进行简单的结构化读取。主要包括如下几个方法：

- ReadByte，读取一个byte
- ReadRune，读取一个utf-8字符
- ReadLine，读取一行数据，由'\n'分隔
- ReadBytes，读取一个byte列表
- ReadString，读取一个字符串

其中前三个函数都没有参数，会从缓冲区读取一个满足需求的数据。后面两个函数接收一个参数delim，用于做数据拆分，持续读取数据直到当前字节的值等于delim，然后返回这些数据；实际上这两个函数功能相同，只是在函数返回值的类型上有所区别。具体的方法声明如下：

```
func (b *Reader) ReadByte() (byte, error)

func (b *Reader) ReadRune() (r rune, size int, err error)

func (b *Reader) ReadLine() (line []byte, isPrefix bool, err error)

func (b *Reader) ReadBytes(delim byte) ([]byte, error)

func (b *Reader) ReadString(delim byte) (string, error)
```

下面是一个简单的示例，使用ReadString方法获取用‘ ’分隔的字符串。

```
package main

import (
	"bufio"
	"fmt"
	"strings"
)

func main() {
	r := strings.NewReader("hello world !")
	reader := bufio.NewReader(r)

	for {
		str, err := reader.ReadString(byte(' '))
		fmt.Println(str)
		if err != nil {
			return
		}
	}
}
```
# Scanner
实际使用中，更推荐使用Scanner对数据进行读取，而非直接使用Reader类。Scanner可以通过splitFunc将输入数据拆分为多个token，然后依次进行读取。

和Reader类似，Scanner需要绑定到某个io.Reader上，通过NewScannner进行创建，函数声明如下：

```
func NewScanner(r io.Reader) *Scanner
```

在使用之前还需要设置splitFunc（默认为ScanLines），splitFunc用于将输入数据拆分为多个token。bufio模块提供了几个默认splitFunc，能够满足大部分场景的需求，包括：

- ScanBytes，按照byte进行拆分
- ScanLines，按照行("\n")进行拆分
- ScanRunes，按照utf-8字符进行拆分
- ScanWords，按照单词(" ")进行拆分

通过Scanner的Split方法，可以为Scanner指定splitFunc。使用方法如下：

```
scanner := bufio.NewScanner(os.StdIn)

scanner.split(bufio.ScanWords）
```
除此了默认的splitFunc之外，也可以定义自己的splitFunc，函数需要满足如下声明：

```
type SplitFunc func(data []byte, atEOF bool) (advance int, token []byte, err error)
```
函数接收两个参数，第一个参数是输入数据，第二个参数是一个标识位，用于标识当前数据是否为结束。函数返回三个参数，第一个是本次split操作的指针偏移；第二个是当前读取到的token；第三个是返回的错误信息。

在完成了Scanner初始化之后，通过Scan方法可以在输入中向前读取一个token，读取成功返回True；使用Text和Bytes方法获取这个token，Text返回一个字符串，Bytes返回字节数组。方法声明如下：

```
func (s *Scanner) Scan() bool

func (s *Scanner) Text() string

func (s *Scanner) Text() []byte
```

下面的示例使用Scanner对上面的示例进行了重现，可以看到和Reader相比，Scanner的使用更加便捷。

```
package main

import (
	"bufio"
	"strings"
	"fmt"
)

func main() {

	scanner := bufio.NewScanner(strings.NewReader("hello world !"))

	scanner.Split(bufio.ScanWords)

	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}

}

```

# Writer
和Reader类似，Writer也对应的提供了多组方法。基础方法包括如下几个：

``` 
func (b *Writer) Write(p []byte) (nn int, err error) // 写入n byte数据

func (b *Writer) Reset(w io.Writer) // 重置当前缓冲区

func (b *Writer) Flush() error // 清空当前缓冲区，将数据写入输出
```

此外，Writer也提供了多个方法方便我们进行数据写入操作：

``` 
func (b *Writer) WriteByte(c byte) error  // 写入一个字节

func (b *Writer) WriteRune(r rune) (size int, err error） // 写入一个字符

func (b *Writer) WriteString(s string) (int, error) // 写入一个字符串
```