`grpc`是高性能的rpc框架，基于`http2`协议（双向流、头部压缩、多复用请求等），默认使用`protobuf`序列化协议

## 安装
```bash
# grpc编译器
curl -fsSL https://goo.gl/getgrpc | bash -s -- --with-plugins

# Golang protobuf插件
# 编译后会安装protoc-gen-go到$GOBIN目录, 默认在 $GOPATH/bin. 该目录必须在系统的环境变量$PATH中，这样在编译.proto文件时protocol编译器才能找到插件
go get -u github.com/golang/protobuf/{proto,protoc-gen-go}

# grpc-go
go get -u google.golang.org/grpc
```


## 参考
https://segmentfault.com/a/1190000007880647