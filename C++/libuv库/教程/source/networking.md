# Networking

在 libuv 中，网络编程与直接使用 BSD socket 区别不大，有些地方还更简单，概念保持不变的同时，libuv 上所有接口都是非阻塞的。它还提供了很多工具函数，抽象了恼人、啰嗦的底层任务，如使用 BSD socket 结构体设置 socket 、DNS 查找以及调整各种 socket 参数。

在网络I/O中会使用到```uv_tcp_t```和```uv_udp_t```。   

##### note
>本章中的代码片段仅用于展示 libuv API ，并不是优质代码的范例，常有内存泄露和未关闭的连接。

## TCP
TCP是面向连接的，字节流协议，因此基于libuv的stream实现。  

#### server
服务器端的建立流程如下：  

1.```uv_tcp_init```建立tcp句柄。 
2.```uv_tcp_bind```绑定。 
3.```uv_listen```建立监听，当有新的连接到来时，激活调用回调函数。 
4.```uv_accept```接收链接。 
5.使用stream操作来和客户端通信。  

#### tcp-echo-server/main.c - The listen socket
```c
int main() {
    loop = uv_default_loop();

    uv_tcp_t server;
    uv_tcp_init(loop, &server);

    uv_ip4_addr("0.0.0.0", DEFAULT_PORT, &addr);

    uv_tcp_bind(&server, (const struct sockaddr*)&addr, 0);
    int r = uv_listen((uv_stream_t*) &server, DEFAULT_BACKLOG, on_new_connection);
    if (r) {
        fprintf(stderr, "Listen error %s\n", uv_strerror(r));
        return 1;
    }
    return uv_run(loop, UV_RUN_DEFAULT);
}
```

你可以调用```uv_ip4_addr()```函数来将ip地址和端口号转换为sockaddr_in结构，这样就可以被BSD的socket使用了。要想完成逆转换的话可以调用```uv_ip4_name()```。   
##### note
>对应ipv6有类似的uv_ip6_*

大多数的设置函数是同步的，因为它们毕竟不是io操作。到了```uv_listen```这句，我们再次回到回调函数的风格上来。第二个参数是待处理的连接请求队列－最大长度的请求连接队列。  

当客户端开始建立连接的时候，回调函数```on_new_connection```需要使用```uv_accept```去建立一个与客户端socket通信的句柄。同时，我们也要开始从流中读取数据。  

#### tcp-echo-server/main.c - Accepting the client
```c
void on_new_connection(uv_stream_t *server, int status) {
    if (status < 0) {
        fprintf(stderr, "New connection error %s\n", uv_strerror(status));
        // error!
        return;
    }

    uv_tcp_t *client = (uv_tcp_t*) malloc(sizeof(uv_tcp_t));
    uv_tcp_init(loop, client);
    if (uv_accept(server, (uv_stream_t*) client) == 0) {
        uv_read_start((uv_stream_t*) client, alloc_buffer, echo_read);
    }
    else {
        uv_close((uv_handle_t*) client, NULL);
    }
}
```

上述的函数集和stream的例子类似，在code文件夹中可以找到更多的例子。记得在socket不需要后，调用uv_close。如果你不需要接受连接，你甚至可以在uv_listen的回调函数中调用uv_close。

#### client
当你在服务器端完成绑定/监听/接收的操作后，在客户端只要简单地调用```uv_tcp_connect```，它的回调函数和上面类似，具体例子如下：  

```c
uv_tcp_t* socket = (uv_tcp_t*)malloc(sizeof(uv_tcp_t));
uv_tcp_init(loop, socket);

uv_connect_t* connect = (uv_connect_t*)malloc(sizeof(uv_connect_t));

struct sockaddr_in dest;
uv_ip4_addr("127.0.0.1", 80, &dest);

uv_tcp_connect(connect, socket, dest, on_connect);
```

当建立连接后，回调函数```on_connect```会被调用。回调函数会接收到一个uv_connect_t结构的数据，它的```handle```指向通信的socket。  

## UDP
用户数据报协议(User Datagram Protocol)提供无连接的，不可靠的网络通信。因此，libuv不会提供一个stream实现的形式，而是提供了一个```uv_udp_t```句柄（接收端），和一个```uv_udp_send_t```句柄（发送端），还有相关的函数。也就是说，实际的读写api与正常的流读取类似。下面的例子展示了一个从DCHP服务器获取ip的例子。  

##### note
>你必须以管理员的权限运行udp-dhcp，因为它的端口号低于1024

#### udp-dhcp/main.c - Setup and send UDP packets
```c
uv_loop_t *loop;
uv_udp_t send_socket;
uv_udp_t recv_socket;

int main() {
    loop = uv_default_loop();

    uv_udp_init(loop, &recv_socket);
    struct sockaddr_in recv_addr;
    uv_ip4_addr("0.0.0.0", 68, &recv_addr);
    uv_udp_bind(&recv_socket, (const struct sockaddr *)&recv_addr, UV_UDP_REUSEADDR);
    uv_udp_recv_start(&recv_socket, alloc_buffer, on_read);

    uv_udp_init(loop, &send_socket);
    struct sockaddr_in broadcast_addr;
    uv_ip4_addr("0.0.0.0", 0, &broadcast_addr);
    uv_udp_bind(&send_socket, (const struct sockaddr *)&broadcast_addr, 0);
    uv_udp_set_broadcast(&send_socket, 1);

    uv_udp_send_t send_req;
    uv_buf_t discover_msg = make_discover_msg();

    struct sockaddr_in send_addr;
    uv_ip4_addr("255.255.255.255", 67, &send_addr);
    uv_udp_send(&send_req, &send_socket, &discover_msg, 1, (const struct sockaddr *)&send_addr, on_send);

    return uv_run(loop, UV_RUN_DEFAULT);
}
```

##### note
>ip地址为0.0.0.0，用来绑定所有的接口。255.255.255.255是一个广播地址，这也意味着数据报将往所有的子网接口中发送。端口号为0代表着由操作系统随机分配一个端口。

首先，我们设置了一个用于接收socket绑定了全部网卡，端口号为68作为DHCP客户端，然后开始从中读取数据。它会接收所有来自DHCP服务器的返回数据。我们设置了```UV_UDP_REUSEADDR```标记，用来和其他共享端口的 DHCP客户端和平共处。接着，我们设置了一个类似的发送socket，然后使用```uv_udp_send```向DHCP服务器（在67端口）发送广播。  

设置广播发送是非常必要的，否则你会接收到`EACCES`[错误](http://beej.us/guide/bgnet/output/html/multipage/advanced.html#broadcast)。和此前一样，如果在读写中出错，返回码<0。  

因为UDP不会建立连接，因此回调函数会接收到关于发送者的额外的信息。  

当没有可读数据后，nread等于0。如果`addr`是`null`，它代表了没有可读数据（回调函数不会做任何处理）。如果不为null，则说明了从addr中接收到一个空的数据报。如果flag为```UV_UDP_PARTIAL```，则代表了内存分配的空间不够存放接收到的数据了，在这种情形下，操作系统会丢弃存不下的数据。  

#### udp-dhcp/main.c - Reading packets
```c
void on_read(uv_udp_t *req, ssize_t nread, const uv_buf_t *buf, const struct sockaddr *addr, unsigned flags) {
    if (nread < 0) {
        fprintf(stderr, "Read error %s\n", uv_err_name(nread));
        uv_close((uv_handle_t*) req, NULL);
        free(buf->base);
        return;
    }

    char sender[17] = { 0 };
    uv_ip4_name((const struct sockaddr_in*) addr, sender, 16);
    fprintf(stderr, "Recv from %s\n", sender);

    // ... DHCP specific code
    unsigned int *as_integer = (unsigned int*)buf->base;
    unsigned int ipbin = ntohl(as_integer[4]);
    unsigned char ip[4] = {0};
    int i;
    for (i = 0; i < 4; i++)
        ip[i] = (ipbin >> i*8) & 0xff;
    fprintf(stderr, "Offered IP %d.%d.%d.%d\n", ip[3], ip[2], ip[1], ip[0]);

    free(buf->base);
    uv_udp_recv_stop(req);
}
```

#### UDP Options

生存时间（Time-to-live）  
>可以通过`uv_udp_set_ttl`更改生存时间。  

只允许IPV6协议栈  
>在调用`uv_udp_bind`时，设置`UV_UDP_IPV6ONLY`标示，可以强制只使用ipv6。  

组播  
>socket也支持组播，可以这么使用：  

```c
UV_EXTERN int uv_udp_set_membership(uv_udp_t* handle,
                                    const char* multicast_addr,
                                    const char* interface_addr,
                                    uv_membership membership);
```

其中`membership`可以为`UV_JOIN_GROUP`和`UV_LEAVE_GROUP`。 
这里有一篇很好的关于组播的[文章](http://www.tldp.org/HOWTO/Multicast-HOWTO-2.html)。 
可以使用`uv_udp_set_multicast_loop`修改本地的组播。 
同样可以使用`uv_udp_set_multicast_ttl`修改组播数据报的生存时间。（设定生存时间可以防止数据报由于环路的原因，会出现无限循环的问题）。  

## Querying DNS
libuv提供了一个异步的DNS解决方案。它提供了自己的`getaddrinfo`。在回调函数中你可以像使用正常的socket操作一样。让我们来看一下例子：

#### dns/main.c
```c
int main() {
    loop = uv_default_loop();

    struct addrinfo hints;
    hints.ai_family = PF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = 0;

    uv_getaddrinfo_t resolver;
    fprintf(stderr, "irc.freenode.net is... ");
    int r = uv_getaddrinfo(loop, &resolver, on_resolved, "irc.freenode.net", "6667", &hints);

    if (r) {
        fprintf(stderr, "getaddrinfo call error %s\n", uv_err_name(r));
        return 1;
    }
    return uv_run(loop, UV_RUN_DEFAULT);
}
```

如果`uv_getaddrinfo`返回非零值，说明设置错误了，因此也不会激发回调函数。在函数返回后，所有的参数将会被回收和释放。主机地址，请求服务器地址，还有hints的结构都可以在[这里](http://nikhilm.github.io/uvbook/getaddrinfo)找到详细的说明。如果想使用同步请求，可以将回调函数设置为NULL。  

在回调函数on_resolved中，你可以从`struct addrinfo(s)`链表中获取返回的IP，最后需要调用`uv_freeaddrinfo`回收掉链表。下面的例子演示了回调函数的内容。  

#### dns/main.c
```c
void on_resolved(uv_getaddrinfo_t *resolver, int status, struct addrinfo *res) {
    if (status < 0) {
        fprintf(stderr, "getaddrinfo callback error %s\n", uv_err_name(status));
        return;
    }

    char addr[17] = {'\0'};
    uv_ip4_name((struct sockaddr_in*) res->ai_addr, addr, 16);
    fprintf(stderr, "%s\n", addr);

    uv_connect_t *connect_req = (uv_connect_t*) malloc(sizeof(uv_connect_t));
    uv_tcp_t *socket = (uv_tcp_t*) malloc(sizeof(uv_tcp_t));
    uv_tcp_init(loop, socket);

    uv_tcp_connect(connect_req, socket, (const struct sockaddr*) res->ai_addr, on_connect);

    uv_freeaddrinfo(res);
}
```

libuv同样提供了DNS逆解析的函数[uv_getnameinfo](http://docs.libuv.org/en/v1.x/dns.html#c.uv_getnameinfo])。  

## Network interfaces

可以调用`uv_interface_addresses`获得系统的网络接口信息。下面这个简单的例子打印出所有可以获取的信息。这在服务器开始准备绑定IP地址的时候很有用。  

#### interfaces/main.c

```c
#include <stdio.h>
#include <uv.h>

int main() {
    char buf[512];
    uv_interface_address_t *info;
    int count, i;

    uv_interface_addresses(&info, &count);
    i = count;

    printf("Number of interfaces: %d\n", count);
    while (i--) {
        uv_interface_address_t interface = info[i];

        printf("Name: %s\n", interface.name);
        printf("Internal? %s\n", interface.is_internal ? "Yes" : "No");
        
        if (interface.address.address4.sin_family == AF_INET) {
            uv_ip4_name(&interface.address.address4, buf, sizeof(buf));
            printf("IPv4 address: %s\n", buf);
        }
        else if (interface.address.address4.sin_family == AF_INET6) {
            uv_ip6_name(&interface.address.address6, buf, sizeof(buf));
            printf("IPv6 address: %s\n", buf);
        }

        printf("\n");
    }

    uv_free_interface_addresses(info, count);
    return 0;
}
```

`is_internal`可以用来表示是否是内部的IP。由于一个物理接口会有多个IP地址，所以每一次while循环的时候都会打印一次。  


