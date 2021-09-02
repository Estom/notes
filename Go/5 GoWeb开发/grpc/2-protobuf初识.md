 * [原文链接：《protobuf初识》——李文周（本文原作者）](https://www.liwenzhou.com/posts/Go/protobuf/)
 
其他参考：
 
* [深入 ProtoBuf - 简介](https://www.jianshu.com/p/a24c88c0526a)
* [深入 ProtoBuf - 编码](https://www.jianshu.com/p/73c9ed3a4877)
* [深入 ProtoBuf - 序列化源码解析](https://www.jianshu.com/p/62f0238beec8)
* [深入 ProtoBuf - 反射原理解析](https://www.jianshu.com/p/ddc1aaca3691)

---

## .1 protobuf 介绍

Protobuf 是 Protocol Buffer 的简称，它是 Google 公司于 2008 年开源的一种高效的平台无关、语言无关、可扩展的数据格式。目前 Protobuf 作为接口规范的描述语言，可以作为 Go 语言 RPC 接口的基础工具。

## .2 protobuf 语法

* [protobuf3语法指南](https://colobu.com/2017/03/16/Protobuf3-language-guide/)

其他参考：
 
* [深入 ProtoBuf - 简介](https://www.jianshu.com/p/a24c88c0526a)
* [深入 ProtoBuf - 编码](https://www.jianshu.com/p/73c9ed3a4877)
* [深入 ProtoBuf - 序列化源码解析](https://www.jianshu.com/p/62f0238beec8)
* [深入 ProtoBuf - 反射原理解析](https://www.jianshu.com/p/ddc1aaca3691)
* [ProtoBuf 官方文档翻译（和上面四篇文章同一作者）](https://www.jianshu.com/p/b33ca81b19b5)


## .3 protobuf 使用

protobuf 是一个与语言无关的一个数据协议，所以我们需要先编写 IDL 文件然后借助专用工具生成指定语言的代码，从而实现数据的序列化与反序列化过程。

大致开发流程如下： 

* 安装对应编译器
* IDL编写 
* 生成指定语言的代码 
* 序列化和反序列化



### .3.1 编译器安装

#### .3.1.1 ptotoc

protobuf 协议编译器是用 c++ 编写的，根据自己的操作系统下载对应版本的 protoc 编译器：[https://github.com/protocolbuffers/protobuf/releases](https://github.com/protocolbuffers/protobuf/releases)，解压后拷贝到 `GOPATH/bin`目录下。

#### .3.1.2 `protoc-gen-go`

安装生成 Go 语言代码的工具

```
go get -u github.com/golang/protobuf/protoc-gen-go
```

### .3.2 编写 IDL 代码

在 `protobuf_demo/address` 目录下新建一个名为 `person.proto` 的文件具体内容如下：

```java
// 指定使用protobuf版本
// 此处使用v3版本
syntax = "proto3";

// 包名，通过protoc生成go文件
package address;

// 性别类型
// 枚举类型第一个字段必须为0
enum GenderType {
    SECRET = 0;
    FEMALE = 1;
    MALE = 2;
}

// 人
message Person {
    int64 id = 1;
    string name = 2;
    GenderType gender = 3;
    string number = 4;
}

// 联系簿
message ContactBook {
    repeated Person persons = 1;
}
```

### .3.3 生成 go 语言代码

在 `protobuf_demo/address` 目录下执行以下命令。

```
address $ protoc --go_out=. ./person.proto 
```

此时在当前目录下会生成一个 `person.pb.go` 文件，我们的 Go 语言代码里就是使用这个文件。 

### .3.4 调用（序列化/反序列化）

在 `protobuf_demo/main.go` 文件中：

```go
package main

import (
	"fmt"
	"io/ioutil"

	"github.com/golang/protobuf/proto"

	"github.com/Q1mi/studygo/code_demo/protobuf_demo/address"
)

// protobuf demo

func main() {
	var cb address.ContactBook

	p1 := address.Person{
		Name:   "小王子",
		Gender: address.GenderType_MALE,
		Number: "7878778",
	}
	fmt.Println(p1)
	cb.Persons = append(cb.Persons, &p1)
	// 序列化
	data, err := proto.Marshal(&p1)
	if err != nil {
		fmt.Printf("marshal failed,err:%v\n", err)
		return
	}
	ioutil.WriteFile("./proto.dat", data, 0644)

	data2, err := ioutil.ReadFile("./proto.dat")
	if err != nil {
		fmt.Printf("read file failed, err:%v\n", err)
		return
	}
	var p2 address.Person
	proto.Unmarshal(data2, &p2)
	fmt.Println(p2)
}
```