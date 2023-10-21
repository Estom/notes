- [泛型机制](#泛型机制)
  - [1 泛型概述](#1-泛型概述)
    - [基本概念](#基本概念)
    - [泛型的基本用法](#泛型的基本用法)
  - [2 优势](#2-优势)
    - [安全性](#安全性)
    - [消除强制转换](#消除强制转换)
    - [避免了不必要的装箱、拆箱操作，提高程序的性能](#避免了不必要的装箱拆箱操作提高程序的性能)
    - [提高了代码的重用行](#提高了代码的重用行)
  - [3 泛型的使用](#3-泛型的使用)
    - [泛型类](#泛型类)
    - [泛型接口](#泛型接口)
    - [泛型方法](#泛型方法)
  - [4 泛型通配符](#4-泛型通配符)
  - [5 泛型中的 KTVE](#5-泛型中的-ktve)
  - [6 泛型的实现原理](#6-泛型的实现原理)
  - [7 泛型实例化](#7-泛型实例化)
    - [反射](#反射)

# 泛型机制

> [Java 泛型详解](https://blog.csdn.net/ChenRui_yz/article/details/122935621)

## 1 泛型概述

> 父类构建泛化流程，子类重写特化方法
> 泛型构建泛化流程，实例重写特化方法
>
> 在那个大量使用泛型的类中，包含多个 泛型函数式接口，在实例化的时候，提供泛型类型和函数式接口的实现（本质上也是通过子类重写特化的方法）
>
> 1. 泛型提供编译时类型检查，使代码更加健壮。
> 2. 菱形语法允许在声明的时候指定类型，在定义的时候自动推断类型
> 3. 定义泛型，定义变量、创建对象、调用方法时动态指定类型参数，动态生成无数多个逻辑上的子类，但是这种子类在物理上斌不存在。数据形参和数据数据实参，泛型形参和泛型实参。
> 4. 在使用时，不同的泛型实参表示不同的类类型，泛型实参之间不支持继承关系，即泛型实参是子类型不能赋值给泛型形参是父类型的参数。但是不同泛型实参的对象使用getClass得到的结果是同一个类型。
> 4. 泛型与继承，泛型类的继承和实例化都必须指定泛型实参。如果不关注泛型实参类型，可以使用类型通配符?，并且可以指定类型通配符的上界和下界。

### 基本概念

Java 泛型（generics）是 JDK 5 中引入的一个新特性, 泛型提供了编译时类型安全检测机制，该机制允许程序员在编译时检测到非法的类型。

泛型的本质是参数化类型，即给类型指定一个参数，然后在使用时再指定此参数具体的值，那样这个类型就可以在使用时决定了。这种参数类型可以用在类、接口和方法中，分别被称为泛型类、泛型接口、泛型方法。

![](image/2022-07-11-22-24-04.png)

与 C#中的泛型相比，Java 的泛型可以算是“伪泛型”了。在 C#中，不论是在程序源码中、在编译后的中间语言，还是在运行期泛型都是真实存在的。Java 则不同，Java 的泛型只在源代码存在，只供编辑器检查使用，编译后的字节码文件已擦除了泛型类型，同时在必要的地方插入了强制转型的代码。

泛型的第一作用：起到约束和规范的作用，约束类型属于某一个，规范使用只能用某一种类型。可以让我们业务变得更加清晰和明了并得到了编译时期的语法检查。

泛型的第二作用：使用泛型的类型或者返回值的方法，自动进行数据类型转换。

泛型类、泛型方法、泛型接口提供的功能与泛型的类型无关。泛型至于输入输出的类型有关。

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

- 没有泛型的情况下使用集合：

```java
public static void noGeneric() {
ArrayList names = new ArrayList();
names.add("mikechen的互联网架构");
names.add(123); //编译正常
}
```

- 有泛型的情况下使用集合：

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

- 以下没有泛型的代码段需要强制转换：

```java
List list = new ArrayList();
list.add("hello");
String s = (String) list.get(0);
```

- 当重写为使用泛型时，代码不需要强制转换：

```java
List<String> list = new ArrayList<String>();
list.add("hello");
String s = list.get(0); // no cast
```

- [Java 泛型详解](https://www.cnblogs.com/Blue-Keroro/p/8875898.html)
- [10 道 Java 泛型面试题](https://cloud.tencent.com/developer/article/1033693)

### 避免了不必要的装箱、拆箱操作，提高程序的性能

在非泛型编程中，将简单类型作为 Object 传递时会引起 Boxing（装箱）和 Unboxing（拆箱）操作，这两个过程都是具有很大开销的。引入泛型后，就不必进行 Boxing 和 Unboxing 操作了，所以运行效率相对较高，特别在对集合操作非常频繁的系统中，这个特点带来的性能提升更加明显。

- 泛型变量固定了类型，使用的时候就已经知道是值类型还是引用类型，避免了不必要的装箱、拆箱操作。

```java
object a=1;//由于是object类型，会自动进行装箱操作。

int b=(int)a;//强制转换，拆箱操作。这样一去一来，当次数多了以后会影响程序的运行效率。
```

- 使用泛型之后

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

- 显而易见，能够通过泛型代替部分重载，大大提升了可用性。

## 3 泛型的使用

都是通过尖括号定义的

### 泛型类

- 定义泛型类，在类名后添加一对尖括号，并在尖括号中填写类型参数，参数可以有多个，多个参数使用逗号分隔：

```java
public class 类名 <泛型类型1,...> {}
public class GenericClass<ab,a,c> {}
```

- 实例代码

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

- **在创建对象的时候确定泛型**

例如，`ArrayList<String> list = new ArrayList<String>();`

此时，变量 E 的值就是 String 类型,那么我们的类型就可以理解为：

```java
class ArrayList<String>{
     public boolean add(String e){ }

     public String get(int index){  }
     ...
}
```

- 实例

举例自定义泛型类

```java
public class MyGenericClass<MVP> {
	//没有MVP类型，在这里代表 未知的一种数据类型 未来传递什么就是什么类型
	private MVP mvp;

    public void setMVP(MVP mvp) {
        this.mvp = mvp;
    }

    public MVP getMVP() {
        return mvp;
    }
}
```

使用:

```java
public class GenericClassDemo {
  	public static void main(String[] args) {
         // 创建一个泛型为String的类
         MyGenericClass<String> my = new MyGenericClass<String>();
         // 调用setMVP
         my.setMVP("大胡子哈登");
         // 调用getMVP
         String mvp = my.getMVP();
         System.out.println(mvp);
         //创建一个泛型为Integer的类
         MyGenericClass<Integer> my2 = new MyGenericClass<Integer>();
         my2.setMVP(123);
         Integer mvp2 = my2.getMVP();
    }
}
```

### 泛型接口

定义格式：

```
修饰符 interface接口名<代表泛型的变量> {  }
```

例如，

```java
public interface MyGenericInterface<E>{
	public abstract void add(E e);

	public abstract E getE();
}
```

使用格式：

**1、定义类时确定泛型的类型**

例如

```java
public class MyImp1 implements MyGenericInterface<String> {
	@Override
    public void add(String e) {
        // 省略...
    }

	@Override
	public String getE() {
		return null;
	}
}
```

此时，泛型 E 的值就是 String 类型。

**2、始终不确定泛型的类型，直到创建对象时，确定泛型的类型**

例如

```java
public class MyImp2<E> implements MyGenericInterface<E> {
	@Override
	public void add(E e) {
       	 // 省略...
	}

	@Override
	public E getE() {
		return null;
	}
}
```

确定泛型：

```java
/*
 * 使用
 */
public class GenericInterface {
    public static void main(String[] args) {
        MyImp2<String>  my = new MyImp2<String>();
        my.add("aa");
    }
}
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

- 使用格式：**调用方法时，确定泛型的类型**

```java
public class GenericMethodDemo {
    public static void main(String[] args) {
        // 创建对象
        MyGenericMethod mm = new MyGenericMethod();
        // 演示看方法提示
        mm.show("aaa");
        mm.show(123);
        mm.show(12.45);
    }
}
```

## 4 泛型通配符

Java 泛型的通配符是用于解决泛型之间引用传递问题的特殊语法。泛型与继承之间的关系

1. 无边界通配符<?>
   1. 无边界的通配符的主要作用就是让泛型能够接受未知类型的数据.
2. 固定上边界的通配符<? extends E>
   1. 使用固定上边界的通配符的泛型, 就能够接受指定类及其子类类型的数据。
   2. 要声明使用该类通配符, 采用<? extends E>的形式, 这里的 E 就是该泛型的上边界。
   3. 注意: 这里虽然用的是 extends 关键字, 却不仅限于继承了父类 E 的子类, 也可以代指显现了接口 E 的类
3. 固定下边界的通配符<? super E>
   1. 使用固定下边界的通配符的泛型, 就能够接受指定类及其父类类型的数据.。
   2. 要声明使用该类通配符, 采用<? super E>的形式, 这里的 E 就是该泛型的下边界.。
   3. 注意: 你可以为一个泛型指定上边界或下边界, 但是不能同时指定上下边界。

```java
//表示类型参数可以是任何类型
public class Apple<?>{}

//表示类型参数必须是A或者是A的子类
public class Apple<T extends A>{}

//表示类型参数必须是A或者是A的超类型
public class Apple<T supers A>{}
```

## 5 泛型中的 KTVE

泛型中的规范

- T：任意类型 type
- E：集合中元素的类型 element
- K：key-value 形式 key
- V： key-value 形式 value
- N： Number（数值类型）
- ？： 表示不确定的 java 类型

## 6 泛型的实现原理

泛型本质是将数据类型参数化，它通过擦除的方式来实现，即编译器会在编译期间「擦除」泛型语法并相应的做出一些类型转换动作。

实际上编译器会正常的将使用泛型的地方编译并进行类型擦除，然后返回实例。但是除此之外的是，如果构建泛型实例时使用了泛型语法，那么编译器将标记该实例并关注该实例后续所有方法的调用，每次调用前都进行安全检查，非指定类型的方法都不能调用成功。

实际上编译器不仅关注一个泛型方法的调用，它还会为某些返回值为限定的泛型类型的方法进行强制类型转换，由于类型擦除，返回值为泛型类型的方法都会擦除成 Object 类型，当这些方法被调用后，编译器会额外插入一行 checkcast 指令用于强制类型转换，这一个过程就叫做『泛型翻译』。


## 7 泛型实例化


### 反射
```java
getClass().getGenericSuperclass()).getActualTypeArguments()[0].newInstance();



   public void init(){

      try {
         Type[] typeArguments = ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments();
         for(Type type : typeArguments){
            System.out.println("type:"+type);//打印映射的实际类
         }
         Class<T> tClass = (Class<T>) typeArguments[0];
         Class<D> dClass = (Class<D>) typeArguments[1];
         Class<E> cClass = (Class<E>) typeArguments[2];
         this.t = tClass.newInstance();
         this.d = dClass.newInstance();
         this.e = cClass.newInstance();
      } catch ( Exception e) {
         e.printStackTrace();
      }
   }

```


```java
getConstructor().newInstance()

public void init(){

      try {
         Type[] typeArguments = ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments();
         for(Type type : typeArguments){
            System.out.println("type:"+type);
         }
         T e = (T) ((Class)typeArguments[0]).getConstructor().newInstance();
         D e = (D) ((Class)typeArguments[1]).getConstructor().newInstance();
         E e = (E) ((Class)typeArguments[2]).getConstructor().newInstance();
      } catch ( Exception e) {
         e.printStackTrace();
      }
   }
```


```java
Class.forName(className).newInstance()

   public void init(){

      try {
         Type[] typeArguments = ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments();
         for(Type type : typeArguments){
            System.out.println("type:"+type);//打印映射的实际类
         }
         T t = (T) Class.forName(typeArguments[0].getTypeName()).newInstance();
         D d = (D) Class.forName(typeArguments[1].getTypeName()).newInstance();
         E e = (E) Class.forName(typeArguments[2].getTypeName()).newInstance();
      } catch ( Exception e) {
         e.printStackTrace();
      }
   }

```