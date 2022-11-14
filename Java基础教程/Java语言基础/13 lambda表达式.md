## lambda表达式概述

### 简介

lambda运行将函数作为一个方法的参数，也就是函数作为参数传递到方法中。使用lambda表达式可以让代码更加简洁。

Lambda表达式的使用场景：用以简化接口实现。

### 接口实现
* 设计接口的实现类
```
Interface B{}
Class A implements B{

}
new A();
```
* 使用匿名内部类
```
//直接创建匿名内部类。
Interface B{}
new B(){

}
```
* lambda表达式
```
//使用lambda表达式实现接口
Interface B{}
Test test = () -> {
    System.out.println("test");
};
test.test();
```

### 注意事项

这⾥类似于局部内部类、匿名内部类，依然存在闭包的问题。

如果在lambda表达式中，使用到了局部变量，那么这个局部变量会被隐式的声明为 final。是⼀个常量，不能修改值。

## 2 函数式接口
### 函数式接口
lambda表达式，只能实现函数式接口。

函数式接口：如果说，⼀个接口中，要求实现类必须实现的抽象方法，有且只有⼀个！

```java
//有且只有一个实现类必须要实现的抽象方法，所以是函数式接口
interface Test{
    public void test();
}
```

lambda表达式毕竟只是⼀个匿名方法。当实现的接口中的方法过多或者多少的时候，lambda表达式都是不适用的。

### @FunctionalInterface
* 编译时检查的注解。


是⼀个注解，用在接口之前，判断这个接口是否是⼀个函数式接口。 如果是函数式接口，没有任何问题。如果不是函数式接口，则会报错。功能类似于 @Override。

```java
@FunctionalInterface
interface Test{
    public void test();
}
```


## 3 Lambda表达式的语法
使用lambda表带是实现一个函数式接口
### 基础语法

不需要关注参数类型或者返回值类型。

```java
(参数1,参数2,…) -> {
方法体
};
```
* 参数部分：方法的参数列表，要求和实现的接口中的方法参数部分⼀致，包括参数的数量和类型。
* 方法体部分 ： 方法的实现部分，如果接口中定义的方法有返回值，则在实现的时候，注意返回值的返回。
* -> : 分隔参数部分和方法体部分。


```
// 1. 不需要参数,返回值为 2
() -> 2
// 2. 接收一个参数(数字类型),返回其2倍的值
x -> 2 * x
// 3. 接受2个参数(数字),并返回他们的和
(x, y) -> x + y
// 4. 接收2个int型整数,返回他们的乘积
(int x, int y) -> x * y//可以加类型
// 5. 接受一个 string 对象,并在控制台打印,不返回任何值(看起来像是返回void)
(String s) -> System.out.print(s)
```

```java
package test;

/**
 * @author: Mercury
 * Date: 2022/3/20
 * Time: 17:48
 * Description:Lambda表达式
 * Version:1.0
 */
public class Test04 {
    public static void main(String[] args) {
        //使用lambda表达式实现接口
        //有参+返回值
        Test test = (name,age)  -> {
            System.out.println(name+age+"岁了！");
            return age + 1;
        };
        int age = test.test("小新",18);
        System.out.println(age);

    }
}

//有参 有返回值
interface Test{
    public int test(String name,int age);
}
```


### 语法进阶

1. 参数的类型可以省略不写。由于在接口的方法中，已经定义了每⼀个参数的类型是什么。而且在使用lambda表达式实现接口的时候，必须要保证参数的数量和类 型需要和接口中的方法保持⼀致。要省略， 每⼀个参数的类型都必须省略不写。绝对不能出现，有的参数类型省略了，有的参数类型没有省略。

```java
       //有参+返回值
        Test test = (name,age)  -> {
            System.out.println(name+age+"岁了！");
            return age + 1;
        };
        int age = test.test("小新",18);
        System.out.println(age);
```

2. 参数的小括号可以省略不写。如果方法的参数列表中的参数数量 有且只有⼀个，此时，参数列表的小括号是可以省略不写的。

```java
        //一个参数
        Test test = name -> {
            System.out.println(name+"test");
        };
        test.test("小新");
```

3. return可以省略不写。如果⼀个方法中唯⼀的⼀条语句是⼀个返回语句， 此时在省略掉大括号的同时， 也必须省略掉return。

```java
Test test = (a,b) -> a+b;
```

## 4 函数引用

### 函数引用的概念
lambda表达式是为了简化接口的实现的。在lambda表达式中，不应该出现比较复杂的逻辑。如果在lambda表达式中出现了过于复杂的逻辑，会对程序的可读性造成非常大的影响。如果在lambda表达式中需要处理的逻辑比较复杂，⼀般情况会单独的写⼀个方法。在lambda表达式中直接引用这个方法即可


函数引用：引用⼀个已经存在的方法，使其替代lambda表达式完成接口的实现


### 静态方法的引用
```
类::静态方法
```
* 引用方法后面，不要添加小括号。
* 引用方法、参数和返回值，必须要跟接口中定义的一致。

```java
package test;

/**
 * @author: Mercury
 * Date: 2022/3/20
 * Time: 18:17
 * Description:lambda表达式静态方法引用
 * Version:1.0
 */
public class Test05 {
    public static void main(String[] args) {
        //实现多个参数，一个返回值的接口
        //对一个静态方法的引用，语法：类::静态方法
        Test1 test1 = Calculator::calculate;
        System.out.println(test1.test(4,5));
    }
}

class Calculator{
    public static int calculate(int a,int b ){
        // 稍微复杂的逻辑：计算a和b的差值的绝对值
        if (a > b) {
            return a - b;
        }
        return b - a;
    }
}

interface Test1{
    int test(int a,int b);
}
```


### 非静态方法的引用

```
对象::非静态方法
```
* 在引用的方法后⾯，不要添加小括号。
* 引用的这个方法， 参数（数量、类型） 和 返回值， 必须要跟接口中定义的⼀致。

```
package test;

/**
 * @author: Mercury
 * Date: 2022/3/21
 * Time: 8:14
 * Description:lambda表达式对非静态方法的引用
 * Version:1.0
 */
public class Test06 {
    public static void main(String[] args) {
        //对非静态方法的引用，需要使用对象来完成
        Test2 test2 = new Calculator()::calculate;
        System.out.println(test2.calculate(2, 3));
    }
    private static class Calculator{
        public int calculate(int a, int b) {
            return a > b ? a - b : b - a;
         }
    }
}
interface Test2{
    int calculate(int a,int b);
}
```

### 构造方法的引用

使用场景

如果某⼀个函数式接口中定义的方法，仅仅是为了得到⼀个类的对象。此时我们就可以使用构造方法的引用，简化这个方法的实现。

```
语法：类名::new
```

注意事项：可以通过接口中的方法的参数， 区分引用不同的构造方法。

```java
package com.cq.test;

/**
 * @author: Mercury
 * Date: 2022/4/27
 * Time: 10:31
 * Description:lambda构造方法的引用
 * Version:1.0
 */
public class Test {
    private static class Dog{
        String name;
        int age;
        //无参构造
        public Dog(){
            System.out.println("一个Dog对象通过无参构造被实例化了");
        }
        //有参构造
        public Dog(String name,int age){
            System.out.println("一个Dog对象通过有参构造被实例化了");
            this.name = name;
            this.age = age;
        }
    }
    //定义一个函数式接口,用以获取无参的对象
    @FunctionalInterface
    private interface GetDog{
        //若此方法仅仅是为了获得一个Dog对象，而且通过无参构造去获取一个Dog对象作为返回值
        Dog test();
    }

    //定义一个函数式接口,用以获取有参的对象
    @FunctionalInterface
    private interface GetDogWithParameter{
        //若此方法仅仅是为了获得一个Dog对象，而且通过有参构造去获取一个Dog对象作为返回值
        Dog test(String name,int age);
    }

    // 测试
    public static void main(String[] args) {
        //lambda表达式实现接口
        GetDog lm = Dog::new; //引用到Dog类中的无参构造方法，获取到一个Dog对象
        Dog dog = lm.test();
        System.out.println("修狗的名字："+dog.name+" 修狗的年龄："+dog.age); //修狗的名字：null 修狗的年龄：0
        GetDogWithParameter lm2 = Dog::new;//引用到Dog类中的有参构造，来获取一个Dog对象
        Dog dog1 = lm2.test("萨摩耶",2);
        System.out.println("修狗的名字："+dog1.name+" 修狗的年龄："+dog1.age);//修狗的名字：萨摩耶 修狗的年龄：2

    }
}
```

## 4 集合中的使用

### forEach( )方法演示：
```java
public static void main(String[] args) {
        ArrayList<String>list=new ArrayList<>();
        list.add("a");
        list.add("bc");
        list.add("def");
        list.add("hello");

        //写法1：（不用Lambda表达式）
        list.forEach(new Consumer<String>() {
            @Override
            public void accept(String s) {
                System.out.println(s);
            }
        });

        //写法2：（用Lambda表达式）
        list.forEach(s-> System.out.println(s));
        //效果和写法1一样
    }
```

### sort()方法的演示

```java
public static void main(String[] args) {
        ArrayList<String>list=new ArrayList<>();
        list.add("hh");
        list.add("hi");
        list.add("def");
        list.add("abc");

        //写法1：（不用Lambda表达式）
        list.sort(new Comparator<String>() {
            @Override
            public int compare(String o1,String o2) {
                return o1.compareTo(o2);
            }
        });
        list.forEach(s-> System.out.println(s));

        System.out.println("======分割线======");

        //写法2：（用Lambda表达式）
        list.sort(((o1, o2) -> o1.compareTo(o2)));
        //效果和写法1一样
        list.forEach(s-> System.out.println(s));
    }//Lambda表达式可以大大缩短代码量，但是相应的可读性比较差
```

### HashMap 的 forEach()
```
public static void main(String[] args) {
        HashMap<Integer,String>map=new HashMap<>();
        map.put(1,"hello");
        map.put(2,"I");
        map.put(3,"love");
        map.put(4,"china");

        //法一：（不用Lambda）
        map.forEach(new BiConsumer<Integer, String>() {
            @Override
            public void accept(Integer integer, String s) {
                System.out.println("key:"+integer+"value:"+s);
            }
        });

        System.out.println("======分割线======");

        //法二：（用Lambda）
        map.forEach((key,value)-> System.out.println("key:"+key+"value:"+value));
    }
```