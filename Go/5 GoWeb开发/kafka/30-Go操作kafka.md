* [原文链接 ](https://www.liwenzhou.com/posts/Go/go_kafka/)
* [视频：150-152](https://www.bilibili.com/video/BV17Q4y1P7n9?p=150)


**Kafka 是一种高吞吐量的分布式发布订阅消息系统，它可以处理消费者规模的网站中的所有动作流数据，具有高性能、持久化、多副本备份、横向扩展等特点**。本文介绍了如何使用 Go 语言发送和接收 kafka 消息。

## 30.1 sarama

Go 语言中连接 kafka 使用第三方库: [github.com/Shopify/sarama](https://github.com/Shopify/sarama)。

下载及安装

```go
go get github.com/Shopify/sarama
```

注意事项: 

`sarama` v1.20 之后的版本加入了 `zstd` 压缩算法，需要用到 `cgo`，在 Windows 平台编译时会提示类似如下错误：

```
# github.com/DataDog/zstd
exec: "gcc":executable file not found in %PATH%
```

所以在 Windows 平台请使用 v1.19 版本的 sarama 。

## 30.2 连接 kafka 发送消息

```go
package main

import (
	"fmt"

	"github.com/Shopify/sarama"
)

// 基于sarama第三方库开发的kafka client

func main() {
	config := sarama.NewConfig()
	config.Producer.RequiredAcks = sarama.WaitForAll          // 发送完数据需要leader和follow都确认
	config.Producer.Partitioner = sarama.NewRandomPartitioner // 新选出一个partition
	config.Producer.Return.Successes = true                   // 成功交付的消息将在success channel返回

	// 构造一个消息
	msg := &sarama.ProducerMessage{}
	msg.Topic = "web_log"
	msg.Value = sarama.StringEncoder("this is a test log")
	// 连接kafka
	client, err := sarama.NewSyncProducer([]string{"192.168.1.7:9092"}, config)
	if err != nil {
		fmt.Println("producer closed, err:", err)
		return
	}
	defer client.Close()
	// 发送消息
	pid, offset, err := client.SendMessage(msg)
	if err != nil {
		fmt.Println("send msg failed, err:", err)
		return
	}
	fmt.Printf("pid:%v offset:%v\n", pid, offset)
}
```

## 30.3 连接 kafka 消费消息

```go
package main

import (
	"fmt"

	"github.com/Shopify/sarama"
)

// kafka consumer

func main() {
	consumer, err := sarama.NewConsumer([]string{"127.0.0.1:9092"}, nil)
	if err != nil {
		fmt.Printf("fail to start consumer, err:%v\n", err)
		return
	}
	partitionList, err := consumer.Partitions("web_log") // 根据topic取到所有的分区
	if err != nil {
		fmt.Printf("fail to get list of partition:err%v\n", err)
		return
	}
	fmt.Println(partitionList)
	for partition := range partitionList { // 遍历所有的分区
		// 针对每个分区创建一个对应的分区消费者
		pc, err := consumer.ConsumePartition("web_log", int32(partition), sarama.OffsetNewest)
		if err != nil {
			fmt.Printf("failed to start consumer for partition %d,err:%v\n", partition, err)
			return
		}
		defer pc.AsyncClose()
		// 异步从每个分区消费信息
		go func(sarama.PartitionConsumer) {
			for msg := range pc.Messages() {
				fmt.Printf("Partition:%d Offset:%d Key:%v Value:%v", msg.Partition, msg.Offset, msg.Key, msg.Value)
			}
		}(pc)
	}
}
```