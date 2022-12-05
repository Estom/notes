# 谈谈你对锁的理解？如何手动模拟一个死锁？

在并发编程中有两个重要的概念：线程和锁，多线程是一把双刃剑，它在提高程序性能的同时，也带来了编码的复杂性，对开发者的要求也提高了一个档次。而锁的出现就是为了保障多线程在同时操作一组资源时的数据一致性，当我们给资源加上锁之后，只有拥有此锁的线程才能操作此资源，而其他线程只能排队等待使用此锁。当然，在所有的面试中也都少不了关于“锁”方面的相关问题。

## 典型回答

死锁是指两个线程同时占用两个资源，又在彼此等待对方释放锁资源，如下图所示：

![](https://cdn.jsdelivr.net/gh/krislinzhao/IMGcloud/img/20200425140218.png)

死锁的代码演示如下：

```java
import java.util.concurrent.TimeUnit;

public class LockExample {
    public static void main(String[] args) {
        deadLock(); // 死锁
    }
/**
 * 死锁
 */
private static void deadLock() {
    Object lock1 = new Object();
    Object lock2 = new Object();
    // 线程一拥有 lock1 试图获取 lock2
    new Thread(() -> {
        synchronized (lock1) {
            System.out.println("获取 lock1 成功");
            try {
                TimeUnit.SECONDS.sleep(3);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            // 试图获取锁 lock2
            synchronized (lock2) {
                System.out.println(Thread.currentThread().getName());
            }
        }
    }).start();
    // 线程二拥有 lock2 试图获取 lock1
    new Thread(() -> {
        synchronized (lock2) {
            System.out.println("获取 lock2 成功");
            try {
                TimeUnit.SECONDS.sleep(3);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            // 试图获取锁 lock1
            synchronized (lock1) {
                System.out.println(Thread.currentThread().getName());
            }
        }
    }).start();
}
```

以上程序执行结果如下：

```
获取 lock1 成功
获取 lock2 成功
```


可以看出当我们使用线程一拥有锁 lock1 的同时试图获取 lock2，而线程二在拥有 lock2 的同时试图获取 lock1，这样就会造成彼此都在等待对方释放资源，于是就形成了死锁。

锁是指在并发编程中，当有多个线程同时操作一个资源时，为了保证数据操作的正确性，我们需要让多线程排队一个一个的操作此资源，而这个过程就是给资源加锁和释放锁的过程，就好像去公共厕所一样，必须一个一个排队使用，并且在使用时需要锁门和开门一样。

## 考点分析
锁的概念不止出现在 Java 语言中，比如乐观锁和悲观锁其实很早就存在于数据库中了。锁的概念其实不难理解，但要真正的了解锁的原理和实现过程，才能打动面试官。

和锁相关的面试问题，还有以下几个：

* 什么是乐观锁和悲观锁？它们的应用都有哪些？乐观锁有什么问题？
* 什么是可重入锁？用代码如何实现？它的实现原理是什么？
* 什么是共享锁和独占锁？

# 知识扩展

## 1.悲观锁和乐观锁

悲观锁指的是数据对外界的修改采取保守策略，它认为线程很容易会把数据修改掉，因此在整个数据被修改的过程中都会采取锁定状态，直到一个线程使用完，其他线程才可以继续使用。

我们来看一下悲观锁的实现流程，以 synchronized 为例，代码如下：

```java
public class LockExample {
    public static void main(String[] args) {
        synchronized (LockExample.class) {
            System.out.println("lock");
        }
    }
}
```

我们使用反编译工具查到的结果如下：

```classes
Compiled from "LockExample.java"
public class com.lagou.interview.ext.LockExample {
  public com.lagou.interview.ext.LockExample();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void main(java.lang.String[]);
    Code:
       0: ldc           #2                  // class com/lagou/interview/ext/LockExample
       2: dup
       3: astore_1
       4: monitorenter // 加锁
       5: getstatic     #3                  // Field java/lang/System.out:Ljava/io/PrintStream;
       8: ldc           #4                  // String lock
      10: invokevirtual #5                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      13: aload_1
      14: monitorexit // 释放锁
      15: goto          23
      18: astore_2
      19: aload_1
      20: monitorexit
      21: aload_2
      22: athrow
      23: return
    Exception table:
       from    to  target type
           5    15    18   any
          18    21    18   any
}
```


可以看出被 synchronized 修饰的代码块，在执行之前先使用 monitorenter 指令加锁，然后在执行结束之后再使用 monitorexit 指令释放锁资源，在整个执行期间此代码都是锁定的状态，这就是典型悲观锁的实现流程。

乐观锁和悲观锁的概念恰好相反，乐观锁认为一般情况下数据在修改时不会出现冲突，所以在数据访问之前不会加锁，只是在数据提交更改时，才会对数据进行检测。

Java 中的乐观锁大部分都是通过 CAS（Compare And Swap，比较并交换）操作实现的，CAS 是一个多线程同步的原子指令，CAS 操作包含三个重要的信息，即内存位置、预期原值和新值。如果内存位置的值和预期的原值相等的话，那么就可以把该位置的值更新为新值，否则不做任何修改。

CAS 可能会造成 ABA 的问题，ABA 问题指的是，线程拿到了最初的预期原值 A，然而在将要进行 CAS 的时候，被其他线程抢占了执行权，把此值从 A 变成了 B，然后其他线程又把此值从 B 变成了 A，然而此时的 A 值已经并非原来的 A 值了，但最初的线程并不知道这个情况，在它进行 CAS 的时候，只对比了预期原值为 A 就进行了修改，这就造成了 ABA 的问题。

以警匪剧为例，假如某人把装了 100W 现金的箱子放在了家里，几分钟之后要拿它去赎人，然而在趁他不注意的时候，进来了一个小偷，用空箱子换走了装满钱的箱子，当某人进来之后看到箱子还是一模一样的，他会以为这就是原来的箱子，就拿着它去赎人了，这种情况肯定有问题，因为箱子已经是空的了，这就是 ABA 的问题。

ABA 的常见处理方式是添加版本号，每次修改之后更新版本号，拿上面的例子来说，假如每次移动箱子之后，箱子的位置就会发生变化，而这个变化的位置就相当于“版本号”，当某人进来之后发现箱子的位置发生了变化就知道有人动了手脚，就会放弃原有的计划，这样就解决了 ABA 的问题。

JDK 在 1.5 时提供了 AtomicStampedReference 类也可以解决 ABA 的问题，此类维护了一个“版本号” Stamp，每次在比较时不止比较当前值还比较版本号，这样就解决了 ABA 的问题。

相关源码如下：

```java
public class AtomicStampedReference<V> {
    private static class Pair<T> {
        final T reference;
        final int stamp; // “版本号”
        private Pair(T reference, int stamp) {
            this.reference = reference;
            this.stamp = stamp;
        }
        static <T> Pair<T> of(T reference, int stamp) {
            return new Pair<T>(reference, stamp);
        }
    }
    // 比较并设置
    public boolean compareAndSet(V   expectedReference,
                                 V   newReference,
                                 int expectedStamp, // 原版本号
                                 int newStamp) { // 新版本号
        Pair<V> current = pair;
        return
            expectedReference == current.reference &&
            expectedStamp == current.stamp &&
            ((newReference == current.reference &&
              newStamp == current.stamp) ||
             casPair(current, Pair.of(newReference, newStamp)));
    }
    //.......省略其他源码
}
```


可以看出它在修改时会进行原值比较和版本号比较，当比较成功之后会修改值并修改版本号。

小贴士：乐观锁有一个优点，它在提交的时候才进行锁定的，因此不会造成死锁。

## 2.可重入锁

可重入锁也叫递归锁，指的是同一个线程，如果外面的函数拥有此锁之后，内层的函数也可以继续获取该锁。在 Java 语言中 ReentrantLock 和 synchronized 都是可重入锁。

下面我们用 synchronized 来演示一下什么是可重入锁，代码如下：

```java
public class LockExample {
    public static void main(String[] args) {
        reentrantA(); // 可重入锁
    }
    /**
     * 可重入锁 A 方法
     */
    private synchronized static void reentrantA() {
        System.out.println(Thread.currentThread().getName() + "：执行 reentrantA");
        reentrantB();
    }
    /**
     * 可重入锁 B 方法
     */
    private synchronized static void reentrantB() {
        System.out.println(Thread.currentThread().getName() + "：执行 reentrantB");
    }
}
```

以上代码的执行结果如下：

```
main：执行 reentrantA
main：执行 reentrantB
```


从结果可以看出 reentrantA 方法和 reentrantB 方法的执行线程都是“main” ，我们调用了 reentrantA 方法，它的方法中嵌套了 reentrantB，如果 synchronized 是不可重入的话，那么线程会被一直堵塞。

可重入锁的实现原理，是在锁内部存储了一个线程标识，用于判断当前的锁属于哪个线程，并且锁的内部维护了一个计数器，当锁空闲时此计数器的值为 0，当被线程占用和重入时分别加 1，当锁被释放时计数器减 1，直到减到 0 时表示此锁为空闲状态。

## 3.共享锁和独占锁

只能被单线程持有的锁叫独占锁，可以被多线程持有的锁叫共享锁。

独占锁指的是在任何时候最多只能有一个线程持有该锁，比如 synchronized 就是独占锁，而 ReadWriteLock 读写锁允许同一时间内有多个线程进行读操作，它就属于共享锁。

独占锁可以理解为悲观锁，当每次访问资源时都要加上互斥锁，而共享锁可以理解为乐观锁，它放宽了加锁的条件，允许多线程同时访问该资源。

# 小结

本节我们讲了悲观锁和乐观锁，其中悲观锁的典型应用为 synchronized，而 ReadWriteLock 为乐观锁的典型应用，乐观锁可能会导致 ABA 的问题，常见的解决方案是添加版本号来防止 ABA 问题的发生；同时，还讲了可重入锁，在 Java 中，synchronized 和 ReentrantLock 都是可重入锁；最后讲了独占锁和共享锁，其中独占锁可以理解为悲观锁，而共享锁可以理解为乐观锁。
