# redis笔记

<!-- TOC -->

- [redis笔记](#redis笔记)
    - [零、redis是什么](#零redis是什么)
    - [一、redis与memcached比较](#一redis与memcached比较)
    - [二、安装](#二安装)
    - [三、配置](#三配置)
    - [四、通用key操作](#四通用key操作)
    - [五、redis中的5中数据结构](#五redis中的5中数据结构)
        - [1. 字符串（string）](#1-字符串string)
        - [2. 列表（list）链表支持 有序 可重复](#2-列表list链表支持-有序-可重复)
        - [3. 集合（set）无序 不可重复](#3-集合set无序-不可重复)
        - [4. 哈希（hash）键值对  key => value](#4-哈希hash键值对--key--value)
        - [5. 有序集合（zset）键值对  成员 => 分值 成员必须唯一](#5-有序集合zset键值对--成员--分值-成员必须唯一)
    - [六、Redis详细数据类型](#六redis详细数据类型)
        - [1、string 字符串](#1string-字符串)
        - [2、list 列表](#2list-列表)
        - [3、set 集合](#3set-集合)
        - [4、sorted set 有序集合](#4sorted-set-有序集合)
        - [5、hash 哈希](#5hash-哈希)
        - [6、bitmap 位图](#6bitmap-位图)
        - [7、geo 地理位置类型](#7geo 地理位置类型)
        - [8、hyperLogLog 基数统计](#8hyperloglog-基数统计)
    - [七、redis事务](#七redis事务)
        - [1、mysql事务与redis事务比较](#1mysql事务与redis事务比较)
        - [2、悲观锁与乐观锁](#2悲观锁与乐观锁)
    - [八、发布订阅](#八发布订阅)
    - [九、持久化](#九持久化)
        - [1、redis 快照rdb](#1redis-快照rdb)
        - [2、redis 日志aof](#2redis-日志aof)
    - [十、redis主从复制](#十redis主从复制)
    - [十一、redis表设计](#十一redis表设计)
    - [十二、面试](#十二面试)
        - [1、缓存雪崩](#1缓存雪崩)
        - [2、缓存穿透](#2缓存穿透)
        - [3、缓存与数据库读写一致](#3缓存与数据库读写一致)
    - [十三、docker实现redis主从](#十三docker实现redis主从)
        - [1、命令行模式](#1命令行模式)
        - [2、docker-compose模式 推荐](#2docker-compose模式-推荐)
    - [十四、参考资料](#十四参考资料)

<!-- /TOC -->

## 零、redis是什么

redis是什么，是一种非关系型数据库，统称nosql。

## 一、redis与memcached比较

- 1、redis受益于“持久化”可以做存储(storge)，memcached只能做缓存(cache)
- 2、redis有多种数据结构，memcached只有一种类型`字符串(string)`

## 二、安装

安装最新稳定版

```sh
# 源码安装redis-4.0
# 下载
wget http://download.redis.io/releases/redis-4.0.1.tar.gz
# 解压
tar zxvf redis-4.0.1.tar.gz
cd redis-4.0.1
# 编译
make && make install
/usr/local/bin/redis-server -v
```

## 三、配置

- redis-benchmark     redis性能测试工具
- redis-check-aof     检查aof日志的工具
- redis-check-rdb     检查rdb日志的工具
- redis-cli           连接用的客户端
- redis-server        服务进程

```sh
# 地址
bind 0.0.0.0

# 保护模式
protected-mode no

# 端口
port 6380

tcp-backlog 511
timeout 0
tcp-keepalive 300

# 守护进程模式
daemonize yes

supervised no

# 进程id文件
pidfile /usr/local/redis/run/redis.pid

# 日志等级
loglevel notice

# 日志位置
logfile /usr/local/redis/logs/redis.log

# 数据个数
databases 16

always-show-logo yes

#   after 900 sec (15 min) if at least 1 key changed
#   after 300 sec (5 min) if at least 10 keys changed
#   after 60 sec if at least 10000 keys changed
save 900 1
save 300 10
save 60 10000

stop-writes-on-bgsave-error yes

# rdb开启
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
rdb-del-sync-files no
dir ./

#   主从
#   +------------------+      +---------------+
#   |      Master      | ---> |    Replica    |
#   | (receive writes) |      |  (exact copy) |
#   +------------------+      +---------------+

acllog-max-len 128
# 密码
requirepass omgzui
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no
lazyfree-lazy-user-del no
oom-score-adj no
oom-score-adj-values 0 200 800

# aof
appendonly yes
appendfilename "appendonly.aof"
# appendfsync always
appendfsync everysec
# appendfsync no
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble yes

lua-time-limit 5000

# 从服务器
# cluster-announce-ip 10.1.1.5
# cluster-announce-port 6379
# cluster-announce-bus-port 6380

slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
stream-node-max-bytes 4096
stream-node-max-entries 100
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
dynamic-hz yes
aof-rewrite-incremental-fsync yes
rdb-save-incremental-fsync yes
jemalloc-bg-thread yes


```

## 四、通用key操作

1. keys 查询

```sh
在redis里,允许模糊查询key
有3个通配符 - ? []
-: 通配任意多个字符
?: 通配单个字符
[]: 通配括号内的某1个字符

```

1. keys 查询
2. del 删除
3. rename 重命名
4. move 移到另外一个库
5. randomkey 随机
6. exists 存在
7. type 类型
8. ttl 剩余生命周期
9. expire 设置生命周期
10. persist 永久有效
11. flushdb 清空

## 五、redis中的5中数据结构

### 1. 字符串（string）

- set
  - set name shengj -> OK
- get
  - get name -> "shengj"
- del
  - del name -> (integer) 1
  - get name -> (nil)
- mset
  - mset name shengj age 23 sex male -> OK
- mget
  - mget age sex

    ```sh
    1) "23"
    2) "male"
    ```

- setrange
  - setrange sex 2 1 将sex的第3个字符改成1 -> (integer) 4
  - get sex -> "ma1e"
- append
  - append name GG -> (integer) 8
  - get name -> "shengjGG"
- getrange
  - getrange name 1 2 -> "he"
- incr 自增
- incrby 自增一个量级
- incrbyfloat 自增一个浮点数
- decr 递减
- decrby 递减一个量级
- decrbyfloat 递减一个浮点数
- setbit 设置二进制位数
- getbit 获取二进制表示
- bitop 位操作

---

### 2. 列表（list）链表支持 有序 可重复

- rpush 右边插入
  - rpush list item1 -> (integer) 1
  - rpush list item2 -> (integer) 2
  - rpush list item3 -> (integer) 3
- lrange 列出链表值
  - lrange list 0 -1

    ```sh
    1) "item1"
    2) "item2"
    3) "item3"
    ```

- lindex
  - lindex list 1 -> "item2"
- lpop
  - lpop list -> "item1"
  - lrange list 0 -1

    ```sh
    1) "item2"
    2) "item3"
    ```

- ltrim
  - ltrim list 3 0 -> OK
  - lrange list 0 -1 -> (empty list or set)
- lpush 左边插入
- rpop 右边删除
- lrem

---

### 3. 集合（set）无序 不可重复

- sadd 增加
  - sadd set item1 -> (integer) 1
  - sadd set item2 -> (integer) 1
  - sadd set item3 -> (integer) 1
  - sadd set item1 -> (integer) 0  已存在
- smembers 所有集合元素
  - smembers set
  
    ```sh
    1) "item3"
    2) "item2"
    3) "item1"
    ```

- sismember 存不存在
  - sismember set item1 -> (integer) 1
  - sismember set item -> (integer) 0 不存在
- srem 移除元素
  - srem set item1 -> (integer) 1
  - smembers set

    ```sh
    1) "item3"
    2) "item2"
    ```

- spop 随机删除一个元素
- srandmember 随机获取一个元素 -> 抽奖
- scard 多少个元素
- smove 移动
- sinter 交集
- sinterstore 交集并赋值
- suion 并集
- sdiff 差集

---

### 4. 哈希（hash）键值对  key => value

- hset 设置一个
  - hset hash key1 value1 -> (integer) 1
  - hset hash key2 value2 -> (integer) 1
  - hset hash key3 value3 -> (integer) 1
  - hset hash key1 value1 -> (integer) 0 已存在
- hgetall 获取全部
  - hgetall hash

    ```sh
    1) "key1"
    2) "value1"
    3) "key2"
    4) "value2"
    5) "key3"
    6) "value3"
    ```

- hget 获取一个
  - hget hash key1 -> "value1"
- hdel 删除
  - hdel hash key1 -> (integer) 1
  - hgetall hash

    ```sh
    1) "key2"
    2) "value2"
    3) "key3"
    4) "value3"
    ```

- hmset 设置多个
- hmget 获取多个
- hlen 个数
- hexists 是否存在增长
- hinrby 增长
- hkeys 所有的key
- hvals 所有的值

---

### 5. 有序集合（zset）键值对  成员 => 分值 成员必须唯一

- zadd 增加
  - zadd zset 100 item1 -> (integer) 1
  - zadd zset 200 item2 -> (integer) 1
  - zadd zset 300 item3 -> (integer) 1
  - zadd zset 100 item1 -> (integer) 0 已存在
- zrange 按分值排序
  - zrange zset 0 -1 withscores

    ```sh
    1) "item1"
    2) "100"
    3) "item2"
    4) "200"
    5) "item3"
    6) "300"
    ```

- zrangebyscore 按分值的一部分排序
  - zrangebyscore zset 0 200 withscores

    ```sh
    1) "item1"
    2) "100"
    3) "item2"
    4) "200"
    ```

- zrem 删除
  - zrem zset item1 -> (integer) 1
  - zrange zset 0 -1 withscores

    ```sh
    1) "item2"
    2) "200"
    3) "item3"
    4) "300"
    ```

- zrank 排名升序
- zremrangebyscore 按分值删除一部分
- zremrangebyrank 按排名删除一部分
- zcard 个数

## 六、Redis详细数据类型

首先，来看一下 Redis 的核心数据类型。Redis 有 8 种核心数据类型，分别是 ：

- string 字符串类型；
- list 列表类型；
- set 集合类型；
- sorted set 有序集合类型；
- hash 类型；
- bitmap 位图类型；
- geo 地理位置类型；
- HyperLogLog 基数统计类型。

### 1、string 字符串

  string 是 Redis 的最基本数据类型。可以把它理解为 Mc 中 key 对应的 value 类型。string 类型是二进制安全的，即 string 中可以包含任何数据。
  Redis 中的普通 string 采用 raw encoding 即原始编码方式，该编码方式会动态扩容，并通过提前预分配冗余空间，来减少内存频繁分配的开销。
  在字符串长度小于 1MB 时，按所需长度的 2 倍来分配，超过 1MB，则按照每次额外增加 1MB 的容量来预分配。
  Redis 中的数字也存为 string 类型，但编码方式跟普通 string 不同，数字采用整型编码，字符串内容直接设为整数值的二进制字节序列。
  在存储普通字符串，序列化对象，以及计数器等场景时，都可以使用 Redis 的字符串类型，字符串数据类型对应使用的指令包括 set、get、mset、incr、decr 等。

### 2、list 列表

  Redis 的 list 列表，是一个快速双向链表，存储了一系列的 string 类型的字串值。list 中的元素按照插入顺序排列。插入元素的方式，可以通过 lpush 将一个或多个元素插入到列表的头部，也可以通过 rpush 将一个或多个元素插入到队列尾部，还可以通过 lset、linsert 将元素插入到指定位置或指定元素的前后。
  list 列表的获取，可以通过 lpop、rpop 从对头或队尾弹出元素，如果队列为空，则返回 nil。还可以通过 Blpop、Brpop 从队头/队尾阻塞式弹出元素，如果 list 列表为空，没有元素可供弹出，则持续阻塞，直到有其他 client 插入新的元素。这里阻塞弹出元素，可以设置过期时间，避免无限期等待。最后，list 列表还可以通过 LrangeR 获取队列内指定范围内的所有元素。Redis 中，list 列表的偏移位置都是基于 0 的下标，即列表第一个元素的下标是 0，第二个是 1。偏移量也可以是负数，倒数第一个是 -1，倒数第二个是 -2，依次类推。
  list 列表，对于常规的 pop、push 元素，性能很高，时间复杂度为 O(1)，因为是列表直接追加或弹出。但对于通过随机插入、随机删除，以及随机范围获取，需要轮询列表确定位置，性能就比较低下了。
  feed timeline 存储时，由于 feed id 一般是递增的，可以直接存为 list，用户发表新 feed，就直接追加到队尾。另外消息队列、热门 feed 等业务场景，都可以使用 list 数据结构。
  操作 list 列表时，可以用 lpush、lpop、rpush、rpop、lrange 来进行常规的队列进出及范围获取操作，在某些特殊场景下，也可以用 lset、linsert 进行随机插入操作，用 lrem 进行指定元素删除操作；最后，在消息列表的消费时，还可以用 Blpop、Brpop 进行阻塞式获取，从而在列表暂时没有元素时，可以安静的等待新元素的插入，而不需要额外持续的查询。

### 3、set 集合

  set 是 string 类型的无序集合，set 中的元素是唯一的，即 set 中不会出现重复的元素。Redis 中的集合一般是通过 dict 哈希表实现的，所以插入、删除，以及查询元素，可以根据元素 hash 值直接定位，时间复杂度为 O(1)。
  对 set 类型数据的操作，除了常规的添加、删除、查找元素外，还可以用以下指令对 set 进行操作。
  sismember 指令判断该 key 对应的 set 数据结构中，是否存在某个元素，如果存在返回 1，否则返回 0；
  sdiff 指令来对多个 set 集合执行差集；
  sinter 指令对多个集合执行交集；
  sunion 指令对多个集合执行并集；
  spop 指令弹出一个随机元素；
  srandmember 指令返回一个或多个随机元素。
  set 集合的特点是查找、插入、删除特别高效，时间复杂度为 O(1)，所以在社交系统中，可以用于存储关注的好友列表，用来判断是否关注，还可以用来做好友推荐使用。另外，还可以利用 set 的唯一性，来对服务的来源业务、来源 IP 进行精确统计。

### 4、sorted set 有序集合

  Redis 中的 sorted set 有序集合也称为 zset，有序集合同 set 集合类似，也是 string 类型元素的集合，且所有元素不允许重复。
  但有序集合中，每个元素都会关联一个 double 类型的 score 分数值。有序集合通过这个 score 值进行由小到大的排序。有序集合中，元素不允许重复，但 score 分数值却允许重复。
  有序集合除了常规的添加、删除、查找元素外，还可以通过以下指令对 sorted set 进行操作。
  zscan 指令：按顺序获取有序集合中的元素；
  zscore 指令：获取元素的 score 值；
  zrange指令：通过指定 score 返回指定 score 范围内的元素；
  在某个元素的 score 值发生变更时，还可以通过 zincrby 指令对该元素的 score 值进行加减。
  通过 zinterstore、zunionstore 指令对多个有序集合进行取交集和并集，然后将新的有序集合存到一个新的 key 中，如果有重复元素，重复元素的 score 进行相加，然后作为新集合中该元素的 score 值。
  sorted set 有序集合的特点是：
  所有元素按 score 排序，而且不重复；
  查找、插入、删除非常高效，时间复杂度为 O(1)。
  因此，可以用有序集合来统计排行榜，实时刷新榜单，还可以用来记录学生成绩，从而轻松获取某个成绩范围内的学生名单，还可以用来对系统统计增加权重值，从而在 dashboard 实时展示。

### 5、hash 哈希

  Redis 中的哈希实际是 field 和 value 的一个映射表。
  hash 数据结构的特点是在单个 key 对应的哈希结构内部，可以记录多个键值对，即 field 和 value 对，value 可以是任何字符串。而且这些键值对查询和修改很高效。
  所以可以用 hash 来存储具有多个元素的复杂对象，然后分别修改或获取这些元素。hash 结构中的一些重要指令，包括：hmset、hmget、hexists、hgetall、hincrby 等。
  hmset 指令批量插入多个 field、value 映射；
  hmget 指令获取多个 field 对应的 value 值；
  hexists 指令判断某个 field 是否存在；
  如果 field 对应的 value 是整数，还可以用 hincrby 来对该 value 进行修改。

### 6、bitmap 位图

  Redis 中的 bitmap 位图是一串连续的二进制数字，底层实际是基于 string 进行封装存储的，按 bit 位进行指令操作的。bitmap 中每一 bit 位所在的位置就是 offset 偏移，可以用 setbit、bitfield 对 bitmap 中每个 bit 进行置 0 或置 1 操作，也可以用 bitcount 来统计 bitmap 中的被置 1 的 bit 数，还可以用 bitop 来对多个 bitmap 进行求与、或、异或等操作。
  bitmap 位图的特点是按位设置、求与、求或等操作很高效，而且存储成本非常低，用来存对象标签属性的话，一个 bit 即可存一个标签。可以用 bitmap，存用户最近 N 天的登录情况，每天用 1 bit，登录则置 1。个性推荐在社交应用中非常重要，可以对新闻、feed 设置一系列标签，如军事、娱乐、视频、图片、文字等，用 bitmap 来存储这些标签，在对应标签 bit 位上置 1。对用户，也可以采用类似方式，记录用户的多种属性，并可以很方便的根据标签来进行多维度统计。bitmap 位图的重要指令包括：setbit、 getbit、bitcount、bitfield、 bitop、bitpos 等。

### 7、geo 地理位置类型

  在移动社交时代，LBS 应用越来越多，比如微信、陌陌中附近的人，美团、大众点评中附近的美食、电影院，滴滴、优步中附近的专车等。要实现这些功能，就得使用地理位置信息进行搜索。地球的地理位置是使用二维的经纬度进行表示的，我们只要确定一个点的经纬度，就可以确认它在地球的位置。
  Redis 在 3.2 版本之后增加了对 GEO 地理位置的处理功能。Redis 的 GEO 地理位置本质上是基于 sorted set 封装实现的。在存储分类 key 下的地理位置信息时，需要对该分类 key 构建一个 sorted set 作为内部存储结构，用于存储一系列位置点。
  在存储某个位置点时，首先利用 Geohash 算法，将该位置二维的经纬度，映射编码成一维的 52 位整数值，将位置名称、经纬度编码 score 作为键值对，存储到分类 key 对应的 sorted set 中。
  需要计算某个位置点 A 附近的人时，首先以指定位置 A 为中心点，以距离作为半径，算出 GEO 哈希 8 个方位的范围， 然后依次轮询方位范围内的所有位置点，只要这些位置点到中心位置 A 的距离在要求距离范围内，就是目标位置点。轮询完所有范围内的位置点后，重新排序即得到位置点 A 附近的所有目标。
  使用 geoadd，将位置名称（如人、车辆、店名）与对应的地理位置信息添加到指定的位置分类 key 中；
  使用 geopos 方便地查询某个名称所在的位置信息；
  使用 georadius 获取指定位置附近，不超过指定距离的所有元素；
  使用 geodist 来获取指定的两个位置之间的距离。
  这样，是不是就可以实现，找到附近的餐厅，算出当前位置到对应餐厅的距离，这样的功能了？
  Redis GEO 地理位置，利用 Geohash 将大量的二维经纬度转一维的整数值，这样可以方便的对地理位置进行查询、距离测量、范围搜索。但由于地理位置点非常多，一个地理分类 key 下可能会有大量元素，在 GEO 设计时，需要提前进行规划，避免单 key 过度膨胀。
  Redis 的 GEO 地理位置数据结构，应用场景很多，比如查询某个地方的具体位置，查当前位置到目的地的距离，查附近的人、餐厅、电影院等。GEO 地理位置数据结构中，重要指令包括 geoadd、geopos、geodist、georadius、georadiusbymember 等。

### 8、hyperLogLog 基数统计

  Redis 的 hyperLogLog 是用来做基数统计的数据类型，当输入巨大数量的元素做统计时，只需要很小的内存即可完成。HyperLogLog 不保存元数据，只记录待统计元素的估算数量，这个估算数量是一个带有 0.81% 标准差的近似值，在大多数业务场景，对海量数据，不足 1% 的误差是可以接受的。
  Redis 的 HyperLogLog 在统计时，如果计数数量不大，采用稀疏矩阵存储，随着计数的增加，稀疏矩阵占用的空间也会逐渐增加，当超过阀值后，则改为稠密矩阵，稠密矩阵占用的空间是固定的，约为12KB字节。
  通过 hyperLoglog 数据类型，你可以利用 pfadd 向基数统计中增加新的元素，可以用 pfcount 获得 hyperLogLog 结构中存储的近似基数数量，还可以用 hypermerge 将多个 hyperLogLog 合并为一个 hyperLogLog 结构，从而可以方便的获取合并后的基数数量。
  hyperLogLog 的特点是统计过程不记录独立元素，占用内存非常少，非常适合统计海量数据。在大中型系统中，统计每日、每月的 UV 即独立访客数，或者统计海量用户搜索的独立词条数，都可以用 hyperLogLog 数据类型来进行处理。

## 七、redis事务

### 1、mysql事务与redis事务比较

|比较|mysql|redis|
|---|---|---|
|开启|start transaction|multi|
|语句|普通sql语句|普通redis命令|
|失败|rollback|discard|
|成功|commit|exec|

如果已经成功执行了2条语句, 第3条语句出错.

rollback后,前2条的语句影响消失.

discard只是结束本次事务,前2条语句造成的影响仍然还在

### 2、悲观锁与乐观锁

我正在买票`ticket -1 , money -100`而票只有1张, 如果在我multi之后,和exec之前, 票被别人买了,即ticket变成0了.我该如何观察这种情景,并不再提交

悲观的想法:

  世界充满危险,肯定有人和我抢, 给 ticket上锁, 只有我能操作. [悲观锁]

乐观的想法:

  没有那么人和我抢,因此,我只需要注意,
  --有没有人更改ticket的值就可以了 [乐观锁]

Redis的事务中,启用的是乐观锁,只负责监测key没有被改动

```sh

具体的命令----  watch命令

redis 127.0.0.1:6379> watch ticket
OK
redis 127.0.0.1:6379> multi
OK
redis 127.0.0.1:6379> decr ticket
QUEUED
redis 127.0.0.1:6379> decrby money 100
QUEUED
redis 127.0.0.1:6379> exec
(nil)   // 返回nil,说明监视的ticket已经改变了,事务就取消了.
redis 127.0.0.1:6379> get ticket
"0"
redis 127.0.0.1:6379> get money
"200"

watch key1 key2  ... keyN
作用:监听key1 key2..keyN有没有变化,如果有变, 则事务取消

unwatch
作用: 取消所有watch监听

```

## 八、发布订阅

订阅端: subscribe 频道名称

发布端: publish 频道名称 发布内容

## 九、持久化

### 1、redis 快照rdb

有限制，还是容易数据丢失，恢复快

```sh

save 900 1      # 900内,有1条写入,则产生快照 
save 300 1000   # 如果300秒内有1000次写入,则产生快照
save 60 10000  # 如果60秒内有10000次写入,则产生快照
(这3个选项都屏蔽,则rdb禁用)

stop-writes-on-bgsave-error yes  # 后台备份进程出错时,主进程停不停止写入?
rdbcompression yes    # 导出的rdb文件是否压缩
Rdbchecksum   yes   # 导入rbd恢复时数据时,要不要检验rdb的完整性
dbfilename dump.rdb  # 导出来的rdb文件名
dir ./  //rdb的放置路径

```

### 2、redis 日志aof

```sh

appendonly no # 是否打开 aof日志功能

appendfsync always   # 每1个命令,都立即同步到aof. 安全,速度慢
appendfsync everysec # 折衷方案,每秒写1次
appendfsync no      # 写入工作交给操作系统,由操作系统判断缓冲区大小,统一写入到aof. 同步频率低,速度快,


no-appendfsync-on-rewrite  yes: # 正在导出rdb快照的过程中,要不要停止同步aof
auto-aof-rewrite-percentage 100 #aof文件大小比起上次重写时的大小,增长率100%时,重写
auto-aof-rewrite-min-size 64mb #aof文件,至少超过64M时,重写
```

  注: 在dump rdb过程中,aof如果停止同步,会不会丢失?
  答: 不会,所有的操作缓存在内存的队列里, dump完成后,统一操作.

  注: aof重写是指什么?
  答: aof重写是指把内存中的数据,逆化成命令,写入到.aof日志里.以解决 aof日志过大的问题.

  问: 如果rdb文件,和aof文件都存在,优先用谁来恢复数据?
  答: aof

  问: 2种是否可以同时用?
  答: 可以,而且推荐这么做

  问: 恢复时rdb和aof哪个恢复的快
  答: rdb快,因为其是数据的内存映射,直 接载入到内存,而aof是命令,需要逐条执行

## 十、redis主从复制

```sh
Master配置:
1:关闭rdb快照(备份工作交给slave)
2:可以开启aof

slave配置:
1: 声明slave-of
2: 配置密码[如果master有密码]
3: [某1个]slave打开 rdb快照功能
4: 配置是否只读[slave-read-only]


```

## 十一、redis表设计

主键表

|列名|操作|备注|
|--|--|--|
|global:user_id|incr|全局user_id|
|global:post_id|incr|全局post_id|

---

mysql用户表

|列名|操作|备注||
|--|--|--|--|
|user_id|user_name|password|authsecret|
|1|shengj|123456|,./!@#|

redis用户表

|列名|操作|备注||
|--|--|--|--|
|user:user_id|user:user_id:*:user_name|user:user_id:*:password|user:user_id:*:authsecret|
|1|shengj|123456|,./!@#|

---

mysql发送表

|列名|操作|备注|||
|--|--|--|--|--|
|post_id|user_id|user_name|time|content|
|1|1|shengj|1370987654|测试内容|

redis发送表

|列名|操作|备注|||
|--|--|--|--|--|
|post:post_id|post:post_id:*:user_id|post:post_id:*:user_name|post:post_id:*:time|post:post_id:*:content|
|1|1|shengj|1370987654|测试内容|

---

关注表：following  -> set user_id

粉丝表：follower -> set user_id

推送表：receivepost -> list user_ids

拉取表：pullpost -> zset user_ids

## 十二、面试

### 1、缓存雪崩

问题：当我们的缓存失效或者redis挂了，那么这个时候的请求都会直接走数据库，就会给数据库造成极大的压力，导致数据库也挂了

解决：

1. 对缓存设置不同的过期时间，这样就不会导致缓存同时失效
2. 建立redis集群，保证服务的可靠性

### 2、缓存穿透

问题：当有大量用户不走我们设置的键值，就会直接走数据库，就会给数据库造成极大的压力，导致数据库也挂了

解决：

1. 参数过滤和提醒，引导用户走我们的设置的键值
2. 对不合法的参数进行空对象缓存，并设置较短的过期时间

### 3、缓存与数据库读写一致

问题：如果一直是读的话，是没问题的，但是更新操作会导致数据库已经更新了，缓存还是旧的数据

解决：

并发下解决数据库与缓存不一致的思路：将删除缓存、修改数据库、读取缓存等的操作积压到队列里边，实现串行化。

- 先删除缓存，再更新数据库

在高并发下表现不如意，在原子性被破坏时表现优异

- 先更新数据库，再删除缓存(Cache Aside Pattern设计模式)

在高并发下表现优异，在原子性被破坏时表现不如意

## 十三、docker实现redis主从

[docker实现redis主从](https://github.com/OMGZui/redis_m_s)

### 1、命令行模式

```bash
# 拉取redis
docker pull redis

# 主
docker run -v $(pwd)/master/redis.conf:/usr/local/etc/redis/redis.conf --name redis-master redis redis-server /usr/local/etc/redis/redis.conf

# 从1 --link redis-master:master master是别名
docker run -v $(pwd)/slave1/redis.conf:/usr/local/etc/redis/redis.conf --name redis-slave1 --link redis-master:master redis redis-server /usr/local/etc/redis/redis.conf

# 从2
docker run -v $(pwd)/slave2/redis.conf:/usr/local/etc/redis/redis.conf --name redis-slave2 --link redis-master:master redis redis-server /usr/local/etc/redis/redis.conf

```

### 2、docker-compose模式 推荐

```bash
# 拉取redis
docker pull redis

# 目录
├── docker-compose.yml
├── master
│   ├── Dockerfile
│   └── redis.conf
├── redis.conf
├── slave1
│   ├── Dockerfile
│   └── redis.conf
└── slave2
    ├── Dockerfile
    └── redis.conf

# 启动
docker-compose up -d master slave1 slave2

# 查看主容器
docker-compose exec master bash
root@cab5db8d544b:/data# redis-cli
127.0.0.1:6379> info Replication
# Replication
role:master
connected_slaves:2
slave0:ip=172.23.0.3,port=6379,state=online,offset=1043,lag=0
slave1:ip=172.23.0.4,port=6379,state=online,offset=1043,lag=0
master_replid:995257c6b5ac62f7908cc2c7bb770f2f17b60401
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:1043
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:1043
```

## 十四、参考资料

- [redis](https://redis.io/)
- [Docker：创建Redis集群](https://lw900925.github.io/docker/docker-redis-cluster.html)
