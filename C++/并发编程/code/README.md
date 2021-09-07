# multi_threading
《C++并发编程实战》的读书笔记，供以后工作中查阅。
## 第一章
- 何谓并发和多线程

并发：单个系统里同时执行多个独立的活动。

多线程：每个线程相互独立运行，且每个线程可以运行不同的指令序列。但进程中所有线程都共享相同的地址空间，并且从所有的线程中访问到大部分数据。

- 为什么要在应用程序中使用并发和多线程

关注点分离（DVD程序逻辑分离）和性能（加快程序运行速度）

- 一个简单的C++多线程程序是怎么样的

[清单1.1 一个简单的Hello,Cuncurrent World程序](https://github.com/xuyicpp/multi_threading/blob/master/chapter01/example1_1.cpp)

## 第二章
- 启动线程，以及让各种代码在新线程上运行的方法

多线程在分离detach的时候，离开局部函数后，会在后台持续运行，直到程序结束。如果仍然需要访问局部函数的变量（就会造成悬空引用的错误）。
[清单2.1 当线程仍然访问局部变量时返回的函数](https://github.com/xuyicpp/multi_threading/blob/master/chapter02/example2_1.cpp)
解决上述错误的一个常见的方式，使函数自包含，并且把数据复制到该线程中而不是共享数据。

std::thread是支持移动的，如同std::unique_ptr是可移动的，而非可复制的。以下是两个转移thread控制权的例子
[清单2.5 从函数中返回std::thread,控制权从函数中转移出](https://github.com/xuyicpp/multi_threading/blob/master/chapter02/example2_5.cpp)、[清单2.6 scoped_thread和示例用法,一旦所有权转移到该对象其他线程就不就可以动它了，保证退出一个作用域线程完成](https://github.com/xuyicpp/multi_threading/blob/master/chapter02/example2_6.cpp)
- 等待线程完成并让它自动运行

在当前线程的执行到达f末尾时，局部对象会按照构造函数的逆序被销毁，因此，thread_guard对象g首先被销毁。所以使用thread_guard类可以保证std::thread对象被销毁前，在thread_guard析构函数中调用join。
[清单2.3 使用RAII等待线程完成](https://github.com/xuyicpp/multi_threading/blob/master/chapter02/example2_3.cpp)

- 唯一地标识线程

线程标识符是std::thread::id类型的
1.通过与之相关联的std::thread对象中调用get_id()。
2.当前线程的标识符可以调用std::this_thread::get_id()获得。

## 第三章

- 线程间共享数据的问题

所有线程间共享数据的问题，都是修改数据导致的（竞争条件）。如果所有的共享数据都是只读的，就没问题，因为一个线程所读取的数据不受另一个线程是否正在读取相同的数据而影响。

避免有问题的竞争条件
1.用保护机制封装你的数据结构，以确保只有实际执行修改的线程能够在不变量损坏的地方看到中间数据。
2.修改数据结构的设计及其不变量，从而令修改作为一系列不可分割的变更来完成，每个修改均保留其不变量。者通常被称为无锁编程，且难以尽善尽美。

- 用互斥元保护数据
在[清单3.1 用互斥元保护列表](https://github.com/xuyicpp/multi_threading/blob/master/chapter03/example3_1.cpp)中，有一个全局变量，它被相应的std::mutex的全局实例保护。在add_to_list()以及list_contains()中对std::lock_guard<std::mutex>的使用意味着这些函数中的访问是互斥的list_contains()将无法再add_to_list()进行修改的半途看到该表。

注意：一个迷路的指针或引用，所有的保护都将白费。在[清单3.2 意外地传出对受保护数据的引用](https://github.com/xuyicpp/multi_threading/blob/master/chapter03/example3_2.cpp)展示了这一个错误的做法。

发现接口中固有的竞争条件，这是一个粒度锁定的问题，就是说锁定从语句上升到接口了，书中用一个stack类做了一个扩展，详见[清单3.5 一个线程安全栈的详细类定义](https://github.com/xuyicpp/multi_threading/blob/master/chapter03/example3_5.cpp)

死锁：问题和解决方案:为了避免死锁，常见的建议是始终使用相同的顺序锁定者两个互斥元。
std::lock函数可以同时锁定两个或更多的互斥元，而没有死锁的风险。
常见的思路：
- 避免嵌套锁
- 在持有锁时，避免调用用户提供的代码
- 以固定顺序获取锁
这里有几个简单的事例：[清单3.7 使用锁层次来避免死锁](https://github.com/xuyicpp/multi_threading/blob/master/chapter03/example3_7.cpp)、[清单3.9 用std::unique_lock灵活锁定](https://github.com/xuyicpp/multi_threading/blob/master/chapter03/example3_9.cpp)

锁定在恰当的粒度
特别的，在持有锁时，不要做任何耗时的活动，比如文件的I/O。
一般情况下，只应该以执行要求的操作所需的最小可能时间而去持有锁。这也意味着耗时的操作，比如获取获取另一个锁（即便你知道它不会死锁）或是等待I/O完成，都不应该在持有锁的时候去做，除非绝对必要。
在[清单3.10 在比较运算符中每次锁定一个互斥元](https://github.com/xuyicpp/multi_threading/blob/master/chapter03/example3_10.cpp)虽然减少了持有锁的时间，但是也暴露在竞争条件中去了。

- 用于保护共享数据的替代工具
二次检测锁定模式，注意这个和单例模式中的饱汉模式不一样，它后面有对数据的使用
```
void undefined_behaviour_with_double_checked_locking()
{
	if(!resource_ptr)
	{
		std::lock_guard<std::mutex> lk(resource_mutex);
		if(!resource_ptr)
		{
			resoutce_ptr.reset(new some_resource);
		}
	}
	resource_ptr->do_something();
}
```
它有可能产生恶劣的竞争条件，因为在锁外部的读取与锁内部由另一线程完成的写入不同步。这就因此创建了一个竞争条件，不仅涵盖了指针本身，还涵盖了指向的对象。

C++标准库提供了std::once_flag和std::call_once来处理这种情况。使用std::call_once比显示使用互斥元通常会由更低的开销，特别是初始化已经完成的时候，应优先使用。[清单3.12 使用std::call_once的线程安全的类成员延迟初始化](https://github.com/xuyicpp/multi_threading/blob/master/chapter03/example3_12.cpp)

保护很少更新的数据结构：例如DNS缓存，使用读写互斥元：单个“写”线程独占访问或共享，由多个“读”线程并发访问。
[清单3.13 使用boost::share_mutex保护数据结构](https://github.com/xuyicpp/multi_threading/blob/master/chapter03/example3_13.cpp)

## 第4章 同步并发操作
- 等待事件

使用C++标准库提供的工具来等待事件本身。std::condition_variable的std::condition_variable_any，后者可以与任何互斥元一起工作，所以有额外代价的可能。
std::condition_variable可以调用notify_one()和notify_all()。然后std::condition_variable还可以wait(lk,[this]{return !data_queue.empty();}),这里的lk是unique_lock方便后面条件不满足的时候解锁，满足时开锁。
[清单4.1 使用std::condition_variable等待数据](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_01.cpp)

使用条件变量建立一个线程安全队列：[清单4.2 std::queue接口](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_02.cpp)、[清单4.4 从清单4.1中提取push()和wait_and_pop()](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_04.cpp)。

- 使用future来等待一次性事件

在一个线程不需要立刻得到结果的时候，你可以使用std::async来启动一个异步任务。std::async返回一个std::future对象，而不是给你一个std::thread对象让你在上面等待，std::future对象最终将持有函数的返回值，当你需要这个值时，只要在future上调用get(),线程就会阻塞知道future就绪，然后返回该值。
[清单4.6 使用std::future获取异步任务的返回值](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_06.cpp)

std::async允许你通过将额外的参数添加到调用中，来将附加参数传递给函数，这与std::thread是同样的方式。
[清单4.7 使用std::async来将参数传递给函数](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_07.cpp)

std::packaged_task<>将一个future绑定到一个函数或可调用对象上。当std::packaged_task<>对象被调用时，它就调用相关联的函数或可调用对象，并且让future就绪，将返回值作为关联数据存储。
[清单4.9 使用std::packaged_task在GUI线程上运行代码](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_09.cpp)

std::promise<T>提供一种设置值（类型T）方式，它可以在这之后通过相关联的std::future<T>对象进行读取。
[清单4.10 使用promise在单个线程中处理多个链接](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_10.cpp)，这个有点像select,或者poll。

同时，还要为future保存异常，以及使用share_future等待来自多个线程。

- 有时间限制的等待

1.基于时间段的超时。2.基于时间点的超时。
[清单4.11 等待一个具有超时的条件变量](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_11.cpp)

- 使用操作的同步来简化代码

解决同步问题的范式，函数式编程，其中每个任务产生的结果完全依赖于它的输入而不是外部环境，以及消息传递，ATM状态机，线程通信通过状态发送一部消息来实现的。
[清单4.13 使用future的并行快速排序](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_13.cpp)、
[清单4.15 ATM逻辑类的简单实现](https://github.com/xuyicpp/multi_threading/blob/master/chapter04/example4_15.cpp)。

## 第5章 C++内存模型和原子类型上操作
 
本章介绍了C++11内存模型的底层细节，以及在线程间提供同步基础的原子操作。这包括了由std::atomic<>类模板的特化提供的基本原子类型，由std::atomic<>主模板提供的泛型原子接口，在这些类型上的操作，以及各种内存顺序选项的复杂细节。
我们还看了屏障，以及它们如何通过原子类型上的操作配对，以强制顺序。最后，我们回到开头，看了看原子操作是如何用来在独立线程上的非原子操作之间强制顺序的。

在原子类型上的每一个操作均具有一个可选的内存顺序参数，它可以用来指定所需的内存顺序语义。
- 存储(store)操作，可以包括memory_order_relaxed、memory_order_release或memory_order_seq_cst顺序。
- 载入(load)操作，可以包括memory_order_relaxed、memory_order_consume、memory_order_acquire或memory_order_seq_cst顺序。
- 读-修改-写(read-modify-write)操作，可以包括memory_order_relaxed、memory_order_consume、memory_order_acquire、memory_order_release、memory_order_acq_rel或memory_order_seq_cst顺序。

所有操作的默认顺序为memory_order_seq_cst。

原子操作的内存顺序的三种模型：
- 顺序一致顺序(sequentially consistent):(memory_order_seq_cst):[清单5.4 顺序一致隐含着总体顺序](https://github.com/xuyicpp/multi_threading/blob/master/chapter05/example5_04.cpp)。
- 松散顺序(relaxed):(memory_order_relaxed):[清单5.6 多线程的松散操作](https://github.com/xuyicpp/multi_threading/blob/master/chapter05/example5_06.cpp)。
- 获取-释放顺序(acquire-release):(memory_order_consume、memory_order_acquire、memory_order_release和memory_order_acq_rel):[清单5.9 使用获取和释放顺序的传递性同步](https://github.com/xuyicpp/multi_threading/blob/master/chapter05/example5_09.cpp)、[清单5.10 使用std::memory_order_consume同步数据(原子载入操作指向某数据的指针)](https://github.com/xuyicpp/multi_threading/blob/master/chapter05/example5_10.cpp)

synchronizes-with(与同步):
- 在原子变量的载入和来自另一个线程的对该原子变量的载入之间，建立一个synchronizes-with关系，[清单5.11 使用原子操作从队列中读取值](https://github.com/xuyicpp/multi_threading/blob/master/chapter05/example5_11.cpp)
- 在一个线程中释放屏障，在另一个线程中获取屏障，从而实现synchronizes-with关系，[清单5.12 松散操作可以使用屏障来排序](https://github.com/xuyicpp/multi_threading/blob/master/chapter05/example5_12.cpp)

happens-before(发生于之前):传递性：如果A线程发生于B线程之前，并且B线程发生于C之前，则A线程间发生于C之前。
- [清单5.8 获取-释放操作可以在松散操作中施加顺序](https://github.com/xuyicpp/multi_threading/blob/master/chapter05/example5_08.cpp)
- [清单5.13 在非原子操作上强制顺序](https://github.com/xuyicpp/multi_threading/blob/master/chapter05/example5_13.cpp)

## 第六章 设计基于锁的并发数据结构

为并发存取设计数据结构时，需要考虑两方面：
1、保证存取是安全的
- 保证当数据结构不变性被别的线程破坏时的状态不被任何别的线程看到。
- 注意避免数据结构接口所固有的竞争现象，通过为完整操作提供函数，而不是提供操作步骤。
- 注意当出现例外时，数据结构是怎样来保证不变性不被破坏的。
- 当使用数据结构时，通过限制锁的范围和避免使用嵌套锁，来降低产生死锁的机会。
2、实现真正的并发存取
- 锁的范围能否被限定，使得一个操作的一部分可以在锁外被执行？
- 数据结构的不同部分能否被不同的互斥元保护？
- 是否所有操作需要同样级别的保护？
- 数据结构的一个小改变能否在不影响操作语义情况下提高并发性的机会？

一些通用的数据结构(栈、队列、哈希映射以及链表)，考虑了如何在设计并发存取的时候应用上述设计准则来实现他们，使用锁来保护数据并阻止数据竞争。


- 使用锁的线程安全栈
[清单6.1 线程安全栈的类定义](https://github.com/xuyicpp/multi_threading/blob/master/chapter06/example6_01.cpp)
- 使用细粒度锁和条件变量的线程安全队列
[清单6.7 使用锁和等待的线程安全队列：内部与接口](https://github.com/xuyicpp/multi_threading/blob/master/chapter06/example6_07.cpp)
- 一个使用锁的线程安全查找表
[清单6.11 线程安全查找表](https://github.com/xuyicpp/multi_threading/blob/master/chapter06/example6_11.cpp)
- 一个使用锁的线程安全链表
[清单6.13 支持迭代的线程安全链表](https://github.com/xuyicpp/multi_threading/blob/master/chapter06/example6_13.cpp)

## 第七章 设计无锁的并发数据结构

- 为无需使用锁的并发而设计的数据结构的实现
- 在无锁数据结构中管理内存的技术
- 有助于编写无锁数据结构的简单准则

### 定义

使用互斥元，条件变量以及future来同步数据的算法和数据结构被称为阻塞(blocking)的算法和数据结构。不使用阻塞库函数的数据结构和算法被称为非阻塞(nonblocking)的。但是，并不是所有的数据结构都是无锁(lock-free)的。

[清单7.1 使用std::atomic_flag的自旋锁互斥元的实现](https://github.com/xuyicpp/multi_threading/blob/master/chapter07/example7_01.cpp)这段代码，没有阻塞调用。然而，它并非无锁的。它仍然是一个互斥元，并且一次仍然只能被一个线程锁定。

对于有资格称为无锁的数据结构，就必须能够让多余一个线程可以并发地访问次数据结构。

无等待的数据结构是一种无锁的数据结构，并且有着额外的特性，每个访问数据结构的线程都可以在有限数量的步骤内完成它的操作，而不用管别的线程的行为。

### 无锁数据结构的优点与缺点

优点：
- 1.实现最大程度的并发。
- 2.健壮性：当一个线程在持有锁的时候终止，那个数据结构就永远被破坏了。但是如果一个线程在操作无锁数据结构时终止了，就不会丢失任何数据，除了此线程的数据之外，其他线程可以继续正常执行。

缺点：
- 1.无锁数据结构时不会发生死锁的，尽管有可能存在活锁。活锁会降低性能而不会导致长期的问题，但是也是需要注意的事情。根据定义，无等待的代码无法忍受活锁，因为它执行操作的步骤数通常是有上限的。另一方面，这种算法比别的算法更复杂，并且即使当没有线程存取数据结构的时候也需要执行更多的步骤。
- 2.它可能降低整体的性能。1、原子操作可能比非原子操作要慢很多。2、与基于锁数据结构的互斥元锁代码相比，无锁数据结构中需要更多的原子操作。3、硬件必须在存取同样的原子变量相关的乒乓缓存可能会成为一种显著的性能消耗。

总结：
- 选择有锁无锁的数据结构之前，比较，是否为最坏等待时间，平均等待时间，总的执行时间......是很重要的。

### 无锁数据结构的例子

从清单7.2-清单7.12不用锁的线程安全栈，从清单7.13-清单7.21无锁线程安全队列。
(这里不是看的很懂以后有机会再补充)。另外哑元结点是一个和有意思的概念。

### 编写无锁数据结构的准则

- 使用std::memory_order_seq_cst作为原型(先用顺序一致顺序跑通，再来其他的骚操作)
- 使用无锁内存回收模式(1.等待直到没有线程访问该数据结构，并且删除所有等待删除的对象。2.使用风险指针来确定线程正在访问一个特定的对象。3.引用计数对象，只有直到没有显著的引用时才删除它们。)
- 当心ABA问题，就是线程1，比较/交换操作原子x，发现它的值是A，然后阻塞，然后，线程2，改成B，然后，线程3改回了A(并且恰好使用了相同的地址),线程1，比较/交换成功。破坏了数据结构。
- 解决ABA问题的方法就是在变量x使用一个ABA计数器。使用空闲表或者回收结点而不是将它返回给分配器，使ABA常见。
- 识别忙于等待的循环以及辅助其他线程(数据成员变原子，并使用比较/交换操作设置它)

## 第8章 设计并发代码

### 在线程间划分工作的技术
- 处理开始前在线程间划分数据
- 递归地划分数据
- 以任务类型划分工作

### 影响并发代码性能的因素
- 有多少个处理器
- 数据竞争和乒乓缓存：处理器很多需要互相等待称为高竞争。在如下的循环中，counter的数据在各处理器的缓存间来回传递。这被称为乒乓缓存(cache ping-pong)，而且会严重影响性能。

```
std::atomic<unsigned long> counter(0);
void processing_loop()
{
	while(counter.fetch_add(1,std::memory_order_relaxed)<100000000)
	{
		do_something();
	}
}
```
- 假共享：处理器缓存的最小单位通常不是一个内存地址，而是一小块缓存线(cache line)的内存。这些内存块一般大小为32 ~ 64字节，取决于具体的处理器。这个缓存线是两者共享的，然而其中的数据并不共享，因此称为假共享(false sharing)。
- 数据应该多紧密
- 过度订阅和过多的任务切换

### 为多线程性能设计数据结构
为多线程性能设计你的数据结构时：竞争、假共享以及数据接近。
- 为复杂操作划分数组元素
- 其他数据结构中的数据访问方式

### 为并发设计时的额外考虑
- 并行算法中的异常安全：1.用对象的析构函数中检查2.STD::ASYNC()的异常安全
- 可扩展性和阿姆达尔定律：简单来说就是设计最大化并发
- 用多线程隐藏延迟
- 用并发提高响应性

### 在实践中设计并发代码
- std::for_each的并行实现:[清单8.7 std::for_each的并行版本](https://github.com/xuyicpp/multi_threading/blob/master/chapter08/example8_07.cpp)、[清单8.8 使用std::async的std::for_each的并行版本](https://github.com/xuyicpp/multi_threading/blob/master/chapter08/example8_08.cpp)
- std::find的并行实现:[清单8.9 并行find算法的一种实现](https://github.com/xuyicpp/multi_threading/blob/master/chapter08/example8_09.cpp)、[清单8.10 使用std::async的并行查找算法的实现](https://github.com/xuyicpp/multi_threading/blob/master/chapter08/example8_10.cpp)
- std::partial_sum的并行实现:[清单8.11 通过划分问题来并行计算分段的和](https://github.com/xuyicpp/multi_threading/blob/master/chapter08/example8_11.cpp)、[清单8.13 通过成对更新的partial_sum的并行实现](https://github.com/xuyicpp/multi_threading/blob/master/chapter08/example8_13.cpp)
- 屏障(barrier):一种同步方法使得线程等待直到要求的线程已经到达了屏障。[清单8.12 一个简单的屏障类](https://github.com/xuyicpp/multi_threading/blob/master/chapter08/example8_12.cpp)

## 第9章 高级线程管理

本章,我们考虑了许多“高级的“线程管理方法：线程池和中断线程。

- [清单9.1 简单的线程池](https://github.com/xuyicpp/multi_threading/blob/master/chapter09/example9_01.cpp)
- [清单9.9 interruptible_thread的基本实现](https://github.com/xuyicpp/multi_threading/blob/master/chapter09/example9_09.cpp)

你已经看到使用本地工作队列如何减少同步管理以及潜在提高线程池的吞吐量，

- [清单9.6 使用本地线程工作队列的线程池](https://github.com/xuyicpp/multi_threading/blob/master/chapter09/example9_06.cpp)

并且看到当等待子任务完成时如何运行队列中别的任务来减少发生死锁的可能性。

- [清单9.8 使用工作窃取的线程池](https://github.com/xuyicpp/multi_threading/blob/master/chapter09/example9_08.cpp)

我们也考虑了许多方法来允许一个线程中断另一个线程的处理，例如使用特殊中断点
```
void interruption_point()
{
	if(this_thread_interrupt_flag.is_set())
	{
		throw thread_interrupted();
	}
}
```
和如何将原本会被中断阻塞的函数变得可以被中断。
```
template<typename T>
void interruptible_wait(std::future<T>& uf)
{
	//这会一直等到要么中断标志被设置，要么future已经准备好了，但是每次在future上执行阻塞要等待1ms。
	while(!this_thread_interrupt_flag.is_set())
	{
		if(uf.wait_for(lk.std::chrono::miliseconds(1)==std::future_status::ready))
			break;
	}
	interruption_point();
}
```

## 第10章 多线程应用的测试与调试

### 并发相关错误的类型

不必要的阻塞
- 死锁
- 活锁
- 在I/O或外部输入上的阻塞

竞争条件
- 数据竞争
- 破坏不变量
- 生存期问题

### 定位并发相关的错误的技巧

#### 审阅代码以定位潜在的错误
- 该线程载入的数据是否有效？该数据是够已经被其他线程修改了？
- 如果你假设其他线程可能正在修改该数据，那么可能会导致什么样的后果以及如何保证这样的事情永不发生？

#### 通过测试定位并发相关的错误

#### 可测试性设计
- 每个函数功能和类的划分清晰明确
- 函数扼要简洁
- 你的测试代码可以完全控制你的被测试代码的周围的环境
- 被测试的需要特定操作的代码应该集中在一块而不是分散在整个系统中。
- 在你写测试代码之前你要先考虑如何测试代码

#### 多线程测试技术
- 暴力测试(穷举法)
- 组合仿真测试
- 使用特殊的库函数来检测测试暴露出的问题


















