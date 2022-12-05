# static

## 1 静态变量

- 静态变量：又称为类变量，也就是说这个变量属于类的，类所有的实例都共享静态变量，可以直接通过类名来访问它。静态变量在内存中只存在一份。
- 实例变量：每创建一个实例就会产生一个实例变量，它与该实例同生共死。
- static变量也称作静态变量，静态变量和非静态变量的区别是：静态变量被所有的对象所共享，在内存中只有一个副本，它当且仅当在类初次加载时会被初始化。而非静态变量是对象所拥有的，在创建对象的时候被初始化，存在多个副本，各个对象拥有的副本互不影响。static成员变量的初始化顺序按照定义的顺序进行初始化。所以我们一般在这两种情况下使用静态变量：对象之间共享数据、访问方便。


```java
public class A {

    private int x;         // 实例变量
    private static int y;  // 静态变量

    public static void main(String[] args) {
        // int x = A.x;  // Non-static field 'x' cannot be referenced from a static context
        A a = new A();
        int x = a.x;
        int y = A.y;
    }
}
```

## 2 静态方法

静态方法在类加载的时候就存在了，它不依赖于任何实例。所以静态方法必须有实现，也就是说它不能是抽象方法。


```java
public abstract class A {
    public static void func1(){
    }
    // public abstract static void func2();  // Illegal combination of modifiers: 'abstract' and 'static'
}
```

只能访问所属类的静态字段和静态方法，方法中不能有 this 和 super 关键字，因为这两个关键字与具体对象关联。

```java
public class A {

    private static int x;
    private int y;

    public static void func1(){
        int a = x;
        // int b = y;  // Non-static field 'y' cannot be referenced from a static context
        // int b = this.y;     // 'A.this' cannot be referenced from a static context
    }
}
```

## 3 静态语句块

静态语句块在类初始化时运行一次。

```java
public class A {
    static {
        System.out.println("123");
    }

    public static void main(String[] args) {
        A a1 = new A();
        A a2 = new A();
    }
}
```

```html
123
```

## 4 静态内部类

非静态内部类依赖于外部类的实例，也就是说需要先创建外部类实例，才能用这个实例去创建非静态内部类。而静态内部类不需要。

```java
public class OuterClass {

    class InnerClass {
    }

    static class StaticInnerClass {
    }

    public static void main(String[] args) {
        // InnerClass innerClass = new InnerClass(); // 'OuterClass.this' cannot be referenced from a static context
        OuterClass outerClass = new OuterClass();
        InnerClass innerClass = outerClass.new InnerClass();
        StaticInnerClass staticInnerClass = new StaticInnerClass();
    }
}
```

静态内部类不能访问外部类的非静态的变量和方法。

　　内部类一般情况下使用不是特别多，如果需要在外部类里面定义一个内部类，通常是基于外部类和内部类有很强关联的前提下才去这么使用。

  　　在说静态内部类的使用场景之前，我们先来看一下静态内部类和非静态内部类的区别：

  　　**非静态内部类对象持有外部类对象的引用（编译器会隐式地将外部类对象的引用作为内部类的构造器参数）；而静态内部类对象不会持有外部类对象的引用**

  　　由于非静态内部类的实例创建需要有外部类对象的引用，所以非静态内部类对象的创建必须依托于外部类的实例；而静态内部类的实例创建只需依托外部类；

  　　并且由于非静态内部类对象持有了外部类对象的引用，因此非静态内部类可以访问外部类的非静态成员；而静态内部类只能访问外部类的静态成员；

   

  　　两者的根本性区别其实也决定了用static去修饰内部类的真正意图：

  - 内部类需要脱离外部类对象来创建实例
  - 避免内部类使用过程中出现内存溢出

  　　

  第一种是目前静态内部类使用比较多的场景，比如JDK集合中的Entry、builder设计模式。

　　HashMap Entry：

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200518164800.png)

　　builder设计模式：

```java
public class Person {
    private String name;
    private int age;
 
    private Person(Builder builder) {
        this.name = builder.name;
        this.age = builder.age;
    }
 
    public static class Builder {
 
        private String name;
        private int age;
 
        public Builder() {
        }
 
        public Builder name(String name) {
            this.name = name;
            return this;
        }
        public Builder age(int age) {
            this.age=age;
            return this;
        }
 
        public Person build() {
            return new Person(this);
        }
    }
 
    public String getName() {
        return name;
    }
 
    public void setName(String name) {
        this.name = name;
    }
 
    public int getAge() {
        return age;
    }
 
    public void setAge(int age) {
        this.age = age;
    }
}
 
// 在需要创建Person对象的时候
Person person = new Person.Builder().name("张三").age(17).build();
```

第二种情况一般出现在多线程场景下，非静态内部类可能会引发内存溢出的问题，比如下面的例子：

```java
public class Task {
 
    public void onCreate() {
        // 匿名内部类, 会持有Task实例的引用
        new Thread() {
            public void run() {
                //...耗时操作
            };
        }.start();   
    }
}
```

　上面这段代码中的：

```java
new Thread() {
  public void run() {
  //...耗时操作
  };
}.start();
```

　　声明并创建了一个匿名内部类对象，该对象持有外部类Task实例的引用，如果在在run方法中做的是耗时操作，将会导致外部类Task的实例迟迟不能被回收，如果Task对象创建过多，会引发内存溢出。

​	优化方式：

```java
public class Task {
 
    public void onCreate() {
        SubTask subTask = new SubTask();
        subTask.start();
    }
     
    static class SubTask extends Thread {
        @Override
        public void run() {
            //...耗时操作   
        }
         
    }
}
```

## 5 静态导包

在使用静态变量和方法时不用再指明 ClassName，从而简化代码，但可读性大大降低。

```java
import static com.xxx.ClassName.*
```

## 6 初始化顺序

静态变量和静态语句块优先于实例变量和普通语句块，静态变量和静态语句块的初始化顺序取决于它们在代码中的顺序。

```java
public static String staticField = "静态变量";
```

```java
static {
    System.out.println("静态语句块");
}
```

```java
public String field = "实例变量";
```

```java
{
    System.out.println("普通语句块");
}
```

最后才是构造函数的初始化。

```java
public InitialOrderTest() {
    System.out.println("构造函数");
}
```

存在继承的情况下，初始化顺序为：

- 父类（静态变量、静态语句块）
- 子类（静态变量、静态语句块）
- 父类（实例变量、普通语句块）
- 父类（构造函数）
- 子类（实例变量、普通语句块）
- 子类（构造函数）