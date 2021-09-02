## 支持的授权机制
- SSL/TLS
- OAuth 2.0
- API

## 生成私钥和公钥
```bash
openssl genrsa -out server.key 2048
openssl req -new -x509 -sha256 -key server.key -out server.pem -days 3650
```

## 代码改造
### 服务端
```go
creds, _ := credentials.NewServerTLSFromFile("server.pem", "server.key")
grpc.NewServer(grpc.Creds(creds))
```
### 客户端
```go
// xx是生成公钥是时填写的Common Name
creds,_ := credentials.NewClientTLSFromFile("server.pem","xx")
grpc.Dial(":9502", grpc.WithTransportCredentials(creds))
```


## 使用自定义认证方式
### 客户端
客户端每次调用，token信息会通过请求的metadata传输到服务端
客户端是需要先实现`credentials.PerRPCCredentials`，接口需要实现`GetRequestMetadata`，`RequireTransportSecurity`两个方法，作为`grpc.Dial()`参数选项
```go
type customCredential struct{}

func (c customCredential) GetRequestMetadata(ctx context.Context, uri ...string) (map[string]string, error) {
	return map[string]string{
		"appid":  "101001",
		"appkey": "ketang",
	}, nil
}

func (c customCredential) RequireTransportSecurity() bool {
	return false
}

conn, err := grpc.Dial(":9502", grpc.WithTransportCredentials(creds), grpc.WithPerRPCCredentials(new(customCredential)))
```
### 服务端
服务端需要接收请求上下文中的`metadata`数据
```go
type HelloService struct{}

func (hs HelloService) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloResponse, error) {
	log.Println("这是来自客户端的内容", in.Content)

	// md内容为map[:authority:[xx] appid:[101001] appkey:[ketang] content-type:[application/grpc] user-agent:[grpc-go/1.25.1]]
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		log.Fatalln("缺少认证信息")
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
	log.Printf("appid:%s, appkey:%s", appid, appkey)

	resp := new(pb.HelloResponse)
	resp.Reply = "我收到了，这是我的回复，请查收"
	return resp, nil
}
```



