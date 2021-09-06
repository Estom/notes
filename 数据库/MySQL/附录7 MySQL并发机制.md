
## 1 并发机制

1. 什么是并发，并发与多线程有什么关系？

1. 先从广义上来说，或者从实际场景上来说.
   1. 高并发通常是海量用户同时访问(比如：12306买票、淘宝的双十一抢购)，如果把一个用户看做一个线程的话那么并发可以理解成多线程同时访问，高并发即海量线程同时访问。（ps：我们在这里模拟高并发可以for循环多个线程即可）

2. 从代码或数据的层次上来说。多个线程同时在一条相同的数据上执行多个数据库操作。

## 2 并发分类
> 参考文献
> * [锁与并发](https://www.cnblogs.com/yaopengfei/p/8399358.html)
### 积极并发
积极并发(乐观并发、乐观锁)：无论何时从数据库请求数据，数据都会被读取并保存到应用内存中。数据库级别没有放置任何显式锁。数据操作会按照数据层接收到的先后顺序来执行。

积极并发本质就是允许冲突发生，然后在代码本身采取一种合理的方式去解决这个并发冲突，常见的方式有：

1. 忽略冲突强制更新：数据库会保存最后一次更新操作(以更新为例)，会损失很多用户的更新操作。
2. 部分更新：允许所有的更改，但是不允许更新完整的行，只有特定用户拥有的列更新了。这就意味着，如果两个用户更新相同的记录但却不同的列，那么这两个更新都会成功，而且来自这两个用户的更改都是可见的。（EF默认实现不了这种情况）
3. 询问用户：当一个用户尝试更新一个记录时，但是该记录自从他读取之后已经被别人修改了，这时应用程序就会警告该用户该数据已经被某人更改了，然后询问他是否仍然要重写该数据还是首先检查已经更新的数据。(EF可以实现这种情况，在后面详细介绍)
4. 拒绝修改：当一个用户尝试更新一个记录时，但是该记录自从他读取之后已经被别人修改了，此时告诉该用户不允许更新该数据，因为数据已经被某人更新了。


### 消极并发

消极并发(悲观并发、悲观锁)：无论何时从数据库请求数据，数据都会被读取，然后该数据上就会加锁，因此没有人能访问该数据。这会降低并发出现问题的机会，缺点是加锁是一个昂贵的操作，会降低整个应用程序的性能。

消极并发的本质就是永远不让冲突发生，通常的处理凡是是只读锁和更新锁。

1. 当把只读锁放到记录上时，应用程序只能读取该记录。如果应用程序要更新该记录，它必须获取到该记录上的更新锁。如果记录上加了只读锁，那么该记录仍然能够被想要只读锁的请求使用。然而，如果需要更新锁，该请求必须等到所有的只读锁释放。同样，如果记录上加了更新锁，那么其他的请求不能再在这个记录上加锁，该请求必须等到已存在的更新锁释放才能加锁。总结，这里我们可以简单理解把并发业务部分用一个锁（如：lock,实质是数据库锁，后面章节单独介绍）锁住，使其同时只允许一个线程访问即可。

2. 加锁会带来很多弊端：
   1. 应用程序必须管理每个操作正在获取的所有锁；
   2. 加锁机制的内存需求会降低应用性能
   3. 多个请求互相等待需要的锁，会增加死锁的可能性。


## 3 并发问题的解决方案（提高并发的方法）

并发机制的解决方案

1. 从架构的角度去解决（大层次 如：12306买票）

　　nginx负载均衡、数据库读写分离、多个业务服务器、多个数据库服务器、NoSQL， 使用队列来处理业务，将高并发的业务依次放到队列中，然后按照先进先出的原则， 逐个处理（队列的处理可以采用 Redis、RabbitMq等等）

　　(PS：在后面的框架篇章里详细介绍该方案)

2. 从代码的角度去解决(在服务器能承载压力的情况下，并发访问同一条数据)

　　实际的业务场景：如进销存类的项目，涉及到同一个物品的出库、入库、库存，我们都知道库存在数据库里对应了一条记录，入库要查出现在库存的数量，然后加上入库的数量，假设两个线程同时入库，假设查询出来的库存数量相同，但是更新库存数量在数据库层次上是有先后，最终就保留了后更新的数据，显然是不正确的，应该保留的是两次入库的数量和。

（该案例的实质：多个线程同时在一条相同的数据上执行多个数据库操作）

事先准备一张数据库表:



解决方案一：(最常用的方式)

　　给入库和出库操作加一个锁，使其同时只允许一个线程访问，这样即使两个线程同时访问，但在代码层次上，由于锁的原因，还是有先有后的，这样就保证了入库操作的线程唯一性，当然库存量就不会出错了.

总结：该方案可以说是适合处理小范围的并发且锁内的业务执行不是很复杂。假设一万线程同时入库，每次入库要等2s，那么这一万个线程执行完成需要的总时间非常多，显然不适合。

    (这种方式的实质就是给核心业务加了个lock锁，这里就不做测试了)

 

解决方案二：EF处理积极并发带来的冲突

1. 配置准备

　　(1). 针对DBFirst模式，可以给相应的表额外加一列RowVersion，数据库中为timestamp类型，对应的类中为byte[]类型，并且在Edmx模型上给该字段的并发模式设置为fixed(默认为None)，这样该表中所有字段都监控并发。

如果不想监视所有列（在不添加RowVersion的情况下），只需在Edmx模型是给特定的字段的并发模式设置为fixed，这样只有被设置的字段被监测并发。

　　测试结果： (DBFirst模式下的并发测试)

　　事先在UserInfor1表中插入一条id、userName、userSex、userAge均为1的数据(清空数据)。

测试情况1：

　　在不设置RowVersion并发模式为Fixed的情况下，两个线程修改不同字段(修改同一个字段一个道理)，后执行的线程的结果覆盖前面的线程结果.

　　发现测试结果为：1,1,男,1 ; 显然db1线程修改的结果被db2线程给覆盖了. (修改同一个字段一个道理)


```
 1             {
 2                 //1.创建两个EF上下文，模拟代表两个线程
 3                 var db1 = new ConcurrentTestDBEntities();
 4                 var db2 = new ConcurrentTestDBEntities();
 5 
 6                 UserInfor1 user1 = db1.UserInfor1.Find("1");
 7                 UserInfor1 user2 = db2.UserInfor1.Find("1");
 8 
 9                 //2. 执行修改操作
10                 //（db1的线程先执行完修改操作，并保存）
11                 user1.userName = "ypf";
12                 db1.Entry(user1).State = EntityState.Modified;
13                 db1.SaveChanges();
14 
15                 //（db2的线程在db1线程修改完成后，执行修改操作）
16                 try
17                 {
18                     user2.userSex = "男";
19                     db2.Entry(user2).State = EntityState.Modified;
20                     db2.SaveChanges();
21 
22                     Console.WriteLine("测试成功");
23                 }
24                 catch (Exception)
25                 {
26                     Console.WriteLine("测试失败");
27                 }
28             }
```
测试情况2：

　　设置RowVersion并发模式为Fixed的情况下，两个线程修改不同字段(修改同一个字段一个道理)，如果该条数据已经被修改，利用DbUpdateConcurrencyException可以捕获异常，进行积极并发的冲突处理。测试结果如下：

　　a.RefreshMode.ClientWins: 1,1,男,1

　　b.RefreshMode.StoreWins: 1,ypf,1,1

　　c.ex.Entries.Single().Reload(); 1,ypf,1,1

```
 1             {
 2                 //1.创建两个EF上下文，模拟代表两个线程
 3                 var db1 = new ConcurrentTestDBEntities();
 4                 var db2 = new ConcurrentTestDBEntities();
 5 
 6                 UserInfor1 user1 = db1.UserInfor1.Find("1");
 7                 UserInfor1 user2 = db2.UserInfor1.Find("1");
 8 
 9                 //2. 执行修改操作
10                 //（db1的线程先执行完修改操作，并保存）
11                 user1.userName = "ypf";
12                 db1.Entry(user1).State = EntityState.Modified;
13                 db1.SaveChanges();
14 
15                 //（db2的线程在db1线程修改完成后，执行修改操作）
16                 try
17                 {
18                     user2.userSex = "男";
19                     db2.Entry(user2).State = EntityState.Modified;
20                     db2.SaveChanges();
21 
22                     Console.WriteLine("测试成功");
23                 }
24                 catch (DbUpdateConcurrencyException ex)
25                 {
26                     Console.WriteLine("测试失败:" + ex.Message);
27 
28                     //1. 保留上下文中的现有数据(即最新，最后一次输入)
29                     //var oc = ((IObjectContextAdapter)db2).ObjectContext;
30                     //oc.Refresh(RefreshMode.ClientWins, user2);
31                     //oc.SaveChanges();
32 
33                     //2. 保留原始数据(即数据源中的数据代替当前上下文中的数据)
34                     //var oc = ((IObjectContextAdapter)db2).ObjectContext;
35                     //oc.Refresh(RefreshMode.StoreWins, user2);
36                     //oc.SaveChanges();
37 
38                     //3. 保留原始数据（而Reload处理也就是StoreWins，意味着放弃当前内存中的实体，重新到数据库中加载当前实体）
39                     ex.Entries.Single().Reload();
40                     db2.SaveChanges();
41                 }
42             }
```

测试情况3：

　　在不设置RowVersion并发模式为Fixed的情况下(也不需要RowVersion这个字段)，单独设置userName字段的并发模式为Fixed，两个线程同时修改该字段，利用DbUpdateConcurrencyException可以捕获异常，进行积极并发的冲突处理,但如果是两个线程同时修改userName以外的字段，将不能捕获异常，将走EF默认的处理方式，后执行的覆盖先执行的。

　　a.RefreshMode.ClientWins: 1,ypf2,1,1

　　b.RefreshMode.StoreWins: 1,ypf,1,1

　　c.ex.Entries.Single().Reload(); 1,ypf,1,1

 View Code
　　(2). 针对CodeFirst模式，需要有这样的一个属性 public byte[] RowVersion { get; set; }，并且给属性加上特性[Timestamp],这样该表中所有字段都监控并发。如果不想监视所有列（在不添加RowVersion的情况下），只需给特定的字段加上特性 [ConcurrencyCheck]，这样只有被设置的字段被监测并发。

　　除了再配置上不同于DBFirst模式以为，是通过加特性的方式来标记并发，其它捕获并发和积极并发的几类处理方式均同DBFirst模式相同。（这里不做测试了）

1. 积极并发处理的三种形式总结：

　　利用DbUpdateConcurrencyException可以捕获异常，然后：

　　　　a. RefreshMode.ClientWins:保留上下文中的现有数据(即最新，最后一次输入)

　　　　b. RefreshMode.StoreWins:保留原始数据(即数据源中的数据代替当前上下文中的数据)

　　　　c.ex.Entries.Single().Reload(); 保留原始数据（而Reload处理也就是StoreWins，意味着放弃当前内存中的实体，重新到数据库中加载当前实体）

3. 该方案总结：

　　这种模式实质上就是获取异常告诉程序，让开发人员结合需求自己选择怎么处理，但这种模式是解决代码层次上的并发冲突，并不是解决大数量同时访问崩溃问题的。

解决方案三：利用队列来解决业务上的并发(架构层次上其实也是这种思路解决的)

1.先分析：

　　前面说过所谓的高并发，就是海量的用户同时向服务器发送请求，进行某个业务处理(比如定时秒杀的抢单)，而这个业务处理是需要 一定时间的。

2.处理思路：

　　将海量用户的请求放到一个队列里(如：Queue)，先不进行业务处理，然后另外一个服务器从线程中读取这个请求(MVC框架可以放到Global全局里)，依次进行业务处理，至于处理完成后，是否需要告诉客户端，可以根据实际需求来定，如果需要的话(可以借助Socket、Signalr、推送等技术来进行).

　　特别注意：读取队列的线程是一直在运行，只要队列中有数据，就给他拿出来.

　　这里使用Queue队列，可以参考：http://www.cnblogs.com/yaopengfei/p/8322016.html

　　（PS：架构层次上的处理方案无非队列是单独一台服务器，执行从队列读取的是另外一台业务服务器，处理思想是相同的）

队列单例类的代码：


```
 1  /// <summary>
 2     /// 单例类
 3     /// </summary>
 4     public class QueueUtils
 5     {
 6         /// <summary>
 7         /// 静态变量：由CLR保证，在程序第一次使用该类之前被调用，而且只调用一次
 8         /// </summary>
 9         private static readonly QueueUtils _QueueUtils = new QueueUtils();
10 
11         /// <summary>
12         /// 声明为private类型的构造函数，禁止外部实例化
13         /// </summary>
14         private QueueUtils()
15         {
16 
17         }
18         /// <summary>
19         /// 声明属性，供外部调用，此处也可以声明成方法
20         /// </summary>
21         public static QueueUtils instanse
22         {
23             get
24             {
25                 return _QueueUtils;
26             }
27         }
28 
29 
30         //下面是队列相关的
31          System.Collections.Queue queue = new System.Collections.Queue();
32 
33         private static object o = new object();
34 
35         public int getCount()
36         {
37             return queue.Count;
38         }
39 
40         /// <summary>
41         /// 入队方法
42         /// </summary>
43         /// <param name="myObject"></param>
44         public void Enqueue(object myObject)
45         {
46             lock (o)
47             {
48                 queue.Enqueue(myObject);
49             }
50         }
51         /// <summary>
52         /// 出队操作
53         /// </summary>
54         /// <returns></returns>
55         public object Dequeue()
56         {
57             lock (o)
58             {
59                 if (queue.Count > 0)
60                 {
61                     return queue.Dequeue();
62                 }
63             }
64             return null;
65         }
66 
67     }
```

PS：这里的入队和出队都要加锁，因为Queue默认不是线程安全的，不加锁会存在资源竞用问题从而业务出错，或者直接使用ConcurrentQueue线程安全的队列，就不需要加锁了，关于队列线程安全问题详见：http://www.cnblogs.com/yaopengfei/p/8322016.html

临时存储数据类的代码：

```
 1     /// <summary>
 2     /// 该类用来存储请求信息
 3     /// </summary>
 4     public class TempInfor
 5     {
 6         /// <summary>
 7         /// 用户编号
 8         /// </summary>
 9         public string userId { get; set; }
10     }
```

模拟高并发入队，单独线程出队的代码：

```
 1  {
 2                 //3.1 模拟高并发请求 写入队列
 3                 {
 4                     for (int i = 0; i < 100; i++)
 5                     {
 6                         Task.Run(() =>
 7                         {
 8                             TempInfor tempInfor = new TempInfor();
 9                             tempInfor.userId = Guid.NewGuid().ToString("N");
10                             //下面进行入队操作
11                             QueueUtils.instanse.Enqueue(tempInfor);
12 
13                         });
14                     }
15                 }        
16                 //3.2 模拟另外一个线程队列中读取数据请求标记，进行相应的业务处理（该线程一直运行，不停止）
17                 Task.Run(() =>
18                 {
19                     while (true)
20                     {
21                         if (QueueUtils.instanse.getCount() > 0)
22                         {
23                             //下面进行出队操作
24                             TempInfor tempInfor2 = (TempInfor)QueueUtils.instanse.Dequeue();
25 
26                             //拿到请求标记，进行相应的业务处理
27                             Console.WriteLine("id={0}的业务执行成功", tempInfor2.userId);
28                         }
29                     }           
30                 });
31                 //3.3 模拟过了一段时间(6s后)，又有新的请求写入
32                 Thread.Sleep(6000);
33                 Console.WriteLine("6s的时间已经过去了");
34                 {
35                     for (int j = 0; j < 100; j++)
36                     {
37                         Task.Run(() =>
38                         {
39                             TempInfor tempInfor = new TempInfor();
40                             tempInfor.userId = Guid.NewGuid().ToString("N");
41                             //下面进行入队操作
42                             QueueUtils.instanse.Enqueue(tempInfor);
43 
44                         });
45                     }
46                 }
47             }
```
3.下面案例的测试结果：

　　一次输出100条数据，6s过后，再一次输出100条数据。



1. 总结：

　　该方案是一种迂回的方式处理高并发，在业内这种思想也是非常常见，但该方案也有一个弊端，客户端请求的实时性很难保证，或者即使要保证(比如引入实时通讯技术)，

 也要付出不少代价.