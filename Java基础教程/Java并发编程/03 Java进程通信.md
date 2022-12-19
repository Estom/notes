## 1 Pipe


PipedReader是Reader类的扩展，用于读取字符流。 它的read（）方法读取连接的PipedWriter的流。 同样， PipedWriter是Writer类的扩展，它完成Reader类所收缩的所有工作。


*  读线程

```java
public class PipeReaderThread implements Runnable 
{
    PipedReader pr;
    String name = null;
 
    public PipeReaderThread(String name, PipedReader pr) 
    {
        this.name = name;
        this.pr = pr;
    }
 
    public void run() 
    {
        try {
            // continuously read data from stream and print it in console
            while (true) {
                char c = (char) pr.read(); // read a char
                if (c != -1) { // check for -1 indicating end of file
                    System.out.print(c);
                }
            }
        } catch (Exception e) {
            System.out.println(" PipeThread Exception: " + e);
        }
    }
}
```
* 写线程

```java
public class PipeWriterThread implements Runnable 
{
    PipedWriter pw;
    String name = null;
 
    public PipeWriterThread(String name, PipedWriter pw) {
        this.name = name;
        this.pw = pw;
    }
 
    public void run() {
        try {
            while (true) {
                // Write some data after every two seconds
                pw.write("Testing data written...n");
                pw.flush();
                Thread.sleep(2000);
            }
        } catch (Exception e) {
            System.out.println(" PipeThread Exception: " + e);
        }
    }
}
```

* 测试代码

```java
package multiThread;
 
import java.io.*;
 
public class PipedCommunicationTest 
{
    public static void main(String[] args) 
    {
        new PipedCommunicationTest();
    }
 
    public PipedCommunicationTest() 
    {
        try
        {
            // Create writer and reader instances
            PipedReader pr = new PipedReader();
            PipedWriter pw = new PipedWriter();
 
            // Connect the writer with reader
            pw.connect(pr);
 
            // Create one writer thread and one reader thread
            Thread thread1 = new Thread(new PipeReaderThread("ReaderThread", pr));
 
            Thread thread2 = new Thread(new PipeWriterThread("WriterThread", pw));
 
            // start both threads
            thread1.start();
            thread2.start();
 
        } 
        catch (Exception e) 
        {
            System.out.println("PipeThread Exception: " + e);
        }
    }
}
```

## 2 BlockQueue（新的最佳实践）


```java
package corejava.thread;
 
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
 
public class DemoExecutor 
{
    public static void main(String[] args) 
    {
        Integer threadCounter = 0;
        BlockingQueue<Runnable> blockingQueue = new ArrayBlockingQueue<Runnable>(50);
 
        CustomThreadPoolExecutor executor = new CustomThreadPoolExecutor(10,
        20, 5000, TimeUnit.MILLISECONDS, blockingQueue);
 
        executor.setRejectedExecutionHandler(new RejectedExecutionHandler() {
            @Override
            public void rejectedExecution(Runnable r,
                    ThreadPoolExecutor executor) {
                System.out.println("DemoTask Rejected : "
                        + ((DemoTask) r).getName());
                System.out.println("Waiting for a second !!");
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("Lets add another time : "
                        + ((DemoTask) r).getName());
                executor.execute(r);
            }
        });
        // Let start all core threads initially
        executor.prestartAllCoreThreads();
        while (true) {
            threadCounter++;
            // Adding threads one by one
            System.out.println("Adding DemoTask : " + threadCounter);
            executor.execute(new DemoTask(threadCounter.toString()));
 
            if (threadCounter == 100)
                break;
        }
    }
 
}

```



## 3 共享数据（最基本的通信方式）