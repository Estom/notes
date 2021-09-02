## 服务端
服务端实现约定的接口并提供服务
- 监控端口，`net.Listen()`
- 创建`grpc.server`，`grpc.NewServer()`
- 为`grpc.server`注册服务，`pb.RegisterHelloServer()`
- `grpc.server`等待接收请求，`grpc.server.Serve()`
```go
package main

import (
	"context"
	"google.golang.org/grpc"
	"log"
	pb "myapp/proto2"
	"net"
)

type HelloService struct{}

func (hs HelloService) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloResponse, error) {
	log.Println("这是来自客户端的内容", in.Content)

	resp := new(pb.HelloResponse)
	resp.Reply = "我收到了，这是我的回复，请查收"
	return resp, nil
}

var hs = HelloService{}

func main() {
	listen, err := net.Listen("tcp", ":9502")
	if err != nil {
		log.Fatalln(err)
	}
	defer listen.Close()

	s := grpc.NewServer()
	pb.RegisterHelloServer(s, hs)
	log.Println("listen on ", ":9502")
	if err := s.Serve(listen); err != nil {
		log.Fatalln(err)
	}
}
```

## 客户端
客户端按照约定调用方法请求服务
- 与服务端建立连接`net.Dial()`
- 创建`grpc.clent`，`pb.NewHelloClient()`
- 设置请求参数
- 调用服务接口，`c.SayHello()`
```go
package main

import (
	"context"
	"google.golang.org/grpc"
	"log"
	pb "myapp/proto2"
)

func main() {
	// 需要指定insecure，否则必须是安全传输
	conn, err := grpc.Dial(":9502", grpc.WithInsecure())
	if err != nil {
		log.Fatalln(err)
	}

	defer conn.Close()

	c := pb.NewHelloClient(conn)

	reqBody := new(pb.HelloRequest)
	reqBody.Content = "我是客户端，快点回复我"
	r, err := c.SayHello(context.Background(), reqBody)
	if err != nil {
		log.Fatalln(err)
	}

	log.Println("收到服务端信息: ", r.Reply)
}
```


