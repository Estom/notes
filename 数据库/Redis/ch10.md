RDB持久化可将内存中的数据库状态保存到磁盘上，避免数据丢失。持久化可以手动，也可以根据服务器配置选项定期执行。

RDB持久化生成的RDB文件是一个压缩过的二进制文件，通过该文件可以还原生成RDB文件时的数据库状态。

# 10.1 RDB文件的创建于载入

有两个命令可以生成RDB文件：

1. SAVE。该命令会阻塞Redis服务器进程，直到RDB文件创建完毕，期间拒绝任何命令请求。
2. BGSAVE。派生出一个子进程来创建RDB文件，服务器进程（父进程）继续处理命令请求。

> 在BGSAVE命令执行期间，服务器处理SAVE、GBSAVE、BGREWRITEAOF命令会被拒绝执行。

创建RDB文件的操作由`rdb.c/rdbSave`函数完成。

RDB文件的载入工作在服务器启动时自动执行。

另外，AOF文件的更新频率比RDB文件要高，所以：

- 如果服务器开启了AOF，那么优先用AOF来还原数据库。
- 只有在AOF关闭时，服务器才会用RDB来还原数据库。

载入RDB文件的工作由`rdb.c/rdbLoad`函数完成。载入RDB文件期间，服务器一直处于阻塞状态。

# 10.2 自动间隔性保存

Redis允许用户通过设置服务器配置的save选项，每隔一段时间执行一次BGSAVE命令。配置如下：

> save 900 1
>
> save 300 10
>
> save 60 10000

那么上述三个条件只要满足任意一个，BGSAVE命令就会被执行：

1. 服务器在900秒内，对服务器进行了至少1次修改。
2. 服务器在300秒内，对服务器进行了至少10次修改。
3. 服务器在60秒内，对服务器进行了至少10000次修改。

当Redis服务器启动时，用户可以指定配置文件或者传入启动参数的方式设置save选项。如果没有主动设置，服务器默认使用上述三个条件。接着，服务器会根据save的条件，设置`redisServer`结构的`saveParams`属性。

```objective-c
struct redisServer {
  // ...
  struct saveparam *saveparams; // 保存条件的数组
  long long dirty;
  time_t lastsave;
  //...
}

struct saveparam {
  time_t seconds; // 秒数
  int changes; // 修改数
}
```

除此之外，服务器还维持着一个dirty计数器，以及一个lastsave属性。

- dirty记录上一次成功`SAVE`或`BGSAVE`之后，服务器对数据库状态进行了多少次修改。
- lastsave是一个UNIX时间戳，记录了服务器上一次成功`SAVE`或`BGSAVE`的时间。

## 检查保存条件是否满足

服务器的周期性操作函数`serverCron`默认每个100毫秒就会执行一次，其中一项工作是检查save选项所设置的保存条件是否满足。

# 10.3 RDB文件结构

RDB文件的各个部分包括：

> REDIS | db_version | databases | EOF | check_sum

## REDIS

开头是REDIS部分，长度为5。保存了五个字符，以便载入时确认是否为RDB文件。

## db_version

db\_version长4字节，是一个字符串表示的整数，记录了RDB文件的版本号。

## databases

databases部分包含了0个或多个数据库，以及各个数据库中的键值对数据。一个保存了0号和3号数据库的RDB文件如下：

> REDIS | db_version | database 0 | databse 3 | EOF | check_sum

每个非空数据库在RDB文件中都可保存为以下三部分：

> SELECTDB | db_number | key_value_pairs

- SELECTEDB。1字节。但程序遇到这个值的时候，它就知道接下来要读入的将是一个数据库号码。
- db\_number。读取号码之后，服务器会调用`SELECT`命令切换数据库。
- key_value_pairs。不带过期时间的键值对在RDB文件中包括TYPE、key、value。TYPE的值决定了如何读入和解释value的数据。带过期时间的键值对增加了EXPIRETIME_MS和ms。前者告知程序接下来要读入一个UNIX时间戳。

## EOF

长度为1字节，标识RDB文件结束。

## check_sum

8字节的无符号整数，保存着一个前面四个部分的校验和。

# 10.4 分析RDB文件

od命令分析RDB文件。-c参数可以以ASCII编码打印文件。比如一个数据库状态为空的RDB文件：

![](img/chap10/img0.png)

Redis自带的文件检查工具是redis-check-dump。

# 导航

[目录](README.md)

上一章：[9. 数据库](ch9.md)

下一章：[11. AOF持久化](ch11.md)

