
### 过程分析
* 用户进程创建socket对象，拷贝监听的fd到内核空间，每一个fd会对应一张系统文件表，内核空间的fd响应到数据后，就会发送信号给用户进程数据已到；
* 用户进程再发送系统调用，比如（accept）将内核空间的数据copy到用户空间，同时作为接受数据端内核空间的数据清除，这样重新监听时fd再有新的数据又可以响应到了（发送端因为基于TCP协议所以需要收到应答后才会清除）

### 优点
* 相比其他模型，使用select() 的事件驱动模型只用单线程（进程）执行，占用资源少，不消耗太多 CPU，同时能够为多客户端提供服务。如果试图建立一个简单的事件驱动的服务器程序，这个模型有一定的参考价值。

### 缺点
* 首先select()接口并不是实现“事件驱动”的最好选择。因为当需要探测的句柄值较大时，select()接口本身需要消耗大量时间去轮询各个句柄。
* 很多操作系统提供了更为高效的接口，如linux提供了epoll，BSD提供了kqueue，Solaris提供了/dev/poll，…。
* 如果需要实现更高效的服务器程序，类似epoll这样的接口更被推荐。遗憾的是不同的操作系统特供的epoll接口有很大差异，
* 所以使用类似于epoll的接口实现具有较好跨平台能力的服务器会比较困难。
* 其次，该模型将事件探测和事件响应夹杂在一起，一旦事件响应的执行体庞大，则对整个模型是灾难性的。

### 代码实现
```
#服务端
from socket import *
import select

s=socket(AF_INET,SOCK_STREAM)
s.setsockopt(SOL_SOCKET,SO_REUSEADDR,1)
s.bind(('127.0.0.1',8081))
s.listen(5)
s.setblocking(False) #设置socket的接口为非阻塞
read_l=[s,]
while True:
    r_l,w_l,x_l=select.select(read_l,[],[])
    print(r_l)
    for ready_obj in r_l:
        if ready_obj == s:
            conn,addr=ready_obj.accept() #此时的ready_obj等于s
            read_l.append(conn)
        else:
            try:
                data=ready_obj.recv(1024) #此时的ready_obj等于conn
                if not data:
                    ready_obj.close()
                    read_l.remove(ready_obj)
                    continue
                ready_obj.send(data.upper())
            except ConnectionResetError:
                ready_obj.close()
                read_l.remove(ready_obj)

#客户端
from socket import *
c=socket(AF_INET,SOCK_STREAM)
c.connect(('127.0.0.1',8081))

while True:
    msg=input('>>: ')
    if not msg:continue
    c.send(msg.encode('utf-8'))
    data=c.recv(1024)
    print(data.decode('utf-8'))
```