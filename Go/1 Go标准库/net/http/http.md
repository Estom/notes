# 概述
net/http可以用来处理HTTP协议，包括HTTP服务器和HTTP客户端，http包主要由五个部分组成：
- Request，HTTP请求对象
- Response，HTTP响应对象
- Client，HTTP客户端
- Server，HTTP服务端

# 最简单的使用
http包提供了对应于每个HTTP动词的函数来发送HTTP请求，当你不需要对请求进行详细的定制时可以直接使用它们。

```
resp, err := http.Get("http://example.com/") // GET 

resp, err := http.Post("http://example.com/") // POST

resp, err := http.PostForm("http://example.com/", url.Values{"foo": "bar"}) // 提交表单
```

# HTTP请求和响应
HTTP作为一个通信协议，通过报文传递信息；报文分为请求报文和响应报文，在http包中，分别用Reqeust和Response对象进行了抽象。
## Request
可以通过NewRequest创建一个Request对象，方法声明如下，需要传入HTTP方法，URL以及报文体进行初始化：

```
func NewRequest(method, url string, body io.Reader) (*Request, error)
```
Request对象主要用于数据的存储，结构如下：

```
type Request struct {
       
        Method string // HTTP方法
        URL *url.URL // URL
        
        Proto      string // "HTTP/1.0"
        ProtoMajor int    // 1
        ProtoMinor int    // 0

        Header Header // 报文头
        Body io.ReadCloser // 报文体
        GetBody func() (io.ReadCloser, error)
        ContentLength int64 // 报文长度
        TransferEncoding []string // 传输编码
        Close bool // 关闭连接
        Host string // 主机名
        
        Form url.Values // 
        PostForm url.Values // POST表单信息
        MultipartForm *multipart.Form // multipart，

        Trailer Header
        RemoteAddr string
        RequestURI string
        TLS *tls.ConnectionState
        Cancel <-chan struct{}
        Response *Response
}
```
可以看到Request对象可以对请求报文的各个方面进行设置，除了上述属性之外，Request也提供了一些方法对这些属性进行访问和修改，这里不具体展开，详细文档可见[Request](https://golang.org/pkg/net/http/#Request)。
## Response
和Request对象类似，Response也是一个数据对象，拥有多个字段来描述HTTP响应，需要注意的是Reponse对象拥有了当前Request对象的引用，对象的具体声明如下：

```
type Response struct {
        Status     string // HTTP 状态 "200 OK"
        StatusCode int    // 状态码 200
        Proto      string // 版本号 "HTTP/1.0"
        ProtoMajor int    // 主版本号 
        ProtoMinor int    // 次版本号

        Header Header // 响应报文头
        Body io.ReadCloser // 响应报文体
        ContentLength int64 // 报文长度
        TransferEncoding []string // 报文编码
        Close bool 
        Trailer Header
        Request *Request // 请求对象
        TLS *tls.ConnectionState
}
```


# Client
实际上第一节中的GET，POST等函数就是通过绑定到默认Client实现的。我们也可以创建自己的client对象，要通过Client发出HTTP请求，你需要首先初始化一个Client对象，然后发出请求，例如下面的程序可以访问Google：

```
package main

import "net/http"

func main() {
    client := http.Client()
    res, err := client.Get("http://www.google.com")
}
```
对于常用HTTP动词，Client对象都有对应的函数进行处理：

```
func (c *Client) Get(url string) (resp *Response, err error)

func (c *Client) Head(url string) (resp *Response, err error)

func (c *Client) Post(url string, contentType string, body io.Reader) (resp *Response, err error)

func (c *Client) PostForm(url string, data url.Values) (resp *Response, err error)
```
但是在很多情况下，需要支持对报文头，Cookies等的定制，上面提供的方法就不能满足需求了。所以Client对象还提供了一个Do方法，通过传入一个Request对象达到请求的定制化，具体方法声明如下：

```
func (c *Client) Get(url string) (resp *Response, err error)
```
下面一个简单的配置实例：

```
package main

import (
	"net/http"
	"fmt"
	"io/ioutil"
)

func main() {
	req, err := http.NewRequest(http.MethodGet, "http://www.baidu.com", nil)
	if err != nil {
		fmt.Println(err.Error())
		return
	}
	req.Header.Set("Cookie", "name=foo")
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	client := http.Client{}
	res, err := client.Do(req)

	// defer res.Body.Close()

	if err != nil {
		fmt.Println(err.Error())
		return
	}
	body, err := ioutil.ReadAll(res.Body)

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	fmt.Println(string(body))
}
```

# Server
http包除了可以发送HTTP请求之外，也可以创建HTTP服务器，对外提供访问。可以通过ListenandServe方法创建一个HTTP服务。

```
package main

import (
    "net/http"
    "io/ioutil"
    "log"
)

func EchoServer(w http.ResponseWriter, req *http.Request) {
    body, err := ioutil.ReadAll(req.Body)
    
    io.WriteString(w, body)
}

func main() {
    handleFunc := http.HandleFunc("/echo/", EchoServer)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```
在Server模块中，有两个概念，一个是URL，一个是Handler；前者是访问的URL，后者是对应的处理函数。Server需要完成从URL到Handler映射，在http包中的默认实现是DefaultServerMux，每个Handler需要通过HandleFunc进行注册。

除了上面的默认方式之外，和Client一样可以通过创建Server实例，对服务进行定制，整体的流程差别不大，这里就不再展开。

# HTTP方法和状态码
除了上面的内容以外，http包还定义了一系列常量用于表示HTTP动词和返回状态码，详见[constants](https://golang.org/pkg/net/http/#pkg-constants)