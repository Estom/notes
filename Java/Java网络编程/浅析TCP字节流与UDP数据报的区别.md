“TCP是一种流模式的协议，UDP是一种数据报模式的协议”，这句话相信大家对这句话已经耳熟能详\~但是，“流模式”与“数据包模式”在编程的时候有什么区别呢?以下是我的理解，仅供参考!

1、TCP

打个比方比喻TCP，你家里有个蓄水池，你可以里面倒水，蓄水池上有个龙头，你可以通过龙头将水池里的水放出来，然后用各种各样的容器装(杯子、矿泉水瓶、锅碗瓢盆)接水。

上面的例子中，往水池里倒几次水和接几次水是没有必然联系的，也就是说你可以只倒一次水，然后分10次接完。另外，水池里的水接多少就会少多少;往里面倒多少水，就会增加多少水，但是不能超过水池的容量，多出的水会溢出。

结合TCP的概念，水池就好比接收缓存，倒水就相当于发送数据，接水就相当于读取数据。好比你通过TCP连接给另一端发送数据，你只调用了一次
write，发送了100个字节，但是对方可以分10次收完，每次10个字节;你也可以调用10次write，每次10个字节，但是对方可以一次就收完。
(假设数据都能到达)但是，你发送的数据量不能大于对方的接收缓存(流量控制)，如果你硬是要发送过量数据，则对方的缓存满了就会把多出的数据丢弃。

2、UDP

UDP和TCP不同，发送端调用了几次write，接收端必须用相同次数的read读完。UPD是基于报文的，在接收的时候，每次最多只能读取一个
报文，报文和报文是不会合并的，如果缓冲区小于报文长度，则多出的部分会被丢弃。也就说，如果不指定MSG_PEEK标志，每次读取操作将消耗一个报文。

3、为什么

其实，这种不同是由TCP和UDP的特性决定的。TCP是面向连接的，也就是说，在连接持续的过程中，socket中收到的数据都是由同一台主机发出的(劫持什么的不考虑)，因此，知道保证数据是有序的到达就行了，至于每次读取多少数据自己看着办。

而UDP是无连接的协议，也就是说，只要知道接收端的IP和端口，且网络是可达的，任何主机都可以向接收端发送数据。这时候，如果一次能读取超过一
个报文的数据，则会乱套。比如，主机A向发送了报文P1，主机B发送了报文P2，如果能够读取超过一个报文的数据，那么就会将P1和P2的数据合并在了一
起，这样的数据是没有意义的。

两个协议其他区别

TCP(Transmission Control Protocol)传输控制协议：

该协议主要用于在主机间建立一个虚拟连接，以实现高可靠性的数据包交换。IP协议可以进行IP数据包的分割和组装，但是通过IP协议并不能清楚地了
解到数据包是否顺利地发送给目标计算机。而使用TCP协议就不同了，在该协议传输模式中在将数据包成功发送给目标计算机后，TCP会要求发送一个确认;如
果在某个时限内没有收到确认，那么TCP将重新发送数据包。另外，在传输的过程中，如果接收到无序、丢失以及被破坏的数据包，TCP还可以负责恢复。

传输控制协议是一种面向连接的、可靠的、基于字节流的运输层通信协议，通常由IETF的RFC793说明。在简化的计算机网络OSI模型中，它完成运输层所指定的功能。

UDP (User Datagram Protocol) 用户数据报协议：

用户数据报协议(UDP)是
ISO参考模型中一种无连接的传输层协议，提供面向事务的简单不可靠信息传送服务。 UDP
协议基本上是 IP 协议与上层协议的接口。
UDP协议适用端口分辨运行在同一台设备上的多个应用程序。

由于大多数网络应用程序都在同一台机器上运行，计算机上必须能够确保目的地机器上的软件程序能从源地址机器处获得数据包，以及源计算机能收到正确的回复。这是通过使用UDP
的“端口号”完成的。

区别：

1、基于连接与无连接

TCP---传输控制协议提供的是面向连接、可靠的字节流服务。当客户和服务器彼此交换数据前，必须先在双方之间建立一个TCP连接，之后才能传输数据。TCP提供超时重发，丢弃重复数据，检验数据，流量控制等功能，保证数据能从一端传到另一端。

每个数据包的传输过程是：先建立链路、数据传输、然后清除链路。数据包不包含目的地址。受端和发端不但顺序一致，而且内容相同。它的可靠性高。

UDP---用户数据报协议是面向无连接的，每个数据包都有完整的源、目的地址及分组编号，各自在网络中独立传输，传输中不管其顺序，数据到达收端后再进行排序组装，遇有丢失、差错和失序等情况，通过请求重发来解决。它的效率比较高。

是一个简单的面向数据报的运输层协议。UDP不提供可靠性，它只是把应用程序传给IP层的数据报发送出去，但是并不能保证它们能到达目的地。由于UDP在传输数据报前不用在客户和服务器之间建立一个连接，且没有超时重发等机制，故而传输速度很快。

2、对系统资源的要求(TCP较多，UDP少)

3、UDP程序结构较简单

4、流模式与数据报模式

5、TCP保证数据正确性，UDP可能丢包，TCP保证数据顺序，UDP不保证

6、TCP是面可靠的字节流服务 ，UDP 并不提供对
IP协议的可靠机制、流量控制以及错误恢复功能等。
