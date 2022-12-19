# Iterator  Iterable ListIterator

## 1 Iterator
所有Java集合类都提供iterator()方法，该方法返回Iterator的实例以遍历该集合中的元素。

```java
public interface Iterator<E> {
    boolean hasNext();
    E next();
    void remove();
}
```

提供的API接口含义如下：

- `hasNext()`：判断集合中是否存在下一个对象
- `next()`：返回集合中的下一个对象，并将访问指针移动一位
- `remove()`：删除集合中调用`next()`方法返回的对象.每次调用next（）只能调用一次此方法。

在早期，遍历集合的方式只有一种，通过`Iterator`迭代器操作

```java
List<Integer> list = new ArrayList<>();
list.add(1);
list.add(2);
list.add(3);
Iterator iter = list.iterator();
while (iter.hasNext()) {
    Integer next = iter.next();
    System.out.println(next);
    if (next == 2) { iter.remove(); }
}
```




## 2 `Iterable`

```java
public interface Iterable<T> {
    Iterator<T> iterator();
    // JDK 1.8
    default void forEach(Consumer<? super T> action) {
        Objects.requireNonNull(action);
        for (T t : this) {
            action.accept(t);
        }
    }
}
```

可以看到`Iterable`接口里面提供了`Iterator`接口，所以实现了`Iterable`接口的集合依旧可以使用`迭代器`遍历和操作集合中的对象；

而在 `JDK 1.8`中，`Iterable`提供了一个新的方法`forEach()`，它允许使用增强 for 循环遍历对象。

```java
List<Integer> list = new ArrayList<>();
for (Integer num : list) {
    System.out.println(num);
}
```

我们通过命令：`javap -c`反编译上面的这段代码后，发现它只是 Java 中的一个`语法糖`，本质上还是调用`Iterator`去遍历。

![](image/2022-12-15-21-53-10.png)

翻译成代码，就和一开始的`Iterator`迭代器遍历方式基本相同了。

```java
Iterator iter = list.iterator();
while (iter.hasNext()) {
    Integer num = iter.next();
    System.out.println(num);
}
```

> 还有更深层次的探讨：为什么要设计两个接口`Iterable`和`Iterator`，而不是保留其中一个就可以了。
>
> 简单讲解：`Iterator`的保留可以让子类去**实现自己的迭代器**，而`Iterable`接口更加关注于`for-each`的增强语法。具体可参考：[Java中的Iterable与Iterator详解](https://www.cnblogs.com/litexy/p/9744241.html)

## 3 Iterator 和Iterable

关于`Iterator`和`Iterable`的讲解告一段落，下面来总结一下它们的重点：

1. `Iterator`是提供集合操作内部对象的一个迭代器，它可以**遍历、移除**对象，且只能够**单向移动**
2. `Iterable`是对`Iterator`的封装，在`JDK 1.8`时，实现了`Iterable`接口的集合可以使用**增强 for 循环**遍历集合对象，我们通过**反编译**后发现底层还是使用`Iterator`迭代器进行遍历

等等，这一章还没完，还有一个`ListIterator`。它继承 Iterator 接口，在遍历`List`集合时可以从**任意索引下标**开始遍历，而且支持**双向遍历**。

ListIterator 存在于 List 集合之中，通过调用方法可以返回**起始下标**为 `index`的迭代器

```java
List<Integer> list = new ArrayList<>();
// 返回下标为0的迭代器
ListIterator<Integer> listIter1 = list.listIterator(); 
// 返回下标为5的迭代器
ListIterator<Integer> listIter2 = list.listIterator(5); 
```

ListIterator 中有几个重要方法，大多数方法与 Iterator 中定义的含义相同，但是比 Iterator 强大的地方是可以在**任意一个下标位置**返回该迭代器，且可以实现**双向遍历**。

```java
public interface ListIterator<E> extends Iterator<E> {
    boolean hasNext();
    E next();
    boolean hasPrevious();
    E previous();
    int nextIndex();
    int previousIndex();
    void remove();
    // 替换当前下标的元素,即访问过的最后一个元素
    void set(E e);
    void add(E e);
}
```


## 4 ListIterator
### 简介
* ListIterator支持在元素列表上的所有CRUD操作（CREATE，READ，UPDATE和DELETE）。
* 与Iterator不同，ListIterator是bi-directional 。 它支持正向和反向迭代。
* 它没有当前元素； 它的光标位置始终位于通过调用previous（）返回的元素和通过调用next（）返回的元素之间。

### 实例

```java
ArrayList<String> list = new ArrayList<>();
         
list.add("A");
list.add("B");
list.add("C");
list.add("D");
list.add("E");
list.add("F");
 
ListIterator<String> listIterator = list.listIterator();
 
System.out.println("Forward iteration");
 
//Forward iterator
while(listIterator.hasNext()) {
    System.out.print(listIterator.next() + ",");
}
 
System.out.println("Backward iteration");
 
//Backward iterator
while(listIterator.hasPrevious()) {
    System.out.print(listIterator.previous() + ",");
}
 
System.out.println("Iteration from specified position");
         
//Start iterating from index 2
listIterator = list.listIterator(2);
 
while(listIterator.hasNext()) {
    System.out.print(listIterator.next() + ",");
```


### 主要方法

```java
void add(Object o) ：将指定的元素插入列表（可选操作）。
boolean hasNext() ：如果在向前遍历列表时此列表迭代器包含更多元素，则返回true 。
boolean hasPrevious() ：如果在反向遍历列表时此列表迭代器包含更多元素，则返回true 。
Object next() ：返回列表中的下一个元素并前进光标位置。
int nextIndex() ：返回元素的索引，该元素的索引将由对next（）的后续调用返回。
Object previous() ：返回列表中的上一个元素，并将光标位置向后移动。
int previousIndex() ：返回元素的索引，该元素的索引将由对next（）的后续调用返回。
void remove() ：从列表中移除next（）或previous（）返回的最后一个元素（可选操作）。
void set(Object o) ：将next（）或previous（）返回的最后一个元素替换为指定的元素（可选操作）。
```
