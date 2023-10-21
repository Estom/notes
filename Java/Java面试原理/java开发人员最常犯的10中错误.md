

---

[TOC]

---

# 一、把数组转成ArrayList

为了将数组转换为ArrayList，开发者经常会这样做：
~~~java
List<String> list = Arrays.asList(arr);
~~~
使用Arrays.asList()方法可以得到一个ArrayList，但是得到这个ArrayList其实是定义在Arrays类中的一个私有的静态内部类。这个类虽然和java.util.ArrayList同名，但是并不是同一个类。java.util.Arrays.ArrayList类中实现了set(), get(), contains()等方法，但是并没有定义向其中增加元素的方法。也就是说通过Arrays.asList()得到的ArrayList的大小是固定的。

如果在开发过程中，想得到一个真正的ArrayList对象（java.util.ArrayList的实例），可以通过以下方式：
~~~java
ArrayList<String> arrayList = new ArrayList<String>(Arrays.asList(arr));
~~~
java.util.ArrayList中包含一个可以接受集合类型参数的构造函数。因为java.util.Arrays.ArrayList这个内部类继承了AbstractList类，所以，该类也是Collection的子类。

# 二、判断一个数组是否包含某个值
在判断一个数组中是否包含某个值的时候，开发者经常这样做：
~~~java
Set<String> set = new HashSet<String>(Arrays.asList(arr));
return set.contains(targetValue);
~~~
在在Java中如何高效的判断数组中是否包含某个元素一文中，深入分析过，以上方式虽然可以实现功能，但是效率却比较低。因为将数组压入Collection类型中，首先要将数组元素遍历一遍，然后再使用集合类做其他操作。

在判断一个数组是否包含某个值的时候，推荐使用for循环遍历的形式或者使用Apache Commons类库中提供的ArrayUtils类的contains方法。

三、在循环中删除列表中的元素
在讨论这个问题之前，先考虑以下代码的输出结果：
~~~java
ArrayList<String> list = new ArrayList<String>(Arrays.asList("a","b","c","d"));
for(int i=0;i<list.size();i++){
    list.remove(i);
}
System.out.println(list);
~~~
~~~
输出结果：

[b,d]
~~~
以上代码的目的是想遍历删除list中所有元素，但是结果却没有成功。原因是忽略了一个关键的问题：当一个元素被删除时，列表的大小缩小并且下标也会随之变化，所以当你想要在一个循环中用下标删除多个元素的时候，它并不会正常的生效。

也有些人知道以上代码的问题就由于数组下标变换引起的。所以，他们想到使用增强for循环的形式：
~~~java
ArrayList<String> list = new ArrayList<String>(Arrays.asList("a","b","c","d"));
for(String s:list){
    if(s.equals("a")){
        list.remove(s);
    }
}
~~~
但是，很不幸的是，以上代码会抛出ConcurrentModificationException，有趣的是，如果在remove操作后增加一个break，代码就不会报错：
~~~java
ArrayList<String> list = new ArrayList<String>(Arrays.asList("a","b","c","d"));
for(String s:list){
    if(s.equals("a")){
        list.remove(s);
        break;
    }
}
~~~
在Java中的fail-fast机制一文中，深入分析了几种在遍历数组的同时删除其中元素的方法以及各种方法存在的问题。其中就介绍了上面的代码出错的原因。

迭代器（Iterator）是工作在一个独立的线程中，并且拥有一个 mutex 锁。 迭代器被创建之后会建立一个指向原来对象的单链索引表，当原来的对象数量发生变化时，这个索引表的内容不会同步改变，所以当索引指针往后移动的时候就找不到要迭代的对象，所以按照 fail-fast 原则 迭代器会马上抛出java.util.ConcurrentModificationException 异常。

所以，正确的在遍历过程中删除元素的方法应该是使用Iterator：
~~~java
ArrayList<String> list = new ArrayList<String>(Arrays.asList("a", "b", "c", "d"));
Iterator<String> iter = list.iterator();
while (iter.hasNext()) {
    String s = iter.next();

    if (s.equals("a")) {
        iter.remove();
    }
}
~~~
next()方法必须在调用remove()方法之前调用。如果在循环过程中先调用remove()，再调用next()，就会导致异常ConcurrentModificationException。原因如上。

# 四、HashTable 和 HashMap 的选择
了解算法的人可能对HashTable比较熟悉，因为他是一个数据结构的名字。但在Java里边，用HashMap来表示这样的数据结构。Hashtable和 HashMap的一个关键性的不同是，HashTable是同步的，而HashMap不是。所以通常不需要HashTable，HashMap用的更多。

HashMap完全解读、Java中常见亲属比较等文章中介绍了他们的区别和如何选择。

# 五、使用原始集合类型
在Java里边，原始类型和无界通配符类型很容易混合在一起。以Set为例，Set是一个原始类型，而Set< ? >是一个无界通配符类型。 （可以把原始类型理解为没有使用泛型约束的类型）

考虑下面使用原始类型List作为参数的代码：
~~~java
public static void add(List list, Object o){
    list.add(o);
}
public static void main(String[] args){
    List<String> list = new ArrayList<String>();
    add(list, 10);
    String s = list.get(0);
}
~~~
上面的代码将会抛出异常：

java.lang.ClassCastException: java.lang.Integer cannot be cast to java.lang.String

使用原始集合类型是很危险的，因为原始集合类型跳过了泛型类型检查，是不安全的。Set、Set< ? >和Set< Object >之间有很大差别。关于泛型，可以参考下列文章：《成神之路-基础篇》Java基础知识——泛型

# 六、访问级别
程序员们经常使用public作为类中的字段的修饰符，因为这样可以很简单的通过引用得到值，但这并不是好的设计，按照经验，分配给成员变量的访问级别应该尽可能的低。参考Java中的四种访问级别

# 七、ArrayList与LinkedList的选择
当程序员们不知道ArrayList与LinkedList的区别时，他们经常使用ArrayList，因为它看起来比较熟悉。然而，它们之前有巨大的性能差别。在ArrayList vs LinkedList vs Vector 区别、Java中常见亲属比较等文章中介绍过，简而言之，如果有大量的增加删除操作并且没有很多的随机访问元素的操作，应该首先LinkedList。（LinkedList更适合从中间插入或者删除（链表的特性））

# 八、可变与不可变
在为什么Java要把字符串设计成不可变的一文中介绍过，不可变对象有许多的优点，比如简单，安全等等。同时，也有人提出疑问：既然不可变有这么多好处，为什么不把所有类都搞成不可变的呢？

通常情况下，可变对象可以用来避免产生过多的中间对象。一个经典的实例就是连接大量的字符串，如果使用不可变的字符串，将会产生大量的需要进行垃圾回收的对象。这会浪费CPU大量的时间，使用可变对象才是正确的方案(比如StringBuilder)。
~~~java
String result="";
for(String s: arr){
    result = result + s;
}
~~~
StackOverflow中也有关于这个的讨论。

# 九、父类和子类的构造函数
上图的代码中有两处编译时错误，原因其实很简单，主要和构造函数有关。首先，我们都知道：

如果一个类没有定义构造函数，编译器将会插入一个无参数的默认构造函数。

如果一个类中定义了一个带参数的构造函数，那么编译器就不会再帮我们创建无参的构造函数。

上面的Super类中定义了一个带参数的构造函数。编译器将不会插入默认的无参数构造函数。

我们还应该知道：

子类的所有构造函数（无论是有参还是无参）在执行时，都会调用父类的无参构造函数。

所以，编译器试图调用Super类中的无参构造函数。但是父类默认的构造函数未定义，编译器就会报出这个错误信息。

要解决这个问题，可以简单的通过

1)在父类中添加一个Super()构造方法，就像这样：
~~~java
public Super(){}
~~~
2)移除自定义的父类构造函数

3)在子类的构造函数中调用父类的super(value)。

# 十、" "还是构造函数
关于这个问题，也是程序员经常出现困惑的地方，在该如何创建字符串，使用" "还是构造函数？中也介绍过.

如果你只需要创建一个字符串，你可以使用双引号的方式，如果你需要在堆中创建一个新的对象，你可以选择构造函数的方式。

在**String d = new String("abcd")**时，因为字面值"abcd"已经是字符串类型，那么使用构造函数方式只会创建一个额外没有用处的对象。