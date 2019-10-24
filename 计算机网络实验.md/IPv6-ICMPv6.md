
# ICMPv6

## 1 ICMPv6基本概念
ICMPv6（Internet Control Message Protocol for the IPv6）是IPv6的基础协议之一。

在IPv4中，Internet控制报文协议ICMP（Internet Control Message Protocol）向源节点报告关于向目的地传输IP数据包过程中的错误和信息。它为诊断、信息和管理目的定义了一些消息，如：目的不可达、数据包超长、超时、回应请求和回应应答等。在IPv6中，ICMPv6除了提供ICMPv4常用的功能之外，还是其它一些功能的基础，如邻接点发现、无状态地址配置（包括重复地址检测）、PMTU发现等。

## 2 ICMPv6报文格式

ICMPv6的协议类型号（即IPv6报文中的Next Header字段的值）为58。ICMPv6的报文格式下图所示：

![](image/ICMPv6报文格式.png)

|字段|字段说明|
|-|-|
|Type|表明消息的类型，0至127表示差错报文类型，128至255表示消息报文类型。|
|Code|表示此消息类型细分的类型。|
|Checksum|表示ICMPv6报文的校验和。|

## 3 ICMPv6报文示例


![ICMPv6报文抓包示例](image/ICMPv6报文实例.png)


## 4 ICMPv6错误报文


ICMPv6错误报文用于报告在转发IPv6数据包过程中出现的错误。ICMPv6错误报文可以分为以下4种：

* 目的不可达错误报文

在IPv6节点转发IPv6报文过程中，当设备发现目的地址不可达时，就会向发送报文的源节点发送ICMPv6目的不可达错误报文，同时报文中会携带引起该错误报文的具体原因。

目的不可达错误报文的Type字段值为1。根据错误具体原因又可以细分为：

    * Code=0：没有到达目标设备的路由。
    * Code=1：与目标设备的通信被管理策略禁止。
    * Code=2：未指定。
    * Code=3：目的IP地址不可达。
    * Code=4：目的端口不可达。

* 数据包过大错误报文

在IPv6节点转发IPv6报文过程中，发现报文超过出接口的链路MTU时，则向发送报文的源节点发送ICMPv6数据包过大错误报文，其中携带出接口的链路MTU值。数据包过大错误报文是Path MTU发现机制的基础。

数据包过大错误报文的Type字段值为2，Code字段值为0。

* 时间超时错误报文

在IPv6报文收发过程中，当设备收到Hop Limit字段值等于0的数据包，或者当设备将Hop Limit字段值减为0时，会向发送报文的源节点发送ICMPv6超时错误报文。对于分段重组报文的操作，如果超过定时时间，也会产生一个ICMPv6超时报文。

时间超时错误报文的Type字段值为3，根据错误具体原因又可以细分为：

    * Code=0：在传输中超越了跳数限制。
    * Code=1：分片重组超时。

* 参数错误报文

当目的节点收到一个IPv6报文时，会对报文进行有效性检查，如果发现问题会向报文的源节点回应一个ICMPv6参数错误差错报文。

参数错误报文的Type字段值为4，根据错误具体原因又可以细分为：

    * Code=0：IPv6基本头或扩展头的某个字段有错误。
    * Code=1：IPv6基本头或扩展头的NextHeader值不可识别。
    * Code=2：扩展头中出现未知的选项。


## 5 ICMPv6信息报文

* 回送请求报文：回送请求报文用于发送到目标节点，以使目标节点立即发回一个回送应答报文。回送请求报文的Type字段值为128，Code字段的值为0。
* 回送应答报文：当收到一个回送请求报文时，ICMPv6会用回送应答报文响应。回送应答报文的Type字段的值为129，Code字段的值为0。

* 邻居发现ND：

    Type=133 路由器请求 RS（Router Solicitation）
    Type=134 路由器公告 RA（Router Advertisement）
    Type=135 邻居请求 NS（Neighbor Solicitation）
    Type=136 邻居通告 NA（Neighbor Advertisement）
    Type=137 重定向（Redirect）


* 多播侦听发现协议MLD：

    Type=130 多播听众查询
    Type-131 多播听众报告
    Type=132 多播听众退出
