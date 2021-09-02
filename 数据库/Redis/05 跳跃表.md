跳跃表是一种**有序数据结构**，它通过在每个节点中维持多个指向其他节点的指针，从而达到快速访问的目的。跳跃表支持平均*O(logN)*、最坏*O(N)*的查找，还可以通过顺序性操作来批量处理节点。

Redis使用跳跃表作为有序集合键的底层实现之一，如果有序集合包含的元素数量较多，或者有序集合中元素的成员是比较长的字符串时，Redis使用跳跃表来实现有序集合键。

在集群节点中，跳跃表也被Redis用作内部数据结构。

# 5.1 跳跃表的实现

Redis的跳跃表由redis.h/zskiplistNode和redis.h/zskiplist两个结构定义，其中zskiplistNode代表跳跃表节点，zskiplist保存跳跃表节点的相关信息，比如节点数量、以及指向表头/表尾结点的指针等。

![skiplist](img/chap5/skiplist.png)

```c
typedef struct zskiplist {
  struct zskiplistNode *header, *tail;
  unsigned long length;
  int leve;
} zskiplist;
```

zskiplist结构包含：

- header：指向跳跃表的表头结点
- tail：指向跳跃表的表尾节点
- level：记录跳跃表内，层数最大的那个节点的层数（表头结点不计入）
- length：记录跳跃表的长度， 即跳跃表目前包含节点的数量（表头结点不计入）

```c
typedef struct zskiplistNode {
  struct zskiplistLevel {
    struct zskiplistNode *forward;
    unsigned int span; // 跨度
  } level[];
  
  struct zskiplistNode *backward;
  double score;
  robj *obj;
} zskiplistNode;
```

zskiplistNode包含：

- level：节点中用L1、L2、L3来标记节点的各个层，每个层都有两个属性：前进指针和跨度。前进指针用来访问表尾方向的其他节点，跨度记录了前进指针所指向节点和当前节点的距离（图中曲线上的数字）。

  level数组可以包含多个元素，每个元素都有一个指向其他节点的指针，程序可以通过这些层来加快访问其他节点。层数越多，访问速度就越快。没创建一个新节点的时候，根据幂次定律（越大的数出现的概率越小）随机生成一个介于1-32之间的值作为level数组的大小。这个大小就是层的高度。

  跨度用来计算排位（rank）：在查找某个节点的过程中，将沿途访问过的所有层的跨度累计起来，得到就是目标节点的排位。


- 后退指针：BW，指向位于当前节点的前一个节点。只能回退到前一个节点，不可跳跃。
- 分值（score）：节点中的1.0/2.0/3.0保存的分值，节点按照各自保存的分值从小到大排列。节点的分值可以相同。
- 成员对象（obj）：节点中的o1/o2/o3。它指向一个字符串对象，字符串对象保存着一个SDS值。

注：表头结点也有后退指针、分值和成员对象，只是不被用到。

遍历所有节点的路径：

1. 访问跳跃表的表头，然后从第四层的前景指正到表的第二个节点。
2. 在第二个节点时，沿着第二层的前进指针到表中的第三个节点。
3. 在第三个节点时，沿着第二层的前进指针到表中的第四个节点。
4. 但程序沿着第四个程序的前进指针移动时，遇到NULL。结束遍历。

# 5.2 跳跃表API

| 函数                              | 作用                              | 时间复杂度              |
| ------------------------------- | ------------------------------- | ------------------ |
| zslCreate                       | 创建一个跳跃表                         | O(1)               |
| zslFree                         | 释放跳跃表，以及表中的所有节点                 | O(N)               |
| zslInsert                       | 添加给定成员和分值的新节点                   | 平均O(logN)，最坏O(N)   |
| zslDelete                       | 删除节点                            | 平均O(logN)，最坏O(N)   |
| zslGetRank                      | 返回包含给定成员和分值的节点在跳跃表中的排位          | 平均O(logN)，最坏O(N)   |
| zslGetElementByRank             | 返回给定排位上的节点                      | 平均O(logN)，最坏O(N)   |
| zslIsInRange                    | 给定一个range，跳跃表中如果有节点位于该range，返回1 | O(1)，通过表头结点和表尾节点完成 |
| zslFirstInRange， zslLastInRange | 返回第一个/最后一个符合范围的节点               | 平均O(logN)，最坏O(N)   |
| zslDeleteRangeByScore           | 删除所有分值在给定范围内的节点                 | O(N)               |
| zslDeleteRangeByRank            | 删除所有排位在给定范围内的节点                 | O(N)               |

# 导航

[目录](README.md)

上一章：[4. 字典](ch4.md)

下一章：[6. 整数集合](ch6.md)

