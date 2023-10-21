# Queue


## 0 Queue介绍

### 主要方法
`Queue`队列，在 JDK 中有两种不同类型的集合实现：**单向队列**（AbstractQueue） 和 **双端队列**（Deque）

![img](https://cdn.nlark.com/yuque/0/2020/png/1694029/1595684241064-e863aeca-6a95-4423-92c4-762f56be1dbe.png)

Queue 中提供了两套增加、删除元素的 API，当插入或删除元素失败时，会有**两种不同的失败处理策略**。

| 方法及失败策略 | 插入方法 | 删除方法 | 查找方法 |
| :------------- | :------- | :------- | -------- |
| 抛出异常       | add()    | remove() | get()    |
| 返回失败默认值 | offer()  | poll()   | peek()   |

选取哪种方法的决定因素：插入和删除元素失败时，希望`抛出异常`还是返回`布尔值`

`add()` 和 `offer()` 对比：

在队列长度大小确定的场景下，队列放满元素后，添加下一个元素时，add() 会抛出 `IllegalStateException`异常，而 `offer()` 会返回 `false` 。

但是它们两个方法在插入**某些不合法的元素**时都会抛出三个相同的异常。

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1694029/1595691512036-ed9fd3ea-5432-4105-a3fb-a5374d571971.png)

`remove()` 和 `poll()` 对比：

在**队列为空**的场景下， `remove()` 会抛出 `NoSuchElementException`异常，而 `poll()` 则返回 `null` 。

`get()`和`peek()`对比：

在队列为空的情况下，`get()`会抛出`NoSuchElementException`异常，而`peek()`则返回`null`。


### Deque 接口

`Deque` 接口的实现非常好理解：从**单向**队列演变为**双向**队列，内部额外提供**双向队列的操作方法**即可：

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1694029/1596166722772-975ff644-6abf-441b-b678-4a6de5b0eef1.png)

Deque 接口额外提供了**针对队列的头结点和尾结点**操作的方法，而**插入、删除方法同样也提供了两套不同的失败策略**。除了`add()`和`offer()`，`remove()`和`poll()`以外，还有`get()`和`peek()`出现了不同的策略

### AbstractQueue 抽象类

AbstractQueue 类中提供了各个 API 的基本实现，主要针对各个不同的处理策略给出基本的方法实现，定义在这里的作用是让`子类`根据其`方法规范`（操作失败时抛出异常还是返回默认值）实现具体的业务逻辑。

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1694029/1596167156067-36121579-8127-4019-ba47-e4de73f05cda.png)


## 1 LinkedList

### 继承关系

![](image/2022-12-15-16-55-23.png)

### 底层实现

LinkedList 底层采用`双向链表`数据结构存储元素，由于链表的内存地址`非连续`，所以它不具备随机访问的特点，但由于它利用指针连接各个元素，所以插入、删除元素只需要`操作指针`，不需要`移动元素`，故具有**增删快、查询慢**的特点。它也是一个非线程安全的集合。

![](image/2022-12-15-16-54-49.png)



由于以双向链表作为数据结构，它是**线程不安全**的集合；存储的每个节点称为一个`Node`，下图可以看到 Node 中保存了`next`和`prev`指针，`item`是该节点的值。在插入和删除时，时间复杂度都保持为 `O(1)`

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1694029/1595725358023-1f64f780-9dd0-47ff-a84c-d4101d16c1e1.png)

关于 LinkedList，除了它是以链表实现的集合外，还有一些特殊的特性需要注意的。

- 优势：LinkedList 底层没有`扩容机制`，使用`双向链表`存储元素，所以插入和删除元素效率较高，适用于频繁操作元素的场景
- 劣势：LinkedList 不具备`随机访问`的特点，查找某个元素只能从 `head` 或 `tail` 指针一个一个比较，所以**查找中间的元素时效率很低**
- 查找优化：LinkedList 查找某个下标 `index` 的元素时**做了优化**，若 `index > (size / 2)`，则从 `head` 往后查找，否则从 `tail` 开始往前查找，代码如下所示：

```Java
LinkedList.Node<E> node(int index) {
    LinkedList.Node x;
    int i;
    if (index < this.size >> 1) { // 查找的下标处于链表前半部分则从头找
        x = this.first;
        for(i = 0; i < index; ++i) { x = x.next; }
        return x;
    } else { // 查找的下标处于数组的后半部分则从尾开始找
        x = this.last;
        for(i = this.size - 1; i > index; --i) { x = x.prev; }
        return x;
    }
}
```

- 双端队列：使用双端链表实现，并且实现了 `Deque` 接口，使得 LinkedList 可以用作**双端队列**。下图可以看到 Node 是集合中的元素，提供了前驱指针和后继指针，还提供了一系列操作`头结点`和`尾结点`的方法，具有双端队列的特性。

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1694029/1595693779116-a8156f03-36fa-4557-892e-ea5103b06136.png)

LinkedList 集合最让人树枝的是它的链表结构，但是我们同时也要注意它是一个双端队列型的集合。

```java
Deque<Object> deque = new LinkedList<>();
```

### 常用方法


```java
LinkedList() ：初始化一个空的LinkedList实现。
LinkedListExample(Collection c) ：初始化一个LinkedList，该LinkedList包含指定集合的​​元素，并按集合的迭代器返回它们的顺序。
boolean add(Object o) ：将指定的元素追加到列表的末尾。
void add（int index，Object element） ：将指定的元素插入列表中指定位置的索引处。
void addFirst(Object o) ：将给定元素插入列表的开头。
void addLast(Object o) ：将给定元素附加到列表的末尾。
int size() ：返回列表中的元素数
boolean contains(Object o) ：如果列表包含指定的元素，则返回true ，否则返回false 。
boolean remove(Object o) ：删除列表中指定元素的第一次出现。
Object getFirst() ：返回列表中的第一个元素。
Object getLast() ：返回列表中的最后一个元素。
int indexOf(Object o) ：返回指定元素首次出现的列表中的索引；如果列表不包含指定元素，则返回-1。
lastIndexOf(Object o) ：返回指定元素最后一次出现的列表中的索引；如果列表不包含指定元素，则返回-1。
Iterator iterator() ：以适当的顺序返回对该列表中的元素进行迭代的迭代器。
Object[] toArray() ：以正确的顺序返回包含此列表中所有元素的数组。
List subList（int fromIndex，int toIndex） ：返回此列表中指定的fromIndex（包括）和toIndex（不包括）之间的视图。
```

### LinkedList与ArrayList

* ArrayList是使用动态可调整大小的数组的概念实现的。 而LinkedList是双向链表实现。
* ArrayList允许随机访问其元素，而LinkedList则不允许。
* LinkedList还实现了Queue接口，该接口添加了比ArrayList更多的方法，例如offer（），peek（），poll（）等。
* 与LinkedList相比， ArrayList添加和删​​除速度较慢，但​​在获取时却较快，因为如果LinkedList中的array已满，则无需调整数组大小并将内容复制到新数组。
* LinkedList比ArrayList具有更多的内存开销，因为在ArrayList中，每个索引仅保存实际对象，但是在LinkedList的情况下，每个节点都保存下一个和上一个节点的数据和地址。


## 2 ArrayDeque

使用**数组**实现的双端队列，它是**无界**的双端队列，最小的容量是`8`（JDK 1.8）。在 JDK 11 看到它默认容量已经是 `16`了。

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1694029/1595695213834-cb4f1c3a-e07a-42aa-981f-31a896febe26.png)

`ArrayDeque` 在日常使用得不多，值得注意的是它与 `LinkedList` 的对比：`LinkedList` 采用**链表**实现双端队列，而 `ArrayDeque` 使用**数组**实现双端队列。

> 在文档中作者写到：**ArrayDeque 作为栈时比 Stack 性能好，作为队列时比 LinkedList 性能好**

由于双端队列**只能在头部和尾部**操作元素，所以删除元素和插入元素的时间复杂度大部分都稳定在 `O(1)` ，除非在扩容时会涉及到元素的批量复制操作。但是在大多数情况下，使用它时应该指定一个大概的数组长度，避免频繁的扩容。


## 3 PriorityQueue
### 底层原理
PriorityQueue 基于**优先级堆实现**的优先级队列，而堆是采用**数组**实现：

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1694029/1595727271522-d144468c-041e-4721-a786-9f952f06fafe.png)

文档中的描述告诉我们：该数组中的元素通过传入 `Comparator` 进行定制排序，如果不传入`Comparator`时，则按照元素本身`自然排序`，但要求元素实现了`Comparable`接口，所以 PriorityQueue **不允许存储 NULL 元素**。

PriorityQueue 应用场景：元素本身具有优先级，需要按照**优先级处理元素**

- 例如游戏中的VIP玩家与普通玩家，VIP 等级越高的玩家越先安排进入服务器玩耍，减少玩家流失。

```Java
public static void main(String[] args) {
    Student vip1 = new Student("张三", 1);
    Student vip3 = new Student("洪七", 2);
    Student vip4 = new Student("老八", 4);
    Student vip2 = new Student("李四", 1);
    Student normal1 = new Student("王五", 0);
    Student normal2 = new Student("赵六", 0);
    // 根据玩家的 VIP 等级进行降序排序
    PriorityQueue<Student> queue = new PriorityQueue<>((o1, o2) ->  o2.getScore().compareTo(o1.getScore()));
    queue.add(vip1);queue.add(vip4);queue.add(vip3);
    queue.add(normal1);queue.add(normal2);queue.add(vip2);
    while (!queue.isEmpty()) {
        Student s1 = queue.poll();
        System.out.println(s1.getName() + "进入游戏; " + "VIP等级: " + s1.getScore());
    }
}
 public static class Student implements Comparable<Student> {
     private String name;
     private Integer score;
     public Student(String name, Integer score) {
         this.name = name;
         this.score = score;
     }
     @Override
     public int compareTo(Student o) {
         return this.score.compareTo(o.getScore());
     }
 }
```

执行上面的代码可以得到下面这种有趣的结果，可以看到`氪金`使人带来快乐。

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1694029/1595727945968-768b45bb-96dc-4850-8759-f07776107a23.png)

VIP 等级越高（优先级越高）就越优先安排进入游戏（优先处理），类似这种有优先级的场景还有非常多，各位可以发挥自己的想象力。

PriorityQueue 总结：

- PriorityQueue 是基于**优先级堆**实现的优先级队列，而堆是用**数组**维护的

- PriorityQueue 适用于**元素按优先级处理**的业务场景，例如用户在请求人工客服需要排队时，根据用户的**VIP等级**进行 `插队` 处理，等级越高，越先安排客服。


### 主要方法
```java
boolean add(object) ：将指定的元素插入此优先级队列。
boolean offer(object) ：将指定的元素插入此优先级队列。
boolean remove(object) ：从此队列中移除指定元素的单个实例（如果存在）。
Object poll() ：检索并删除此队列的头部；如果此队列为空，则返回null。
Object element() ：获取但不删除此队列的头部，如果此队列为空，则抛出NoSuchElementException 。
Object peek() ：检索但不删除此队列的头部；如果此队列为空，则返回null。
void clear() ：从此优先级队列中删除所有元素。
Comparator comparator() ：返回用于对此队列中的元素进行排序的Comparator comparator()如果此队列是根据其元素的自然顺序排序的，则返回null。
boolean contains(Object o) ：如果此队列包含指定的元素，则返回true。
Iterator iterator() ：返回对该队列中的元素进行迭代的迭代器。
int size() ：返回此队列中的元素数。
Object[] toArray() ：返回一个包含此队列中所有元素的数组。
```


## 4 PriorityBlockingQueue

### 底层原理
Java PriorityBlockingQueue类是concurrent阻塞队列数据结构的实现，其中根据对象的priority对其进行处理。 名称的“阻塞”部分已添加，表示线程将阻塞等待，直到队列上有可用的项目为止 。

在priority blocking queue ，添加的对象根据其优先级进行排序。 默认情况下，优先级由对象的自然顺序决定。 队列构建时提供的Comparator器可以覆盖默认优先级。
* PriorityBlockingQueue是一个无界队列，并且会动态增长。 默认初始容量为'11' ，可以在适当的构造函数中使用initialCapacity参数覆盖此初始容量。
* 它**提供了阻塞检索操作**。
* 它不允许使用NULL对象。
* 添加到PriorityBlockingQueue的对象必须具有可比性，否则它将引发ClassCastException 。
* 默认情况下，优先级队列的对象以自然顺序排序 。
* 比较器可用于队列中对象的自定义排序。
* 优先级队列的head是基于自然排序或基于比较器排序的least元素。 当我们轮询队列时，它从队列中返回头对象。
* 如果存在多个具有相同优先级的对象，则它可以随机轮询其中的任何一个。
* PriorityBlockingQueue是thread safe 。

### 主要方法

```java
boolean add(object) ：将指定的元素插入此优先级队列。
boolean offer(object) ：将指定的元素插入此优先级队列。
boolean remove(object) ：从此队列中移除指定元素的单个实例（如果存在）。
Object poll() ：检索并删除此队列的头部，并在必要时等待指定的等待时间，以使元素可用。
Object poll(timeout, timeUnit) ：检索并删除此队列的头部，如果有必要，直到指定的等待时间，元素才可用。
Object take() ：检索并删除此队列的头部，如有必要，请等待直到元素可用。
void put(Object o) ：将指定的元素插入此优先级队列。
void clear() ：从此优先级队列中删除所有元素。
Comparator comparator() ：返回用于对此队列中的元素进行排序的Comparator comparator()如果此队列是根据其元素的自然顺序排序的，则返回null。
boolean contains(Object o) ：如果此队列包含指定的元素，则返回true。
Iterator iterator() ：返回对该队列中的元素进行迭代的迭代器。
int size() ：返回此队列中的元素数。
int drainTo(Collection c) ：从此队列中删除所有可用元素，并将它们添加到给定的collection中。
intrainToTo（Collection c，int maxElements） ：从此队列中最多移除给定数量的可用元素，并将它们添加到给定的collection中。
int remainingCapacity() Integer.MAX_VALUE int remainingCapacity() ：总是返回Integer.MAX_VALUE因为PriorityBlockingQueue不受容量限制。
Object[] toArray() ：返回一个包含此队列中所有元素的数组。
```
### 实例
```java
import java.util.concurrent.PriorityBlockingQueue;
import java.util.concurrent.TimeUnit;
 
public class PriorityQueueExample 
{
    public static void main(String[] args) throws InterruptedException 
    {
        PriorityBlockingQueue<Integer> priorityBlockingQueue = new PriorityBlockingQueue<>();
         
        new Thread(() -> 
        {
          System.out.println("Waiting to poll ...");
          
          try
          {
              while(true) 
              {
                  Integer poll = priorityBlockingQueue.take();
                  System.out.println("Polled : " + poll);
 
                  Thread.sleep(TimeUnit.SECONDS.toMillis(1));
              }
               
          } catch (InterruptedException e) {
              e.printStackTrace();
          }
           
        }).start();
          
        Thread.sleep(TimeUnit.SECONDS.toMillis(2));
        priorityBlockingQueue.add(1);
         
        Thread.sleep(TimeUnit.SECONDS.toMillis(2));
        priorityBlockingQueue.add(2);
         
        Thread.sleep(TimeUnit.SECONDS.toMillis(2));
        priorityBlockingQueue.add(3);
    }
}
```

## 5 ArrayBlockingQueue

### 底层原理

ArrayBlockingQueue类是由数组支持的Java concurrent和bounded阻塞队列实现。 它对元素FIFO（先进先出）进行排序。

ArrayBlockingQueue的head是一直在队列中最长时间的那个元素。 ArrayBlockingQueue的tail是最短时间进入队列的元素。 新元素插入到队列的尾部 ，并且队列检索操作在队列的开头获取元素 。

* ArrayBlockingQueue是由数组支持的固定大小的有界队列。
* 它对元素FIFO（先进先出）进行排序。
* 元素插入到尾部，并从队列的开头检索。
* 创建后，队列的容量无法更改。
* 它提供阻塞的插入和检索操作 。
* 它不允许使用NULL对象。
* ArrayBlockingQueue是thread safe 。
* 方法iterator()提供的Iterator按从第一个（头）到最后一个（尾部）的顺序遍历元素。
* ArrayBlockingQueue支持可选的fairness policy用于订购等待的生产者线程和使用者线程。 将fairness设置为true ，队列按FIFO顺序授予线程访问权限。




### 生产消费者实例
使用阻塞插入和检索从ArrayBlockingQueue中放入和取出元素的Java示例。

* 当队列已满时，生产者线程将等待。 一旦从队列中取出一个元素，它就会将该元素添加到队列中。
* 如果队列为空，使用者线程将等待。 队列中只有一个元素时，它将取出该元素。
```java
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.TimeUnit;
 
public class ArrayBlockingQueueExample 
{
    public static void main(String[] args) throws InterruptedException 
    {
        ArrayBlockingQueue<Integer> priorityBlockingQueue = new ArrayBlockingQueue<>(5);
 
        //Producer thread
        new Thread(() -> 
        {
            int i = 0;
            try
            {
                while (true) 
                {
                    priorityBlockingQueue.put(++i);
                    System.out.println("Added : " + i);
                     
                    Thread.sleep(TimeUnit.SECONDS.toMillis(1));
                }
 
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
 
        }).start();
 
        //Consumer thread
        new Thread(() -> 
        {
            try
            {
                while (true) 
                {
                    Integer poll = priorityBlockingQueue.take();
                    System.out.println("Polled : " + poll);
                     
                    Thread.sleep(TimeUnit.SECONDS.toMillis(2));
                }
 
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
 
        }).start();
    }
}
```

### 主要方法

```java
ArrayBlockingQueue(int capacity) ：构造具有给定（固定）容量和默认访问策略的空队列。
ArrayBlockingQueue（int capacity，boolean fair） ：构造具有给定（固定）容量和指定访问策略的空队列。 如果公允值为true ，则按FIFO顺序处理在插入或移除时阻塞的线程的队列访问； 如果为false，则未指定访问顺序。
ArrayBlockingQueue（int capacity，boolean fair，Collection c） ：构造一个队列，该队列具有给定（固定）的容量，指定的访问策略，并最初包含给定集合的元素，并以集合迭代器的遍历顺序添加。
void put(Object o) ：将指定的元素插入此队列的尾部，如果队列已满，则等待空间变为可用。
boolean add(object) : Inserts the specified element at the tail of this queue if it is possible to do so immediately without exceeding the queue’s capacity, returning true upon success and throwing an IllegalStateException if this queue is full.
boolean offer(object) ：如果可以在不超出队列容量的情况下立即执行此操作，则在此队列的尾部插入指定的元素，如果成功，则返回true，如果此队列已满，则抛出IllegalStateException。
boolean remove(object) ：从此队列中移除指定元素的单个实例（如果存在）。
Object peek() ：检索但不删除此队列的头部；如果此队列为空，则返回null。
Object poll() ：检索并删除此队列的头部；如果此队列为空，则返回null。
Object poll(timeout, timeUnit) ：检索并删除此队列的头部，如果有必要，直到指定的等待时间，元素才可用。
Object take() ：检索并删除此队列的头部，如有必要，请等待直到元素可用。
void clear() ：从队列中删除所有元素。
boolean contains(Object o) ：如果此队列包含指定的元素，则返回true。
Iterator iterator() ：以适当的顺序返回对该队列中的元素进行迭代的迭代器。
int size() ：返回此队列中的元素数。
int drainTo(Collection c) ：从此队列中删除所有可用元素，并将它们添加到给定的collection中。
intrainToTo（Collection c，int maxElements） ：从此队列中最多移除给定数量的可用元素，并将它们添加到给定的collection中。
int remainingCapacity() ：返回该队列理想情况下（在没有内存或资源限制的情况下）可以接受而不阻塞的其他元素的数量。
Object[] toArray() ：以适当的顺序返回一个包含此队列中所有元素的数组。
```


## 6 LinkedTransferQueue

### 底层原理

直接消息队列。也就是说，生产者生产后，必须等待消费者来消费才能继续执行。

Java TransferQueue是并发阻塞队列的实现，生产者可以在其中等待使用者使用消息。 LinkedTransferQueue类是Java中TransferQueue的实现。


* LinkedTransferQueue是链接节点上的unbounded队列。
* 此队列针对任何给定的生产者对元素FIFO（先进先出）进行排序。
* 元素插入到尾部，并从队列的开头检索。
* 它提供阻塞的插入和检索操作 。
* 它不允许使用NULL对象。
* LinkedTransferQueue是thread safe 。
* 由于异步性质，size（）方法不是固定时间操作，因此，如果在遍历期间修改此集合，则可能会报告不正确的结果。
* 不保证批量操作addAll，removeAll，retainAll，containsAll，equals和toArray是原子执行的。 例如，与addAll操作并发操作的迭代器可能仅查看某些添加的元素。



### 实例
非阻塞实例

```java
LinkedTransferQueue<Integer> linkedTransferQueue = new LinkedTransferQueue<>();
         
linkedTransferQueue.put(1);
 
System.out.println("Added Message = 1");
 
Integer message = linkedTransferQueue.poll();
 
System.out.println("Recieved Message = " + message);
```

阻塞插入实例，用于现成状态同步通信
使用阻塞插入和检索从LinkedTransferQueue放入和取出元素的Java示例。

* 生产者线程将等待，直到有消费者准备从队列中取出项目为止。
* 如果队列为空，使用者线程将等待。 队列中只有一个元素时，它将取出该元素。 只有在消费者接受了消息之后，生产者才可以再发送一条消息。




```java
import java.util.Random;
import java.util.concurrent.LinkedTransferQueue;
import java.util.concurrent.TimeUnit;
 
public class LinkedTransferQueueExample 
{
    public static void main(String[] args) throws InterruptedException 
    {
        LinkedTransferQueue<Integer> linkedTransferQueue = new LinkedTransferQueue<>();
 
        new Thread(() -> 
        {
            Random random = new Random(1);
            try
            {
                while (true) 
                {
                    System.out.println("Producer is waiting to transfer message...");
                     
                    Integer message = random.nextInt();
                    boolean added = linkedTransferQueue.tryTransfer(message);
                    if(added) {
                        System.out.println("Producer added the message - " + message);
                    }
                    Thread.sleep(TimeUnit.SECONDS.toMillis(3));
                }
 
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
 
        }).start();
         
        new Thread(() -> 
        {
            try
            {
                while (true) 
                {
                    System.out.println("Consumer is waiting to take message...");
                     
                    Integer message = linkedTransferQueue.take();
                     
                    System.out.println("Consumer recieved the message - " + message);
                     
                    Thread.sleep(TimeUnit.SECONDS.toMillis(3));
                }
 
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
 
        }).start();
    }
}
```


### 主要方法

```java
LinkedTransferQueue() ：构造一个初始为空的LinkedTransferQueue。
LinkedTransferQueue(Collection c) ：构造一个LinkedTransferQueue，最初包含给定集合的元素，并以该集合的迭代器的遍历顺序添加。
Object take() ：检索并删除此队列的头部，如有必要，请等待直到元素可用。
void transfer(Object o) ：将元素传输给使用者，如有必要，请等待。
boolean tryTransfer(Object o) ：如果可能，立即将元素传输到等待的使用者。
boolean tryTransfer（Object o，long timeout，TimeUnit unit） ：如果有可能，则在超时之前将元素传输给使用者。
int getWaitingConsumerCount() ：返回等待通过BlockingQueue.take（）或定时轮询接收元素的使用者数量的估计值。
boolean hasWaitingConsumer() ：如果至少有一个使用者正在等待通过BlockingQueue.take（）或定时轮询接收元素，则返回true。
void put(Object o) ：将指定的元素插入此队列的尾部。
boolean add(object) : Inserts the specified element at the tail of this queue.
boolean offer(object) ：将指定的元素插入此队列的尾部。
boolean remove(object) ：从此队列中移除指定元素的单个实例（如果存在）。
Object peek() ：检索但不删除此队列的头部；如果此队列为空，则返回null。
Object poll() ：检索并删除此队列的头部；如果此队列为空，则返回null。
Object poll(timeout, timeUnit) ：检索并删除此队列的头部，如果有必要，直到指定的等待时间，元素才可用。
void clear() ：从队列中删除所有元素。
boolean contains(Object o) ：如果此队列包含指定的元素，则返回true。
Iterator iterator() ：以适当的顺序返回对该队列中的元素进行迭代的迭代器。
int size() ：返回此队列中的元素数。
int drainTo(Collection c) ：从此队列中删除所有可用元素，并将它们添加到给定的collection中。
intrainToTo（Collection c，int maxElements） ：从此队列中最多移除给定数量的可用元素，并将它们添加到给定的collection中。
int remainingCapacity() ：返回该队列理想情况下（在没有内存或资源限制的情况下）可以接受而不阻塞的其他元素的数量。
Object[] toArray() ：以适当的顺序返回一个包含此队列中所有元素的数组。
```

