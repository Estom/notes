## 准备知识
数据结构分为

* 线性数据结构
* 树型数据结构
* 图型数据结构


C++中的容器分为（都是线性的）
* 顺序容器
  * array 数组
  * vector向量
  * list 链表
* 关联容器
  * map 映射
  * set 集合
* 容器适配器
  * stack 栈
  * queue 队列


Java中的容器分为（都是线性的）
* 集合collection
  * List
  * Queue
  * Set
  * Map

![](image/2022-11-08-10-51-54.png)

![](image/2022-11-08-10-54-19.png)

![](image/2022-12-04-22-53-11.png)
## 体系

+   [Java 集合 - `List`](2.md)
    +   [`ArrayList`](3.md)
    +   [链表](47.md)
    +   [`Vector`](81.md)
+   [Java 集合 - `Set`](102.md)
    +   [`HashSet`](103.md)
    +   [`LinkedHashSet`](111.md)
    +   [`TreeSet`](114.md)
+   [Java 集合 - `Map`](117.md)
    +   [`HashMap`](118.md)
    +   [`TreeMap`](142.md)
    +   [`LinkedHashMap`](148.md)
+   [Java 集合 - `Iterator`/`ListIterator`](152.md)
+   [`Comparable`和`Comparator`接口](155.md)
+   [集合面试问题](158.md)


## 集合框架总览


1. 集合框架提供了两个遍历接口：`Iterator`和`ListIterator`，其中后者是前者的`优化版`，支持在任意一个位置进行**前后双向遍历**。注意图中的`Collection`应当继承的是`Iterable`而不是`Iterator`，后面会解释`Iterable`和`Iterator`的区别
2. 整个集合框架分为两个门派（类型）：`Collection`和`Map`，前者是一个容器，存储一系列的**对象**；后者是键值对`<key, value>`，存储一系列的**键值对**
3. 在集合框架体系下，衍生出四种具体的集合类型：`Map`、`Set`、`List`、`Queue`
4. `Map`存储`<key,value>`键值对，查找元素时通过`key`查找`value`
5. `Set`内部存储一系列**不可重复**的对象，且是一个**无序**集合，对象排列顺序不一
6. `List`内部存储一系列**可重复**的对象，是一个**有序**集合，对象按插入顺序排列
7. `Queue`是一个**队列**容器，其特性与`List`相同，但只能从`队头`和`队尾`操作元素
8. JDK 为集合的各种操作提供了两个工具类`Collections`和`Arrays`，之后会讲解工具类的常用方法
9. 四种抽象集合类型内部也会衍生出许多具有不同特性的集合类，**不同场景下择优使用，没有最佳的集合**