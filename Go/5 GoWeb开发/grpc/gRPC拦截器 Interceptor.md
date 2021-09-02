grpc的拦截器可以在处理请求之前，对请求数据先做一些处理

在前面里例子中，使用token的认证方式是在具体的服务接口中实现，想象一下，如果你有100个接口，难道每个接口都要加上这个认证的代码吗，这是不可能的，使用拦截的方式的，在调用具体的接口之前，统一处理

拦截器是定义在服务端，参数选项是`grpc.UnaryInterceptor(intercetor)`，如下：
```go
package main

import (
	"context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
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

	creds, err := credentials.NewServerTLSFromFile("/data/wwwroot/go/src/myapp/keys2/server.pem", "/data/wwwroot/go/src/myapp/keys2/server.key")
	if err != nil {
		log.Fatalln(err)
	}

	// 定义拦截器
	var intercetor grpc.UnaryServerInterceptor
	intercetor = func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error) {
		err = auth(ctx)
		if err != nil {
			return
		}
		// 继续处理请求
		return handler(ctx, req)
	}

	s := grpc.NewServer(grpc.Creds(creds), grpc.UnaryInterceptor(intercetor))
	pb.RegisterHelloServer(s, hs)
	log.Println("listen on ", ":9502")
	if err := s.Serve(listen); err != nil {
		log.Fatalln(err)
	}
}

func auth(ctx context.Context) error {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return status.Errorf(codes.Unauthenticated, "缺少认证信息")
	}

	var (
		appid  string
		appkey string
	)
	if v, ok := md["appid"]; ok {
		appid = v[0]
	}
	if v, ok := md["appkey"]; ok {
		appkey = v[0]
	}

	if appid != "101001" || appkey != "ketang" {
		return status.Errorf(codes.Unauthenticated, "Token认证信息无效: appid=%s, appkey=%s", appid, appkey)
	}

	return nil
}
```