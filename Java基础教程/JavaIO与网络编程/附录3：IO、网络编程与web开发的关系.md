最近接触到的通信框架有点多，需要从头多学习一点


### IO方式
以下是IO方式。包括网络IO、文件IO等各种IO场景，不只是网络通信。说的是内存数据加载的方式，专注于一端。对应java中的java.io和java.nio两个包。

1. Java BIO 阻塞IO
2. Java NIO-Netty 非阻塞IO
3. Java AIO 异步IO

### 网络编程
以下是网络通信框架。提供了客户端和服务端必须一一对应。无应用层协议，是传输层的封装。包括两端，每一端都通过IO模型加载和写入数据。

1. socket 是传统的端到端通信模型，最基本的网络通信框架。对端也必须是socket协议的服务端。其底层基于不同的JavaIO方式。
2. sofabolt 是alibaba的网络通信框架。对端也必须是sofabolt协议的服务端。
3. Netty 是开源的网络通信框架。

### web开发
以下三个是Http服务实现。技能够提供http协议的服务端，也能实现http协议的客户端。是有协议的。
1. Servlet 最基本的http服务实现方法。采用多线程阻塞的方式。包括服务端和HttpClient，可以独立使用
2. Java ws.rs - Resteasy  基于标准接口的http服务的实现方法。包括服务端和ResteasyClient，可以独立使用
3. Spring MVC 基于Servlet的http服务的封装和实现方法。包括服务端和RestTemplate，可以独立使用
4. Spring Flux 基于Netty的http服务的封装和实现方法。包括服务端和WebClient，可以独立使用