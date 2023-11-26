
## 问题说明

有时我们希望java程序能在高并发操作下，某个函数只执行一次。
1. 一般情况下，设置一个门控值，每次执行前检查是否执行过，如果没有执行过，则设置为false，并执行。如果为true则不执行。如果是单线程，该方法能够发挥作用。
2. 多线程情况下，如果多个线程同时判断门控值，都得到true，就会同时进入执行结果。

## 1 高并发下的原子操作



使用一个原子Boolean值作为门控值。同一时间进入判断的值只有一个，能保证多线程情况下，该函数仍然只执行一次。
```java
    private AtomicBoolean            inited = new AtomicBoolean(false);

    /**
     * @see ServerManager#getServerList() 
     */
    @Override
    public List<ServerNode> getServerList() {
        if (inited.compareAndSet(false, true)) {
            initServerList();
        }
        return new ArrayList<ServerNode>(serverNodes);
    }
```


## 2 使用两次判断加锁
先判断该值，然后加锁再判断执行。能够保证一下两点内容
1. 第二次判断操作的互斥性，即第二次判断在加锁条件下执行，该判断只会在同一时间发生一次。
2. 外层的判断能够减少执行完成后，其他的高并发访问不再加锁，提高程序的性能。

```
if(value == true){
    synchronized(this){
        if(value == true){
            initMethod();
        }
    }
}
```


一、介绍
AtomicBoolean是通过原子方式更新 boolean 值。AtomicBoolean用于诸如原子更新标志之类的应用程序，但是不能替换boolean类使用。

二、原理
AtomicBoolean 内部持有了一个 volatile变量修饰的value，
底层通过对象在内存中的偏移量(valueOffset)对应的旧值与当前值进行比较，
相等则更新并返回true；否则返回false。
 
即CAS的交换思想. 
AtomicBoolean 内部可以保证，在高并发情况下，同一时刻只有一个线程对变量修改成功。
```java
/**
* Atomically update Java variable to <tt>x</tt> if it is currently
* holding <tt>expected</tt>.
* @return <tt>true</tt> if successful
*/
public final native boolean compareAndSwapInt(Object o, long offset,
                                              int expected,
                                              int x);
Unsafe.compareAndSwapInt()介绍
```

三、应用
1、AtomicBoolean 示例
public class AtomicBooleanDemo1 {
 
    // 设置初始化值为false，参数通过cas操作更新为true
    private static AtomicBoolean initialized = new AtomicBoolean(false);
 
    public void init() {
        if (initialized.compareAndSet(false, true)) {
            // 此处只会有一个线程进入
            System.out.println(Thread.currentThread().getName() + " init success");
        } else {
            System.out.println(Thread.currentThread().getName() + " cas 失败");
        }
    }
 
    public static void main(String[] args) {
        final AtomicBooleanDemo1 demo1 = new AtomicBooleanDemo1();
 
        for (int i = 0; i < 100; i++) {
            new Thread(new Runnable() {
                public void run() {
                    demo1.init();
                }
            }).start();
        }
 
    }
}
2、 使用volatile 替换
```java
public class AtomicBooleanDemo2 {
 
    // 设置初始化值为false，通过volatile变量保证线程可见性
    private static volatile boolean initialized;
 
    public void init() {
        if (initialized == false) {
            initialized = true;
            // 此处只会有一个线程进入
            System.out.println(Thread.currentThread().getName() + " init success");
        } else {
            System.out.println(Thread.currentThread().getName() + " cas 失败");
        }
    }
 
    public static void main(String[] args) throws Exception {
        final AtomicBooleanDemo2 demo1 = new AtomicBooleanDemo2();
 
        for (int i = 0; i < 10; i++) {
            new Thread(new Runnable() {
                public void run() {
                    demo1.init();
                }
            }).start();
        }
 
    }
}
```
针对这种boolean类型的并发操作，可以使用AtomicBoolean进行设置即可

三、源码分析
```java
public class AtomicBoolean implements java.io.Serializable {
    private static final long serialVersionUID = 4654671469794556979L;
    // setup to use Unsafe.compareAndSwapInt for updates
    private static final Unsafe unsafe = Unsafe.getUnsafe();
 
    // 对象在内存中的映射偏移量
    private static final long valueOffset;
 
 
    // static静态块，随AtomicBoolean 类加载时执行一次，可见valueOffset针对所有对象在内存中的映射    
    // 值都是同一个
    static {
        try {
            valueOffset = unsafe.objectFieldOffset
                (AtomicBoolean.class.getDeclaredField("value"));
        } catch (Exception ex) { throw new Error(ex); }
    }
 
    private volatile int value;
 
    // 构造函数，对value赋默认值
    public AtomicBoolean(boolean initialValue) {
        value = initialValue ? 1 : 0;
    }
   
    // 无参构造，value默认值为0
    public AtomicBoolean() {
    }
 
}
```
将expect和AtomicBoolean的value进行比较，若一致则更新为update，否则返回false
```java
    /**
     * Atomically sets the value to the given updated value
     * if the current value {@code ==} the expected value.
     *
     * @param expect the expected value
     * @param update the new value
     * @return {@code true} if successful. False return indicates that
     * the actual value was not equal to the expected value.
     */
    public final boolean compareAndSet(boolean expect, boolean update) {
        int e = expect ? 1 : 0;
        int u = update ? 1 : 0;
        // 通过unsafe的cas方法操作，比较并替换，底层通过lock前缀加锁实现原子性
        return unsafe.compareAndSwapInt(this, valueOffset, e, u);
    }
```
四、unsafe方法的实现原理
1、unsafe的compareAndSet内部是如何保证原子性的？
底层通过cmpxchg汇编命令处理，如果是多处理器会使用lock前缀，可以达到内存屏障的效果，来进行隔离。

具体分析见 【Unsafe中的compareAndSet实现】

 

五、总结
AtomicBoolean内存代码无锁，比常规的synchronized或lock锁效率较高
既然volatile可以修饰boolean类型，为什么还需要有AtomicBoolean原子类？
CAS 都是会存在ABA问题（可采用版本号解决等）
 

补充：
A: boolean类型本身作为标记，保证了原子性，加上volatile保证了可见性，所以此处两种方式都可以，但对于int等其他类型字段volatile则不可保证原子操作，必须依赖于原子类操作等

 AtomicBoolean可以保证原子执行，保证线程安全；
 volatile 只能保证线程可见性、指令重排序等；保证不了原子性。
boolean类型作为标记字段，本身保证了原子性