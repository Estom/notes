etcd3改用grpc后为了兼容原来的api，同时要提供http/json方式的API，为了满足这个需求，要么开发两套API，要么实现一种转换机制，他们选择了后者，而我们选择跟随他们的脚步。

```protobuf
syntax = "proto3";

package proto;

import "google/api/annotations.proto";

service Hello {
	rpc SayHello(HelloRequest) returns (HelloReply) {
		option (google.api.http) = {
			post: "/example/echo"
			body: "*"
		};
	}
}

message MyMessage {
  option (google.api.my_option) = "Hello world!";
}

message HelloRequest {
	string id = 1;
	string topic = 2;
	string body = 3;
	int32 delay = 4;
	int32 TTR = 5;
	int32 status = 6;
	int32 consume_num = 7;
	enum Foo {
		FIRST_VALUE = 0;
		SECOND_VALUE = 1;
	}
	Foo foo = 8;
}

message HelloReply {
	string msg = 1;
	int32 code = 2;
	string data = 3;
}
```

## Generate gRPC stub
```bash
protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
  --go_out=plugins=grpc:. \
  path/to/your_service.proto
```


## Generate reverse-proxy using protoc-gen-grpc-gateway
```bash
protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
  --grpc-gateway_out=logtostderr=true:. \
  path/to/your_service.proto
```
It will generate a reverse proxy path/to/your_service.pb.gw.go.


## 可选的
```bash
protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
  --swagger_out=logtostderr=true:. \
  path/to/your_service.proto
```


## 启动网关
网关服务，如果是http请求，则需要将请求发送到网关http端口
```go
package main

import (
	pb "myapp/proto"
	"net/http"

	"github.com/golang/glog"
	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

func main() {
	defer glog.Flush()

	if err := run(); err != nil {
		glog.Fatal(err)
	}
}
func run() error {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	// Register gRPC server endpoint
	// Note: Make sure the gRPC server is running properly and accessible
	mux := runtime.NewServeMux()
	opts := []grpc.DialOption{grpc.WithInsecure()}
	err := pb.RegisterHelloHandlerFromEndpoint(ctx, mux, "127.0.0.1:50052", opts)
	if err != nil {
		return err
	}

	// Start HTTP server (and proxy calls to gRPC server endpoint)
	return http.ListenAndServe(":8081", mux)
}
```

启动
```bash
go run main.go
```

http请求，注意端口是`8081`
```bash
curl -X POST "http://127.0.0.1:8081/example/echo" -d '{"id":"1","topi:"xxx"}':
```


## 命令行请求https
curl请求https时候，需要带上`-k`，`wget`需要加上`--no-check-certificate`