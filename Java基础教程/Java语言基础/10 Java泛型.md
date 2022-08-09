> [Java 泛型详解](https://blog.csdn.net/ChenRui_yz/article/details/122935621)
## 1 泛型概述

### 基本概念

Java 泛型（generics）是 JDK 5 中引入的一个新特性, 泛型提供了编译时类型安全检测机制，该机制允许程序员在编译时检测到非法的类型。

泛型的本质是参数化类型，即给类型指定一个参数，然后在使用时再指定此参数具体的值，那样这个类型就可以在使用时决定了。这种参数类型可以用在类、接口和方法中，分别被称为泛型类、泛型接口、泛型方法。

![](image/2022-07-11-22-24-04.png)


### 泛型的基本用法

```java
public class Box<T> {
    // T stands for "Type"
    private T t;
    public void set(T t) { this.t = t; }
    public T get() { return t; }
}
```

## 2 优势
1. 安全性？
2. 消除转换？
3. 提升性能？
4. 重用行。不同类型不需要重载。泛型本质上也是一种编译时多态。

### 安全性
在没有泛型之前，从集合中读取到的每一个对象都必须进行类型转换，如果不小心插入了错误的类型对象，在运行时的转换处理就会出错。

* 没有泛型的情况下使用集合：
```java
public static void noGeneric() {
ArrayList names = new ArrayList();
names.add("mikechen的互联网架构");
names.add(123); //编译正常
}
```
* 有泛型的情况下使用集合：
```java
public static void useGeneric() {
ArrayList<String> names = new ArrayList<>();
names.add("mikechen的互联网架构");
names.add(123); //编译不通过
}
```
相当于告诉编译器每个集合接收的对象类型是什么，编译器在编译期就会做类型检查，告知是否插入了错误类型的对象，使得程序更加安全，增强了程序的健壮性。


### 消除强制转换
泛型的一个附带好处是，消除源代码中的许多强制类型转换，这使得代码更加可读，并且减少了出错机会。


* 以下没有泛型的代码段需要强制转换：
```java
List list = new ArrayList();
list.add("hello");
String s = (String) list.get(0);
```
* 当重写为使用泛型时，代码不需要强制转换：
```java
List<String> list = new ArrayList<String>();
list.add("hello");
String s = list.get(0); // no cast
```

- [Java 泛型详解](https://www.cnblogs.com/Blue-Keroro/p/8875898.html)
- [10 道 Java 泛型面试题](https://cloud.tencent.com/developer/article/1033693)

### 避免了不必要的装箱、拆箱操作，提高程序的性能

在非泛型编程中，将简单类型作为Object传递时会引起Boxing（装箱）和Unboxing（拆箱）操作，这两个过程都是具有很大开销的。引入泛型后，就不必进行Boxing和Unboxing操作了，所以运行效率相对较高，特别在对集合操作非常频繁的系统中，这个特点带来的性能提升更加明显。

* 泛型变量固定了类型，使用的时候就已经知道是值类型还是引用类型，避免了不必要的装箱、拆箱操作。
```java
object a=1;//由于是object类型，会自动进行装箱操作。
 
int b=(int)a;//强制转换，拆箱操作。这样一去一来，当次数多了以后会影响程序的运行效率。
```
* 使用泛型之后
```java
public static T GetValue<T>(T a)
 
{
　　return a;
}
 
public static void Main()
 
{
　　int b=GetValue<int>(1);//使用这个方法的时候已经指定了类型是int，所以不会有装箱和拆箱的操作。
}
```

### 提高了代码的重用行
> 省略

## 3 泛型的使用

### 泛型类
* 定义泛型类，在类名后添加一对尖括号，并在尖括号中填写类型参数，参数可以有多个，多个参数使用逗号分隔：
```java
public class 类名 <泛型类型1,...> {}
public class GenericClass<ab,a,c> {}
```

* 实例代码

```java
public class GenericClass<T> {
    private T value;
 
 
    public GenericClass(T value) {
        this.value = value;
    }
    public T getValue() {
        return value;
    }
    public void setValue(T value) {
        this.value = value;
    }
}
```
### 泛型接口

```java
public interface GenericInterface<T> {
void show(T value);
}

public class StringShowImpl implements GenericInterface<String> {
@Override
public void show(String value) {
System.out.println(value);
}}
 
public class NumberShowImpl implements GenericInterface<Integer> {
@Override
public void show(Integer value) {
System.out.println(value);
}}
```


### 泛型方法

```java
修饰符 <代表泛型的变量> 返回值类型 方法名(参数){ }

/**
*
* @param t 传入泛型的参数
* @param <T> 泛型的类型
* @return T 返回值为T类型
* 说明：
*   1）public 与 返回值中间<T>非常重要，可以理解为声明此方法为泛型方法。
*   2）只有声明了<T>的方法才是泛型方法，泛型类中的使用了泛型的成员方法并不是泛型方法。
*   3）<T>表明该方法将使用泛型类型T，此时才可以在方法中使用泛型类型T。
*   4）与泛型类的定义一样，此处T可以随便写为任意标识，常见的如T、E等形式的参数常用于表示泛型。
*/
public <T> T genercMethod(T t){
System.out.println(t.getClass());
System.out.println(t);
return t;
}
```

## 4 泛型通配符

Java泛型的通配符是用于解决泛型之间引用传递问题的特殊语法。泛型与继承之间的关系
1. 无边界通配符<?>
   1. 无边界的通配符的主要作用就是让泛型能够接受未知类型的数据.
2. 固定上边界的通配符<? extends E>
   1. 使用固定上边界的通配符的泛型, 就能够接受指定类及其子类类型的数据。
   2. 要声明使用该类通配符, 采用<? extends E>的形式, 这里的E就是该泛型的上边界。
   3. 注意: 这里虽然用的是extends关键字, 却不仅限于继承了父类E的子类, 也可以代指显现了接口E的类
3. 固定下边界的通配符<? super E>
   1. 使用固定下边界的通配符的泛型, 就能够接受指定类及其父类类型的数据.。
   2. 要声明使用该类通配符, 采用<? super E>的形式, 这里的E就是该泛型的下边界.。
   3. 注意: 你可以为一个泛型指定上边界或下边界, 但是不能同时指定上下边界。
```java
//表示类型参数可以是任何类型
public class Apple<?>{}
 
//表示类型参数必须是A或者是A的子类
public class Apple<T extends A>{}
 
//表示类型参数必须是A或者是A的超类型
public class Apple<T supers A>{}
```

## 5 泛型中的KTVE

泛型中的规范
* T：任意类型 type
* E：集合中元素的类型 element
* K：key-value形式 key
* V： key-value形式 value
* N： Number（数值类型）
* ？： 表示不确定的java类型


## 6 泛型的实现原理

泛型本质是将数据类型参数化，它通过擦除的方式来实现，即编译器会在编译期间「擦除」泛型语法并相应的做出一些类型转换动作。

实际上编译器会正常的将使用泛型的地方编译并进行类型擦除，然后返回实例。但是除此之外的是，如果构建泛型实例时使用了泛型语法，那么编译器将标记该实例并关注该实例后续所有方法的调用，每次调用前都进行安全检查，非指定类型的方法都不能调用成功。

实际上编译器不仅关注一个泛型方法的调用，它还会为某些返回值为限定的泛型类型的方法进行强制类型转换，由于类型擦除，返回值为泛型类型的方法都会擦除成 Object 类型，当这些方法被调用后，编译器会额外插入一行 checkcast 指令用于强制类型转换，这一个过程就叫做『泛型翻译』。