
## 1 互斥访问

Java 提供了两种锁机制来控制多个线程对共享资源的互斥访问，第一个是 JVM 实现的 synchronized，而另一个是 JDK 实现的 ReentrantLock。

### synchronized

**1. 同步一个代码块**  

```java
public void func() {
    synchronized (this) {
        // ...
    }
}
```

它只作用于同一个对象，如果调用两个对象上的同步代码块，就不会进行同步。

对于以下代码，使用 ExecutorService 执行了两个线程，由于调用的是同一个对象的同步代码块，因此这两个线程会进行同步，当一个线程进入同步语句块时，另一个线程就必须等待。

```java
public class SynchronizedExample {

    public void func1() {
        synchronized (this) {
            for (int i = 0; i < 10; i++) {
                System.out.print(i + " ");
            }
        }
    }
}
```

```java
public static void main(String[] args) {
    SynchronizedExample e1 = new SynchronizedExample();
    ExecutorService executorService = Executors.newCachedThreadPool();
    executorService.execute(() -> e1.func1());
    executorService.execute(() -> e1.func1());
}
```

```html
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9
```

对于以下代码，两个线程调用了不同对象的同步代码块，因此这两个线程就不需要同步。从输出结果可以看出，两个线程交叉执行。

```java
public static void main(String[] args) {
    SynchronizedExample e1 = new SynchronizedExample();
    SynchronizedExample e2 = new SynchronizedExample();
    ExecutorService executorService = Executors.newCachedThreadPool();
    executorService.execute(() -> e1.func1());
    executorService.execute(() -> e2.func1());
}
```

```html
0 0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9
```


**2. 同步一个方法**  
* 编写同步方法的一般语法如下。 这里的lockObject是对对象的引用，该对象的锁与同步语句表示的监视器相关联。
  * '.class' object -如果方法是静态的。
  * this' object -如果方法不是静态的。 “ this”是指对其中调用同步方法的当前对象的引用。

```java
public synchronized void func () {
    // ...
}
```

它和同步代码块一样，作用于同一个对象。

**3. 同步一个类**  

```java
public void func() {
    synchronized (SynchronizedExample.class) {
        // ...
    }
}
```

作用于整个类，也就是说两个线程调用同一个类的不同对象上的这种同步语句，也会进行同步。

```java
public class SynchronizedExample {

    public void func2() {
        synchronized (SynchronizedExample.class) {
            for (int i = 0; i < 10; i++) {
                System.out.print(i + " ");
            }
        }
    }
}
```

```java
public static void main(String[] args) {
    SynchronizedExample e1 = new SynchronizedExample();
    SynchronizedExample e2 = new SynchronizedExample();
    ExecutorService executorService = Executors.newCachedThreadPool();
    executorService.execute(() -> e1.func2());
    executorService.execute(() -> e2.func2());
}
```

```html
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9
```

**4. 同步一个静态方法**  

```java
public synchronized static void fun() {
    // ...
}
```

作用于整个类。

### 对象级别和类级别的同步


* 当我们要同步non-static method non-static code block时， Object level lock是一种机制，这样，只有一个线程将能够在给定的类实例上执行代码块。 应该始终这样做， 以确保实例级数据线程安全 。


```java
public class DemoClass
{
    public synchronized void demoMethod(){}
}
 
or
 
public class DemoClass
{
    public void demoMethod(){
        synchronized (this)
        {
            //other thread safe code
        }
    }
}
 
or
 
public class DemoClass
{
    private final Object lock = new Object();
    public void demoMethod(){
        synchronized (lock)
        {
            //other thread safe code
        }
    }
}
```

* Class level lock可防止多个线程在运行时在该类的所有可用实例中的任何一个中进入synchronized块。 这意味着，如果在运行时有100个demoMethod()实例，则一次只能在一个实例中的任何一个线程上执行demoMethod() ，而所有其他实例将被其他线程锁定。

```java
public class DemoClass
{
    //Method is static
    public synchronized static void demoMethod(){
 
    }
}
 
or
 
public class DemoClass
{
    public void demoMethod()
    {
        //Acquire lock on .class reference
        synchronized (DemoClass.class)
        {
            //other thread safe code
        }
    }
}
 
or
 
public class DemoClass
{
    private final static Object lock = new Object();
 
    public void demoMethod()
    {
        //Lock object is static
        synchronized (lock)
        {
            //other thread safe code
        }
    }
}
```

注意事项
* Java中的同步保证了没有两个线程可以同时或并发执行需要相同锁的同步方法。
* synchronized关键字只能与方法和代码块一起使用。 这些方法或块可以是static也可以non-static 。
* 每当线程进入Java synchronized方法或块时，它都会获取一个锁，而当线程离开同步方法或块时，它将释放该锁。 即使线程在完成后或由于任何错误或异常而离开同步方法时，也会释放锁定。
* Java synchronized关键字本质上是可re-entrant ，这意味着如果一个同步方法调用另一个需要相同锁的同步方法，则持有锁的当前线程可以进入该方法而无需获取锁。
* 如果在同步块中使用的对象为null，则Java同步将引发NullPointerException 。 例如，在上面的代码示例中，如果将锁初始化为null，则“ synchronized (lock) ”将抛出NullPointerException 。
* Java中的同步方法使您的应用程序性能降低。 因此，在绝对需要时使用同步。 另外，请考虑使用同步的代码块仅同步代码的关键部分。
* 静态同步方法和非静态同步方法都可能同时或同时运行，因为它们锁定在不同的对象上。
* 根据Java语言规范，您不能在构造函数中使用synchronized关键字。 这是非法的，并导致编译错误。
* 不要在Java中的同步块上的非final字段上进行同步。 因为非最终字段的引用可能随时更改，然后不同的线程可能会在不同的对象上进行同步，即完全没有同步。
* 不要使用String文字，因为它们可能在应用程序中的其他地方被引用，并且可能导致死锁。 使用new关键字创建的字符串对象可以安全使用。 但作为最佳实践，请在我们要保护的共享变量本身上创建一个新的private作用域Object实例OR锁。




## 2 线程之间的协作

当多个线程可以一起工作去解决某个问题时，如果某些部分必须在其它部分之前完成，那么就需要对线程进行协调。


### Object:wait、notify、notifyAll

调用 wait() 使得线程等待某个条件满足，线程在等待时会被挂起，当其他线程的运行使得这个条件满足时，其它线程会调用 notify() 或者 notifyAll() 来唤醒挂起的线程。

它们都属于 Object 的一部分，而不属于 Thread。

只能用在同步方法或者同步控制块中使用，否则会在运行时抛出 IllegalMonitorStateException。

使用 wait() 挂起期间，线程会释放锁。这是因为，如果没有释放锁，那么其它线程就无法进入对象的同步方法或者同步控制块中，那么就无法执行 notify() 或者 notifyAll() 来唤醒挂起的线程，造成死锁。

```java
public class WaitNotifyExample {

    public synchronized void before() {
        System.out.println("before");
        notifyAll();
    }

    public synchronized void after() {
        try {
            wait();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("after");
    }
}
```

```java
public static void main(String[] args) {
    ExecutorService executorService = Executors.newCachedThreadPool();
    WaitNotifyExample example = new WaitNotifyExample();
    executorService.execute(() -> example.after());
    executorService.execute(() -> example.before());
}
```

```html
before
after
```

**wait() 和 sleep() 的区别**  

- wait() 是 Object 的方法，而 sleep() 是 Thread 的静态方法；
- wait() 会释放锁，sleep() 不会。


### Thread:join

在线程中调用另一个线程的 join() 方法，会将当前线程挂起，而不是忙等待，直到目标线程结束。

对于以下代码，虽然 b 线程先启动，但是因为在 b 线程中调用了 a 线程的 join() 方法，b 线程会等待 a 线程结束才继续执行，因此最后能够保证 a 线程的输出先于 b 线程的输出。

```java
public class JoinExample {

    private class A extends Thread {
        @Override
        public void run() {
            System.out.println("A");
        }
    }

    private class B extends Thread {

        private A a;

        B(A a) {
            this.a = a;
        }

        @Override
        public void run() {
            try {
                a.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("B");
        }
    }

    public void test() {
        A a = new A();
        B b = new B(a);
        b.start();
        a.start();
    }
}
```

```java
public static void main(String[] args) {
    JoinExample example = new JoinExample();
    example.test();
}
```

```
A
B
```