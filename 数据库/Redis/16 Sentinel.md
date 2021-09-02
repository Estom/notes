Sentinel（哨兵）是Redis的高可用性解决方案，由一个或多个Sentinel实例组成的Sentinel系统可以监视任意多个master以及属下的所有slave。Sentinel在被监视的master下线后，自动将其属下的某个slave升级为新的master，然后由新的master继续处理命令请求。

# 16.1 启动并初始化Sentinel

启动一个Sentinel可以使用命令：

> redis-sentinel sentinel.conf

或者

> redis-server sentnel.conf —sentinel

当一个Sentinel启动时，会执行以下几步：

1. 初始化服务器
2. 将普通Redis服务器使用的代码替换成Sentinel专用代码
3. 初始化Sentinel状态
4. 根据配置文件，初始化监视的master列表
5. 创建与master的网络连接

## 初始化服务器

Sentinel本质上是一个运行在特殊模式下的Redis服务器，它的初始化过程与普通Redis服务器并不相同：

| 功能                                   | Sentinel使用情况                             |
| ------------------------------------ | ---------------------------------------- |
| 数据库和键值对方面的命令：`SET`, `DEL`, `FLUSHDB` | 不使用                                      |
| 事务命令                                 | 不使用                                      |
| 脚本命令                                 | 不使用                                      |
| RDB和AOF持久化                           | 不使用                                      |
| 复制命令                                 | Sentinel内部使用，客户端不可用                      |
| 发布、订阅命令                              | 订阅命令可在Sentinel内部和客户端使用，发布命令只能在Sentinel内部使用 |
| 文件事件处理器（发送命令请求，处理命令回复）               | Sentinel内部使用                             |
| 时间事件处理器                              | Sentinel内部使用，`serverCron`会用`sentinel.c/sentinelTimer`函数 |

## 使用Sentinel专用代码

将一部分普通Redis服务器的代码替换为Sentinel专用代码，比如端口号，命令表。

## 初始化Sentinel状态

接下来，服务器会初始化一个`sentinel.c/sentinelState`结构，它保存了服务器有关Sentinel的状态：

```c
struct sentinelState {
  // 当前纪元，用于实现故障转移
  uint64_t current_epoch;
  
  // 保存了所有被监视的master，键是master名字，值是指向 sentinelRedisInstance 结构的指针
  dict *masters;
  
  // 是否进入TILT模式
  int tilt;
  
  // 目前正在执行的脚本数量
  int runing_scripts;
  
  // 进入TILT模式的时间
  mstime_t tilt_start_time;
  
  // 最后一次执行时间处理器的时间
  mstime_t previous_time;
  
  // FIFO队列，包含所有需要执行的用户脚本
  list *scripts_queue;
} sentinel;
```

## 初始化Sentinel状态的masters属性

sentinelRedisInstance结构代表一个被监视的Redis服务器实例，可以是master、slave、或者另一个Sentinel。

```c
typedef struct sentinelRedisInstance {
  // 标识符，记录了实例的类型，及其当前状态
  int flags;
  
  // 实例的名字，master的名字由用户配置，slave和Sentinel的名字自动配置
  // 格式为 ip: port
  char *name;
  
  // 实例的运行ID
  char *runid;
  
  // 配置计院，用于实现故障转移
  uint64_t config_epoch;
  
  // 实例的地址
  sentinelAddr *addr;
  
  // SENTINEL down-after-milliseconds 选项设定的值
  // 实例无响应多少毫秒后才会判断为主观下线(subjectively down)
  mstime_t down_after_periods;
  
  // SENTINEL monitor <master-name> <IP> <port> <quorum> 选项的quorum参数
  // 判断这个实例是否为客观下线(objectively down)所需的支持投票数量
  int quorum;
  
  // SENTINEL parallel-sycs <master-name> <number>选项的值
  // 在执行故障转移时，可以同时对新的master进行同步的slave数量
  int parallel_syncs;
  
  // SENTINEL failover-timeout <master-name> <ms>选项的值
  // 判断故障转移状态的最大时限
  mstime_t failover_timeout;
} sentinelRedisInstance;
```

`sentinelRedisInstance.addr`指向一个`sentinel.c/sentinelAddr`结构，它保存着实例的IP地址和端口号：

```c
typedef struct sentinelAddr {
  char *ip;
  int port;
} sentinelAddr;
```

## 创建与master的网络连接

连接建立后，Sentinel将成为master的客户端，可以向其发送命令。对于被监视的master来说，Sentinel会创建两个异步网络连接：

- 命令连接，用于发送和接收命令。
- 订阅连接。用于订阅master的`__sentinel__:hello`频道。

# 16.2 获取master信息

Sentinel以默认10秒一次的频率，向master发送`INFO`命令，获取其当前信息：

- master本身的信息，包括运行ID、role等。据此，Sentinel更新master实例的结构。
- master的slave信息。据此，Sentinel更新master实例的slaves字典。

# 16.3 获取slave信息

Sentinel发现master有新的slave时，除了会为这个slave创建相应的实例结构外，还会创建到它的命令连接和订阅连接。

通过命令连接，Sentinel会向slave每10秒发送一次`INFO`命令，根据回复更新slave的实例结构：

- slave的运行ID
- slave的角色role
- master的地址和端口
- 主从的连接状态
- slave的优先级
- slave的复制偏移量

# 16.4 向master和slave发送信息

默认情况下，Sentinel会以两秒一次的频率，通过命令连接向所有被监视的master和slave发送：

> PUBLISH \_\_sentinel\_\_:hello "<s_ip>, <s_port>, <s_runid>, <s_epoch>, <m_name>, <m_ip>, <m_port>, <m_epoch>"

其中以s\_开头的参数表示Sentinel本身的信息，m\_开头的参数是master的信息。如果Sentinel正在监视的是slave，那就是slave正在复制的master信息。

# 16.5 接收来自master和slave的频道信息

当Sentinel与一个master或slave建立订阅连接后，会向服务器发送以下命令：

> SUBSCRIBE \_\_sentinel\_\_:hello

Sentinel对\_\_sentinel\_\_:hello频道的订阅会持续到两者的连接断开为止。也就是说，Sentinel既可以向服务器的\_\_sentinel\_\_:hello频道发送信息，又通过订阅连接从\_\_sentinel\_\_:hello频道接收信息。

对于监视同一个server的多个Sentinel来说，一个Sentinel发送的信息会被其他Sentinel收到。这些信息用于更新其他Sentinel队发送信息Sentinel和被监视Server的认知。

## 更新sentinels字典

Sentinel为master创建的实力结构中，有sentinels字典保存了其他监视这个master的Sentinel：

- 键是Sentinel名字，格式为ip: port。
- 值是Sentinel实例的结构。

当一个Sentinel收到其他Sentinel发来的信息时，目标Sentinel会从信息中提取出：

- 与Sentinel有关的参数：源Sentinel的IP、端口、运行ID、配置纪元。
- 与master有关的参数：master的名字、IP、端口、配置纪元。

根据提取的参数，目标Sentinel会在自己的Sentinel状态中更新sentinels和masters字典。

## 创建连向其他Sentinel的命令连接

Sentinel通过频道信息发现一个新的Sentinel时，不仅会为其创建新的实例结构，还会创建一个连向新Sentinel的命令连接，新的Sentinel也会创建连向这个Sentinel的命令连接，最终，监视同一master的多个Sentinel成为相互连接的网络。各个Sentinel可以通过发送命令请求来交换信息。

# 16.6 检测主观下线状态

默认情况下，Sentinel会每秒一次地向所有与它创建了嘛命令连接的实例（master、slave、其他sentinel）发送`PING`命令，并通过回复来判断其是否在线。只有+PONG/-LOADING/-MASERDOWN三种有效回复。

Sentinel的配置文件中`down-after-milliseconds`选项指定了判断实例主观下线所需的时间长度。在`down-after-milliseconds`毫秒内，如果连续返回无效回复，那么Sentinel会修改这个实例对应的实例结构，将`flags`属性中打开`SRI_S_DOWN`标识，标识主观下线。

注意：多个Sentinel设置的`down-after-milliseconds`可能不同。

# 16.7 检查客观下线时长

当Sentinel将一个master判断为主观下线后，为了确认是真的下线，会向监视这一master的其他Sentinel询问。有足够数量（quorum）的已下线判断后，Sentinel会将master判定为客观下线，并对master执行故障转移。

# 16.8 选举领头Sentinel

master被判定为客观下线后，监视这个master的所有Sentinel会进行协商，选举一个领头Sentinel，并由其对该master执行故障转移。选举的规则如下：

- 所有Sentinel都可以成为领头。
- 每次进行领头Sentinel选举后，不论选举是否成功，所有Sentinel的配置纪元都会+1。这个配置纪元就是一个计数器。
- 一个配置纪元里，所有Sentinel都有一次将某个Sentinel设置为局部领头Sentinel的机会，且局部领头一旦设定，在这个配置纪元内就不可修改。
- 每个发现master进入客观下线的Sentinel都会要求其他Sentinel将自己设为局部领头Sentinel。
- 当一个Sentinel向另一个Sentinel发送`SENTINEL is-master-down-by-addr`，且命令中的runid参数是自己的运行ID，这表明源Sentinel要求目标Sentinel将他设置为局部领头。
- Sentinel设置局部领头的规则是先到先得。
- 目标Sentinel收到`SENTINEL is-master-down-by-addr`后，会返回一条命令回复，恢复中的`leader_runid`和`leader_epoch`参数分别记录了目标Sentinel的局部领头Sentinel的运行ID和配置纪元。
- 源Sentinel收到目标Sentinel的回复后，检查回复中的`leader_runid`和`leader_epoch`是否和自己相同。
- 如果某个Sentinel被半数以上的Sentinel设置为局部领头，那么这个Sentinel就成为领头Sentinel。
- 因为领头Sentinel需要半数以上的支持，且每个Sentinel在每个配置纪元里只设置一次局部领头，所以一个配置纪元里，只能有一个领头。
- 如果给定时限内，没有产生领头Sentinel，那么各个Sentinel过段时间再次选举，知道选出领头为止。

# 16.8 故障转移

领头Sentinel会对已下线的master执行故障转移，包括以下三个步骤：

- 从已下线master属下的所有slave选出一个新的master。
- 让已下线master属下的所有slave改为新复制新的master。
- 让已下线master成为新master的slave，重新上线后就是新slave。

## 选出新的master

新master的挑选规则：

- 在线
- 五秒内回复过领头Sentinel的`INFO`命令
- 与已下线master在`down-after-milliseconds`毫秒内有过通信。
- salve的自身有优先级
- 复制偏移量最大

Sentinel向salve发送`SLAVEOF no one`命令将其转换为master。

## 修改salve的复制目标

同样通过`SLAVEOF`命令实现。

## 将旧的master变为slave

同样通过`SLAVEOF`命令实现。


# 导航

[目录](README.md)

上一章：[15. 复制](ch15.md)

下一章：[17.集群](ch17.md)
