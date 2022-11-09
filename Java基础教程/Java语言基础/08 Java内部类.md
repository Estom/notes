- [Java 内部类](#java-内部类)
	- [1 概述](#1-概述)
		- [基本概念](#基本概念)
		- [基本作用](#基本作用)
	- [2 使用](#2-使用)
		- [成员内部类](#成员内部类)
		- [静态内部类](#静态内部类)
		- [局部内部类](#局部内部类)
		- [匿名内部类](#匿名内部类)
		- [一次输出ABC的答案](#一次输出abc的答案)
		- [重名变量的引用](#重名变量的引用)
	- [3 原理](#3-原理)
		- [成员内部类无条件访问外部类的私有变量](#成员内部类无条件访问外部类的私有变量)
		- [局部内部类和匿名内部类只能访问局部final变量](#局部内部类和匿名内部类只能访问局部final变量)
		- [静态内部类有特殊的地方吗？](#静态内部类有特殊的地方吗)
	- [4 常见的与内部类相关的笔试面试题](#4-常见的与内部类相关的笔试面试题)
		- [根据注释填写(1)，(2)，(3)处的代码](#根据注释填写123处的代码)
		- [下面这段代码的输出结果是什么？](#下面这段代码的输出结果是什么)
# Java 内部类

## 1 概述

### 基本概念

内部类就是在一个类的内部定义一个类。

* 成员内部类
* 静态内部类
* 局部内部类
* 匿名内部类


### 基本作用

* 每个内部类都能独立的继承一个接口的实现，所以无论外部类是否已经继承了某个(接口的)实现，对于内部类都没有影响。内部类使得多继承的解决方案变得完整。
* 方便将存在一定逻辑关系的类组织在一起，又可以对外界隐藏。
* 方便编写事件驱动程序。
* 方便编写线程代码。


## 2 使用

```java

import java.lang.Thread;
 /**
  * AnonymousClass
  */
 public class AnonymousClass {
 
    private int a;

    public static void main(String[] args){
        new AnonymousClass().test(2);
        // 成员内部类需要创建对象
        AnonymousClass ac =  new AnonymousClass();
        ac.new Inner().getName();
        //静态内部类可以直接访问
        new AnonymousClass.StaticInner().getName();
    }

    public class Inner{
        public void getName(){
            System.out.println("成员内部类");
        }
    }

    public static class StaticInner{
        public void getName(){
            System.out.println("静态内部类");
        }
    } 

    //事实证明匿名内部类必须访问final类型的变量，或者事实上final类型的变量。
    public void test(final int a){
        int b =10;
        int c =11;
        new Thread(){
            public void run() {
                System.out.println(a);
                System.out.println(b);
            }
        }.start();
        // b = 12;
        System.out.print(b);
    }

 }
```
### 成员内部类

在类的内部方法的外部编写的类就是成员内部类。


* 成员内部类可以无条件访问外部类的所有成员属性和成员方法（包括private成员和静态成员）。
*  成员内部类可以使用四种权限修饰符进行修饰。成员内部类中不能书写静态变量和方法
* 同名属性名方法名时访问外部类 外部类.this.成员名。
* 成员内部类是依附外部类而存在的，也就是说，如果要创建成员内部类的对象，前提是必须存在一个外部类的对象。所以在外部类访问内部类的时候必须先实例化外部类对象。

```java
public class MemberDemo {
	String name = "王五";
	static int age = 10;
	
	public static void show() {
		System.out.println("掉用外部类中的show方法");
		
	}
	
	public void printf() {
		System.out.println("调用外部类中的打印方法");
	}
	
	//成员内部类 可以使用权限修饰符进行修饰
	public class Inner{
		//static double height=1.8;  成员内部类中不能使用static修饰变量和方法
		
		String name="张三";
		//成员内部类可以直接访问外部类的属性和方法
		public void innerShow() {
			show();
			printf();
			System.out.println(age);
			System.out.println("我是："+name);
			System.out.println("我是："+MemberDemo.this.name);//进行特指访问时 使用类名.this.变量名进行访问
		}
	}
	
	
	public static void main(String[] args) {
		//成员内部类对象的创建步骤
		//第一步需要实例化外部类对象
		//第二步正常实例化内部类对象 但是new关键字要改成 外部类对象名.new
		MemberDemo member = new MemberDemo();
		Inner ineer = member.new Inner();
		ineer.innerShow();
	} 
	
}
```

### 静态内部类
在类中编写的以static修饰的类称为静态内部类

* 静态内部类也是定义在另一个类里面的类，只不过在类的前面多了一个关键字static。
* 静态内部类是不需要依赖于外部类的，这点和类的**静态成员属性**有点类似，并且它不能使用外部类的非static成员变量或者方法。
* 静态内部类中即能声明静态成员也可以声明非静态成员。

```java
public  class StaticDemo {
	static String name="王五";
	
	public static class Inner{//四种权限修饰符可以修饰静态内部类
		 //静态内部类中不能访问外部类非静态成员 
		String name="张三";
		static int age=18;
		double height=1.8;
		public void show() {
			//重名时 访问外部类的静态变量使用类名.属性名访问
			System.out.println("这是"+name);
			System.out.println("这是"+StaticDemo.name);
			System.out.println(age);
			System.out.println(height);
		}

			
	}
	
	public static void main(String[] args) {
		//静态内部类可以直接实例化 不需要依附于外部类
		Inner inner = new Inner();
		inner.show();
		
	}

}
```


```java
public class Test {
    public static void main(String[] args)  {
        Outter.Inner inner = new Outter.Inner();
    }
}
 
class Outter {
    public Outter() {
         
    }
     
    static class Inner {
        public Inner() {
             
        }
    }
}
```

### 局部内部类

编写在方法的内部的类称之为局部内部类


* 局部内部类是定义在一个方法或者一个作用域里面的类，它和成员内部类的区别在于局部内部类的访问仅限于方法内或者该作用域内。
* 局部内部类不可使用权限修饰符 静态修饰符进行修饰 同局部变量相同。
* 局部内部类可以直接访问方法中的属性，可以直接访问方法外部类中属性和方法。局部内部类 创建对象 要在方法内部 局部内部类的外部声明

```java
public class PartialDemo {
		String name = "王五";
		static int age = 10;
		
		public static void show() {
			System.out.println("掉用外部类中的show方法");
			
		}
		
		public void printf() {
			System.out.println("调用外部类中的打印方法");
		}
			
		public void demo() {
			String name = "张三";
			double height = 1.8;
			//编写在方法的内部的类称之为局部内部类
			//局部内部类不可使用权限修饰符 静态修饰符进行修饰 同局部变量相同
			//局部内部类与局部变量使用范围一样 在此方法内部
			//局部内部类可以直接访问方法中的属性 重名时使用参数传递完成访问
			
			//局部内部类 可以访问方法外部类中属性和方法  
			
			 class Inner{
				  String name = "李四";				  
				  public void showInner(String name) {
					  show();
					  printf();
					  System.out.println(age);
					  System.out.println(height); 
					  System.out.println("这是:"+PartialDemo.this.name);
					  System.out.println("这是："+name);
					  System.out.println("这是："+this.name);
					 
				  }
			}
			 //局部内部类 创建对象 要在方法内部 局部内部类的外部声明
			 Inner inner=new Inner();
			 inner.showInner(name);
			 
		}
		
		public static void main(String[] args) {
			PartialDemo partialDemo = new PartialDemo();
			partialDemo.demo();
			
		}

	

}
```

### 匿名内部类

匿名内部类不能定义任何静态成员、方法和类，只能创建匿名内部类的一个实例。一个匿名内部类一定是在new的后面，用其隐含实现一个接口或实现一个类。

* 首先有一个接口，然后在使用的类中编写了一个方法（参数类型是接口对象），并使用接口中未实现的方法。我们调用此方法直接构造一个接口对象传入，此时会自动生成一个此接口的子类（匿名内部类）实现接口中的方法。本质传入的类便是此时的匿名内部类。
* 不需要把对象保存到实例当中。
```java
interface A{
	void show();
}

public class AnonymousDemo {			
			//编写回调方法 参数类型为接口A
			public void calllnner(A a) {
				a.show();
			}
			
			
			public static void main(String[] args) {
				AnonymousDemo anonymousDemo = new AnonymousDemo();
				
				//匿名内部类 监听事件使用较多
				anonymousDemo.calllnner(new A() {//接口回调
					
					//实现子类 但是没有名字 所以叫匿名内部类
					@Override
					public void show() {
						// TODO Auto-generated method stub
						System.out.println("show");
					}
					
				});
				
			}

}
```


### 一次输出ABC的答案

```java
package com.qingsu.test;



class Bean{
	public void Demo() {
		class BeanC{
			String C = "BeanC";
		}
		//实例化C
		BeanC	beanC = new BeanC();
		System.out.println(beanC.C);
	}
}

public class InterviewDemo {
	
	
	class BeanA{
		String A = "BeanA";
	}
	
	static class BeanB{
		String B = "BeanB";
	}
	
	
	//实例化BeanA BeanB BeanC 对象
	
	public static void main(String[] args) {

	
		//实例化A
		InterviewDemo interviewDemo =new InterviewDemo();
		BeanA beanA = interviewDemo.new  BeanA();
		System.out.println(beanA.A);
		
		//实例化B
		BeanB beanB = new BeanB();
		System.out.println(beanB.B);
		
		//实例化bean
		Bean bean  = new Bean();
		bean.Demo();
	}

}
```


### 重名变量的引用
以非静态变量为例
* 外部类.this.属性名 可以访问到外部类属性
* this.属性名 可以访问到本类属性
* 方法中参数传递可以访问到类外部方法中的的属性
* 静态内部类中对象名.属性名可以访问到外部类中的的静态属性

```java
public class PartialDemo {
		static String name = "王五";
					
		public void demo() {
			String name = "张三";			
			 class Inner{
				  String name = "李四";				  
				  public void showInner(String name) {
					  System.out.println("这是外部类变量："+PartialDemo.this.name);
					  System.out.println("这是外部类变量（静态变量可以）："+PartialDemo.name);
					  System.out.println("这是方法中局部变量变量："+name);
					  System.out.println("这是局部内部类中的变量："+this.name);
					 
				  }
			}
			 Inner inner=new Inner();
			 inner.showInner(name);			 
		}
		
		public static void main(String[] args) {
			PartialDemo partialDemo = new PartialDemo();
			partialDemo.demo();			
		}

}
```

## 3 原理

### 成员内部类无条件访问外部类的私有变量

在此之前，我们已经讨论过了成员内部类可以无条件访问外部类的成员，那具体究竟是如何实现的呢？下面通过反编译字节码文件看看究竟。事实上，编译器在进行编译的时候，会将成员内部类单独编译成一个字节码文件，下面是Outter.java的代码：

```java
public class Outter {
    private Inner inner = null;
    public Outter() {
         
    }
     
    public Inner getInnerInstance() {
        if(inner == null)
            inner = new Inner();
        return inner;
    }
      
    protected class Inner {
        public Inner() {
             
        }
    }
}
```

编译之后，出现了两个字节码文件：

![img](https://images0.cnblogs.com/i/288799/201407/021630063402064.jpg)



反编译Outter$Inner.class文件得到下面信息：

```java
javap -v Outter$Inner
Compiled from "Outter.java"
public class com.cxh.test2.Outter$Inner extends java.lang.Object
  SourceFile: "Outter.java"
  InnerClass:
   #24= #1 of #22; //Inner=class com/cxh/test2/Outter$Inner of class com/cxh/tes
t2/Outter
  minor version: 0
  major version: 50
  Constant pool:
const #1 = class        #2;     //  com/cxh/test2/Outter$Inner
const #2 = Asciz        com/cxh/test2/Outter$Inner;
const #3 = class        #4;     //  java/lang/Object
const #4 = Asciz        java/lang/Object;
const #5 = Asciz        this$0;
const #6 = Asciz        Lcom/cxh/test2/Outter;;
const #7 = Asciz        <init>;
const #8 = Asciz        (Lcom/cxh/test2/Outter;)V;
const #9 = Asciz        Code;
const #10 = Field       #1.#11; //  com/cxh/test2/Outter$Inner.this$0:Lcom/cxh/t
est2/Outter;
const #11 = NameAndType #5:#6;//  this$0:Lcom/cxh/test2/Outter;
const #12 = Method      #3.#13; //  java/lang/Object."<init>":()V
const #13 = NameAndType #7:#14;//  "<init>":()V
const #14 = Asciz       ()V;
const #15 = Asciz       LineNumberTable;
const #16 = Asciz       LocalVariableTable;
const #17 = Asciz       this;
const #18 = Asciz       Lcom/cxh/test2/Outter$Inner;;
const #19 = Asciz       SourceFile;
const #20 = Asciz       Outter.java;
const #21 = Asciz       InnerClasses;
const #22 = class       #23;    //  com/cxh/test2/Outter
const #23 = Asciz       com/cxh/test2/Outter;
const #24 = Asciz       Inner;
 
{
final com.cxh.test2.Outter this$0;
 
public com.cxh.test2.Outter$Inner(com.cxh.test2.Outter);
  Code:
   Stack=2, Locals=2, Args_size=2
   0:   aload_0
   1:   aload_1
   2:   putfield        #10; //Field this$0:Lcom/cxh/test2/Outter;
   5:   aload_0
   6:   invokespecial   #12; //Method java/lang/Object."<init>":()V
   9:   return
  LineNumberTable:
   line 16: 0
   line 18: 9
 
  LocalVariableTable:
   Start  Length  Slot  Name   Signature
   0      10      0    this       Lcom/cxh/test2/Outter$Inner;
 
 
}
```

第11行到35行是常量池的内容，第38行的内容：

```java
final com.cxh.test2.Outter this$0;
```

这行是一个指向外部类对象的指针，看到这里想必大家豁然开朗了。也就是说编译器会默认为成员内部类添加了一个指向外部类对象的引用，那么这个引用是如何赋初值的呢？下面接着看内部类的构造器：

```java
public com.cxh.test2.Outter$Inner(com.cxh.test2.Outter);
```

从这里可以看出，虽然我们在定义的内部类的构造器是无参构造器，编译器还是会默认添加一个参数，该参数的类型为指向外部类对象的一个引用，所以成员内部类中的Outter this&0 指针便指向了外部类对象，因此可以在成员内部类中随意访问外部类的成员。从这里也间接说明了成员内部类是依赖于外部类的，如果没有创建外部类的对象，则无法对Outter this&0引用进行初始化赋值，也就无法创建成员内部类的对象了。


### 局部内部类和匿名内部类只能访问局部final变量



![](image/2022-08-08-09-52-21.png)

* 局部内部类和匿名内部类只能访问局部final变量或者实际上的final变量。因为防止内部类和外部类处于不同线程时，引起数据不一致的情况。


```java
public class Test {
    public static void main(String[] args)  {
         
    }
     
    public void test(final int b) {
        final int a = 10;
        new Thread(){
            public void run() {
                System.out.println(a);
                System.out.println(b);
            };
        }.start();
    }
}
```

这段代码会被编译成两个class文件：Test.class和Test1.class。默认情况下，编译器会为匿名内部类和局部内部类起名为Outter1.class。默认情况下，编译器会为匿名内部类和局部内部类起名为Outterx.class（x为正整数）。

![img](https://images0.cnblogs.com/i/288799/201407/021900556994393.jpg)

根据上图可知，test方法中的匿名内部类的名字被起为 Test$1。

上段代码中，如果把变量a和b前面的任一个final去掉，这段代码都编译不过。我们先考虑这样一个问题：

当test方法执行完毕之后，变量a的生命周期就结束了，而此时Thread对象的生命周期很可能还没有结束，那么在Thread的run方法中继续访问变量a就变成不可能了，但是又要实现这样的效果，怎么办呢？Java采用了 复制 的手段来解决这个问题。将这段代码的字节码反编译可以得到下面的内容：

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200521140922.png)

我们看到在run方法中有一条指令：

```shell
bipush 10
```

这条指令表示将操作数10压栈，表示使用的是一个本地局部变量。这个过程是在编译期间由编译器默认进行，如果这个变量的值在编译期间可以确定，则编译器默认会在匿名内部类（局部内部类）的常量池中添加一个内容相等的字面量或直接将相应的字节码嵌入到执行字节码中。这样一来，匿名内部类使用的变量是另一个局部变量，只不过值和方法中局部变量的值相等，因此和方法中的局部变量完全独立开。



这条指令表示将操作数10压栈，表示使用的是一个本地局部变量。这个过程是在编译期间由编译器默认进行，如果这个变量的值在编译期间可以确定，则编译器默认会在匿名内部类（局部内部类）的常量池中添加一个内容相等的字面量或直接将相应的字节码嵌入到执行字节码中。这样一来，匿名内部类使用的变量是另一个局部变量，只不过值和方法中局部变量的值相等，因此和方法中的局部变量完全独立开。

下面再看一个例子：

```java
public class Test {
    public static void main(String[] args)  {
         
    }
     
    public void test(final int a) {
        new Thread(){
            public void run() {
                System.out.println(a);
            };
        }.start();
    }
}
```

反编译得到：

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200521141110.png)

我们看到匿名内部类Test$1的构造器含有两个参数，一个是指向外部类对象的引用，一个是int型变量，很显然，这里是将变量test方法中的形参a以参数的形式传进来对匿名内部类中的拷贝（变量a的拷贝）进行赋值初始化。

从上面可以看出，在run方法中访问的变量a根本就不是test方法中的局部变量a。这样一来就解决了前面所说的 生命周期不一致的问题。但是新的问题又来了，既然在run方法中访问的变量a和test方法中的变量a不是同一个变量，当在run方法中改变变量a的值的话，会出现什么情况？

对，会造成数据不一致性，这样就达不到原本的意图和要求。为了解决这个问题，java编译器就限定必须将变量a限制为final变量，不允许对变量a进行更改（对于引用类型的变量，是不允许指向新的对象），这样数据不一致性的问题就得以解决了。



> 如果局部变量的值在编译期间就可以确定，则直接在匿名内部里面创建一个拷贝。如果局部变量的值无法在编译期间确定，则通过构造器传参的方式来对拷贝进行初始化赋值。

### 静态内部类有特殊的地方吗？

从前面可以知道，静态内部类是不依赖于外部类的，也就说可以在不创建外部类对象的情况下创建内部类的对象。另外，静态内部类是不持有指向外部类对象的引用的，这个读者可以自己尝试反编译class文件看一下就知道了，是没有Outter this&0引用的。


## 4 常见的与内部类相关的笔试面试题

### 根据注释填写(1)，(2)，(3)处的代码

```java
public class Test{
    public static void main(String[] args){
           // 初始化Bean1
           (1)
           bean1.I++;
           // 初始化Bean2
           (2)
           bean2.J++;
           //初始化Bean3
           (3)
           bean3.k++;
    }
    class Bean1{
           public int I = 0;
    }
 
    static class Bean2{
           public int J = 0;
    }
}

class Bean{
    class Bean3{
           public int k = 0;
    }
}
```

从前面可知，对于成员内部类，必须先产生外部类的实例化对象，才能产生内部类的实例化对象。而静态内部类不用产生外部类的实例化对象即可产生内部类的实例化对象。

**创建静态内部类对象的一般形式为： 外部类类名.内部类类名 xxx = new 外部类类名.内部类类名()**

**创建成员内部类对象的一般形式为： 外部类类名.内部类类名 xxx = 外部类对象名.new 内部类类名()**

因此，（1），（2），（3）处的代码分别为：

```java
Test test = new Test();    

Test.Bean1 bean1 = test.new Bean1(); 
```

```java
Test.Bean2 b2 = new Test.Bean2();   
```

```java
Bean bean = new Bean();     

Bean.Bean3 bean3 =  bean.new Bean3();   
```

### 下面这段代码的输出结果是什么？

```java
public class Test {
    public static void main(String[] args)  {
        Outter outter = new Outter();
        outter.new Inner().print();
    }
}
 
 
class Outter
{
    private int a = 1;
    class Inner {
        private int a = 2;
        public void print() {
            int a = 3;
            System.out.println("局部变量：" + a);
            System.out.println("内部类变量：" + this.a);
            System.out.println("外部类变量：" + Outter.this.a);
        }
    }
}
```

```shell
3
2
1
```

最后补充一点知识：关于成员内部类的继承问题。一般来说，内部类是很少用来作为继承用的。但是当用来继承的话，要注意两点：

1）成员内部类的引用方式必须为 Outter.Inner.

2）构造器中必须有指向外部类对象的引用，并通过这个引用调用super()。这段代码摘自《Java编程思想》

```java
class WithInner {
    class Inner{
         
    }
}
class InheritInner extends WithInner.Inner {
      
    // InheritInner() 是不能通过编译的，一定要加上形参
    InheritInner(WithInner wi) {
        wi.super(); //必须有这句调用
    }
  
    public static void main(String[] args) {
        WithInner wi = new WithInner();
        InheritInner obj = new InheritInner(wi);
    }
}
```

