
```
#服务端
from socket import *
import time
s=socket(AF_INET,SOCK_STREAM)
s.bind(('127.0.0.1',8080))
s.listen(5)
s.setblocking(False) #设置socket的接口为非阻塞
conn_l=[]
del_l=[]
while True:
    try:
        conn,addr=s.accept()
        conn_l.append(conn)
    except BlockingIOError:
        print(conn_l)
        for conn in conn_l:
            try:
                data=conn.recv(1024)
                if not data:
                    del_l.append(conn)
                    continue
                conn.send(data.upper())
            except BlockingIOError:
                pass
            except ConnectionResetError:
                del_l.append(conn)

        for conn in del_l:
            conn_l.remove(conn)
            conn.close()
        del_l=[]

#客户端
from socket import *
c=socket(AF_INET,SOCK_STREAM)
c.connect(('127.0.0.1',8080))

while True:
    msg=input('>>: ')
    if not msg:continue
    c.send(msg.encode('utf-8'))
    data=c.recv(1024)
    print(data.decode('utf-8'))
```