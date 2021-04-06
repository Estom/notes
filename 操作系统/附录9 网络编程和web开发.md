
## 1 web开发
### web框架

用来进行web开发的前端后端脚本的框架，包括大量集成的方法，通过框架接口进行调用。包括spring spring boot 等框架。

### web服务器（web容器）

web开发的网络通信模块，在Java中，以web容器Tomcat，jetty等。**使用网络编程封装了http网络通信模块**，解析http的请求并发送http的请求。Web服务器的种类有：1、Apache   2、IIS   3、Nginx   4、Tomcat    5、Lighttpd    6、Zeus等。

### web开发

主要是指利用web框架，在web容器的基础上，快速搭建web应用。

## 2 网络编程

利用操作系统提供的网络通信模块，实现通信。包括socket通信，tcp/ip  udp通信等。Java socket 模块和netty框架。


## 3 C++

### C++网络编程
对于C++ 来说，主流的网络编程框架是linux/unix和Windows提供的网络通信接口。跨平台的是boost提供的asio网络编程框架。用来实现各种形式的网络通信。

### C++web开发

对于C++来说，很少实现web服务器（web容器）。常见的有moogse,sougou两个web服务器。

对于C++ 来说，web开发框架，没有好吧。基本用C++只有前后端完全分离的web开发过程。前端mfc,qt等或者html css js 等。后端使用C++实现高性能的并行服务。