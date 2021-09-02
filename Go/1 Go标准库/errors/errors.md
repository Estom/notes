# 概述
在go中没有异常捕获机制，而是通过一个单独的函数返回值来表示错误信息。

# Error
错误类型的接口定义如下：

```
type error interface {
        Error() string
}
```
这个接口只有一个方法`Error`，这个方法返回一个字符串，描述错误的详情。在使用中，通常会通过直接实现`Error`方法来自定义错误类型，同时也可以传递不同的参数对错误状态进行更详细的说明，例如：

```
type AError struct {
    MoreInfo string
}

func (err *AError) Error() string {
    return fmt.Sprintf("Basic Error Info: %s", err.MoreInfo)
}

```
此外，当使用`fmt.Print`函数打印时，会自动的调用`Error`方法。
# errors
但是对于大多数的自定义错误，只需要简单的错误描述，上面的声明方法过于繁琐。所以在errors包中提供了一种更简单的方法对错误进行自定义。

`errors.New`接收一个字符串，并返回一个错误对象，该错误对象的`Error`方法返回该字符串，函数声明如下：

```
func New(text string) error
```
有了这个函数，就可以像这样自定义错误对象了：

```
var (
    AError = errors.New("AError")
    BError = errors.New("BError")
    CError = errors.New("CError")
)
```
# 更多内容
- [[1] Error and Go](https://blog.golang.org/error-handling-and-go)