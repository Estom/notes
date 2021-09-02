基于原文：[Go语言基础之net/http](https://www.liwenzhou.com/posts/Go/go_http/) 和视频 [120-121](https://www.bilibili.com/video/BV17Q4y1P7n9?p=120) 整理

Go 语言内置的 net/http 包提供了 HTTP 客户端和服务端的实现。

## 19.1 HTTP 协议

`HTTP 协议`，即超文本传输协议（HTTP，HyperText Transfer Protocol)。是互联网上应用最为广泛的一种网络传输协议，所有的 WWW 文件都必须遵守这个标准。设计 HTTP 最初的目的是为了提供一种发布和接收 HTML 页面的方法。


## 19.2 HTTP客户端

### 19.2.1  基本的 HTTP/HTTPS 请求

Get、Head、Post 和 PostForm 函数发出 HTTP/HTTPS 请求。

```go
resp, err := http.Get("http://example.com/")
...
resp, err := http.Post("http://example.com/upload", "image/jpeg", &buf)
...
resp, err := http.PostForm("http://example.com/form",
	url.Values{"key": {"Value"}, "id": {"123"}})
```
	
程序在使用完 response 后必须关闭回复的主体。

```go
resp, err := http.Get("http://example.com/")
if err != nil {
	// handle error
}
defer resp.Body.Close()
body, err := ioutil.ReadAll(resp.Body)
// ...
```

### 19.2.2 GET 请求示例

使用 net/http 包编写一个简单的发送 HTTP 请求的 Client 端，代码如下：

```go
package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func main() {
	resp, err := http.Get("https://www.liwenzhou.com/")
	if err != nil {
		fmt.Printf("get failed, err:%v\n", err)
		return
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("read from resp.Body failed, err:%v\n", err)
		return
	}
	fmt.Print(string(body))
}
```

将上面的代码保存之后编译成可执行文件，执行之后就能在终端打印 liwenzhou.com 网站首页的内容了.

我们的浏览器其实就是一个发送和接收 HTTP 协议数据的客户端，我们平时通过浏览器访问网页其实就是从网站的服务器接收 HTTP 数据，然后浏览器会按照 HTML、CSS 等规则将网页渲染展示出来。

### 19.2.3 带参数的 GET 请求示例

关于 GET 请求的参数需要使用 Go 语言内置的 `net/url` 这个标准库来处理。

```go
func main() {
	apiUrl := "http://127.0.0.1:9090/get"
	// URL param
	data := url.Values{}
	data.Set("name", "小王子")
	data.Set("age", "18")
	u, err := url.ParseRequestURI(apiUrl)
	if err != nil {
		fmt.Printf("parse url requestUrl failed, err:%v\n", err)
	}
	u.RawQuery = data.Encode() // URL encode
	fmt.Println(u.String())
	resp, err := http.Get(u.String())
	if err != nil {
		fmt.Printf("post failed, err:%v\n", err)
		return
	}
	defer resp.Body.Close()
	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("get resp failed, err:%v\n", err)
		return
	}
	fmt.Println(string(b))
}
```

对应的 Server 端 HandlerFunc 如下：

```go
func getHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	data := r.URL.Query()
	fmt.Println(data.Get("name"))
	fmt.Println(data.Get("age"))
	answer := `{"status": "ok"}`
	w.Write([]byte(answer))
}
```

### 19.2.4 Post 请求示例

上面演示了使用 net/http 包发送 GET 请求的示例，发送 POST 请求的示例代码如下：

```go
package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
)

// net/http post demo

func main() {
	url := "http://127.0.0.1:9090/post"
	// 表单数据
	//contentType := "application/x-www-form-urlencoded"
	//data := "name=小王子&age=18"
	// json
	contentType := "application/json"
	data := `{"name":"小王子","age":18}`
	resp, err := http.Post(url, contentType, strings.NewReader(data))
	if err != nil {
		fmt.Printf("post failed, err:%v\n", err)
		return
	}
	defer resp.Body.Close()
	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("get resp failed, err:%v\n", err)
		return
	}
	fmt.Println(string(b))
}
```

对应的 Server 端 HandlerFunc 如下：

```go
func postHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	// 1. 请求类型是application/x-www-form-urlencoded时解析form数据
	r.ParseForm()
	fmt.Println(r.PostForm) // 打印form数据
	fmt.Println(r.PostForm.Get("name"), r.PostForm.Get("age"))
	// 2. 请求类型是application/json时从r.Body读取数据
	b, err := ioutil.ReadAll(r.Body)
	if err != nil {
		fmt.Printf("read request.Body failed, err:%v\n", err)
		return
	}
	fmt.Println(string(b))
	answer := `{"status": "ok"}`
	w.Write([]byte(answer))
}
```

### 19.2.5 自定义Client

**要管理 HTTP 客户端的头域、重定向策略和其他设置，创建一个 Client：**

```go
client := &http.Client{
	CheckRedirect: redirectPolicyFunc,
}
resp, err := client.Get("http://example.com")
// ...
req, err := http.NewRequest("GET", "http://example.com", nil)
// ...
req.Header.Add("If-None-Match", `W/"wyzzy"`)
resp, err := client.Do(req)
// ...
```

### 19.2.6 自定义Transport

**要管理代理、TLS配置、`keep-alive`、压缩和其他设置，创建一个 Transport：**

```go
tr := &http.Transport{
	TLSClientConfig:    &tls.Config{RootCAs: pool},
	DisableCompression: true,
}
client := &http.Client{Transport: tr}
resp, err := client.Get("https://example.com")
```

Client 和 Transport 类型都可以安全的被多个 goroutine 同时使用。出于效率考虑，应该一次建立、尽量重用。

## 19.3 服务端

### 19.3.1 默认的Server

ListenAndServe 使用指定的监听地址和处理器启动一个 HTTP 服务端。处理器参数通常是 nil，这表示采用包变量 DefaultServeMux 作为处理器。

Handle 和 HandleFunc 函数可以向 DefaultServeMux 添加处理器。

```go
http.Handle("/foo", fooHandler)
http.HandleFunc("/bar", func(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
})
log.Fatal(http.ListenAndServe(":8080", nil))
```

### 19.3.2 默认的Server示例

使用 Go 语言中的 net/http 包来编写一个简单的接收 HTTP 请求的 Server 端示例，net/http 包是对 net 包的进一步封装，专门用来处理 HTTP 协议的数据。具体的代码如下：

```go
// http server

func sayHello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello 沙河！")
}

func main() {
	http.HandleFunc("/", sayHello)
	err := http.ListenAndServe(":9090", nil)
	if err != nil {
		fmt.Printf("http server failed, err:%v\n", err)
		return
	}
}
```

将上面的代码编译之后执行，打开你电脑上的浏览器在地址栏输入`127.0.0.1:9090` 回车，此时就能够看到如下页面了。

![](pics/19-1-默认server示例结果.png)

### 19.3.3 自定义 Server

要管理服务端的行为，可以创建一个自定义的 Server：

```go
s := &http.Server{
	Addr:           ":8080",
	Handler:        myHandler,
	ReadTimeout:    10 * time.Second,
	WriteTimeout:   10 * time.Second,
	MaxHeaderBytes: 1 << 20,
}
log.Fatal(s.ListenAndServe())
```