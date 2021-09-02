## protobuf语法
- 指定版本`syntax = "proto3"`，需要双引号
- 指定包名`package proto`，不需要双引号
- 除了`service`,`message`,`enum`之外，其他语句都需要以`；`结束


```proto
syntax = "proto3"; // 指定proto版本

package proto;     // 指定包名,生成的*.pb.go文件的包名

// 定义Hello服务
service Hello {
    // 定义SayHello方法
    rpc SayHello(HelloRequest) returns (HelloReply) {}
}

// HelloRequest 请求结构
message HelloRequest {
    string name = 1;
	repeated subjects = 2; // 表示subjects可以出现多次或0次，go语言用数组[]string表示
}

// HelloReply 响应结构
message HelloReply {
    string message = 1;
}
```
- `repeated`表示可以出现0次或多次，go语言中用数组表示


## Map类型
```bash
map<key_type, value_type> map_field = N;
message Project {...}
map<string, Project> projects = 1;
```



## HttpRule
一个rpc可以映射到一个或多个http方法，使用`google.api.http`注释来表示该映射
```protobuf
rpc Put(PutRequest) returns (PutResponse) {
      option (google.api.http) = {
        post: "/v3/kv/put"
        body: "*"
    };
  }
```

可以使用additional_bindings选项为一个rpc定义多个http方法
```protobuf
service Messaging {
  rpc GetMessage(GetMessageRequest) returns (Message) {
    option (google.api.http) = {
      get: "/v1/messages/{message_id}"
      additional_bindings {
        get: "/v1/users/{user_id}/messages/{message_id}"
      }
    };
  }
}
message GetMessageRequest {
  string message_id = 1;
  string user_id = 2;
}
```

## 编译生成.pb.go文件：

```bash
# -I 参数：指定import路径，可以指定多个-I参数，编译时按顺序查找，不指定时默认查找当前目录
# --go_out=plugins=grpc，指定插件
protoc -I . --go_out=plugins=grpc:. ./hello.proto
```
