# 简单图解OSI七层网络模型

![osi_gif](https://images-1252557999.file.myqcloud.com/uPic/osi_gif.gif)

> 翻译自[Bradley Mitchell](https://www.lifewire.com/bradley-mitchell-816228)的《[The Layers of the OSI Model Illustrated](https://www.lifewire.com/layers-of-the-osi-model-illustrated-818017)》

Open Systems Interconnection(OSI)定义了一个网络框架，其以层为单位实现了各种协议，同时会将控制权逐层传递。目前`OSI`主要作为教学工具被使用，其在概念上将计算机网络结构按逻辑顺序划分为7层。

较低层处理电信号、二进制数据块以及路由这些数据以便在网络中的穿梭；从用户的角度来看，更高的层次包括网络请求和响应、数据的表示和网络协议。

`OSI`模型最初被认为是构建网络系统的标准体系结构，今天许多流行的网络技术都可以看出`OSI`的分层设计。

## 物理层（Physical Layer）

物理层是`OSI`模型的第一层，其职责在于通过网络通信媒介将比特流数据从发送（源）设备的物理层传输到接收（终）设备的物理层。

![nTvz4K](https://images-1252557999.file.myqcloud.com/uPic/nTvz4K.jpg)

第一层技术的例子包括以太网电缆和集线器。此外，集线器和其他中继器是在物理层起作用的标准网络设备，电缆连接器也是如此。

在物理层，数据通过物理介质支持的以下信号类型进行传输: 

- 电压
- 无线电频率
- 红外脉冲
- 普通光

## 数据链路层（Data Link Layer）

当从物理层获取数据时，数据链路层会检查物理传输错误，并将比特数据打包成数据帧。数据链路层还管理着物理寻址方案，例如以太网的`MAC`地址，用于控制网络设备对物理介质的访问。

![fL4FRo](https://images-1252557999.file.myqcloud.com/uPic/fL4FRo.jpg)

因为数据链路层是 OSI 模型中最复杂的一层，所以它通常被分成两部分: 媒体访问控制子层和逻辑链路控制子层。

## 网络层（Network Layer）

网络层在数据链路层之上增加了路由的概念。每当数据抵达网络层时，就会检查每个帧中包含的源地址和目标地址，以确定数据是否已到达其最终目的地。如果数据已经到达最终目的地，第3层就会将数据格式化并打包为数据包交付给运输层，否则网络层会更新目的地址并将帧推送到下层。

![fRiImm](https://images-1252557999.file.myqcloud.com/uPic/fRiImm.jpg)

为了支持路由，网络层需要一个维护逻辑地址，比如网络设备的`IP`地址。网络层还管理着这些逻辑地址和物理地址之间的映射，在`IPv4`网络中，这种映射通过地址解析协议(`ARP`)完成，`IPv6`使用邻居发现协议(`NDP`)。

## 运输层（Transport Layer）

传输层通过网络连接传输数据。`TCP` (传输控制协议)和 `UDP (用户数据报协议)是传输层比较常见且有代表性的协议。不同的传输协议可能支持一系列可选功能，包括错误恢复、流控制和支持重新传输。

![0eKMWM](https://images-1252557999.file.myqcloud.com/uPic/0eKMWM.jpg)

## 会话层（Session Layer）

会话层位于第五层，其管理着网络连接事件顺序和流程的启动和关闭。它支持多种类型的连接，这些连接可以动态地创建并在单个网络上运行。

![kAKms4](https://images-1252557999.file.myqcloud.com/uPic/kAKms4.jpg)

## 表示层（Presentation Layer）

表示层位于第六层，就功能相对来说是OSI模型各层中最简单的。其着力于消息数据的语法处理，如格式转换和支持其上一层（应用层）所需的加密/解密。

![6aIs7n](https://images-1252557999.file.myqcloud.com/uPic/6aIs7n.jpg)

## 应用层（Application Layer）

应用层为终端用户使用的应用提供**网络服务**（处理用户数据的协议）。举个例子，在Web浏览器应用程序中，应用层协议HTTP打包发送和接收网页内容所需的数据。同时应用层也会向表示层提供或获取数据。

![N0qYsG](https://images-1252557999.file.myqcloud.com/uPic/N0qYsG.jpg)

## 说明

本文主体内容来翻译自[Bradley Mitchell](https://www.lifewire.com/bradley-mitchell-816228)的《[The Layers of the OSI Model Illustrated](https://www.lifewire.com/layers-of-the-osi-model-illustrated-818017)》，衍生开的话还有以下不错的书籍资料：

- [计算机网络-第7版-谢希仁](https://book.douban.com/subject/26960678/)
- [趣谈网络协议](https://time.geekbang.org/column/intro/100007101?code=B0w8OmhZXXkMkJ5PSXpY9KNeN4%2FvjOXNDvtHpaRlbK8%3D)
- [图解TCP/IP](https://book.douban.com/subject/24737674/)

大家有兴趣的可以看一看。