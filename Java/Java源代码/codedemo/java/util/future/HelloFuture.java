package cn.aofeng.demo.java.util.future;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import org.apache.log4j.Logger;

/**
 * Future、Callable练习。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HelloFuture {

    private static Logger _logger = Logger.getLogger(HelloFuture.class);

    /**
     * @param args
     * @throws InterruptedException 
     */
    public static void main(String[] args) throws InterruptedException {
        executeSingleTask();
        executeBatchTask();
    }

    /**
     * 执行单个异步任务：<br>
     * 1、用submit方法向线程池提交一个任务。<br>
     * 2、获取结果时，指定了超时时间。<br><br>
     * 结果：超时后，调用者收到TimeoutException，但实际上任务还在继续执行。
     * @throws InterruptedException
     */
    private static void executeSingleTask() throws InterruptedException {
        ExecutorService threadpool = Executors.newFixedThreadPool(6);
        try {
            Future<Integer> f = threadpool.submit(createCallable(5 * 1000));
            Object result = f.get(3, TimeUnit.SECONDS);
            System.out.println("单个任务的执行结果："+result);
        } catch (Exception e) {
            _logger.error("线程执行任务时出错", e);
        } finally {
            threadpool.shutdown();
            threadpool.awaitTermination(10, TimeUnit.SECONDS);
        }
    }

    /**
     * 执行多个异步任务：<br>
     * 1、用invokeAll方法向线程池提交多个任务，并指定了执行的超时时间。<br><br>
     * 结果：超时后，未执行完成的任务被取消，在调用Future的get方法时，取消的任务会抛出CancellationException，执行完成的任务可获得结果。
     * @throws InterruptedException
     */
    private static void executeBatchTask() throws InterruptedException {
        ExecutorService threadpool = Executors.newFixedThreadPool(6);
        List<Callable<Integer>> tasks = new ArrayList<Callable<Integer>>();
        tasks.add(createCallable(2000));
        tasks.add(createCallable(5000));
        tasks.add(createCallable(2500));
        
        long startTime = System.currentTimeMillis();
        try {
            List<Future<Integer>> fs = threadpool.invokeAll(tasks, 3, TimeUnit.SECONDS);
            int result = 0;
            for (Future<Integer> f : fs) {
                try{
                    result += f.get();
                } catch(CancellationException ce) {
                    // nothing
                }
            }
            System.out.println("执行三个任务共耗时：" + (System.currentTimeMillis() - startTime) + "毫秒");
            System.out.println("三个任务的执行结果汇总："+result);
        } catch (Exception e) {
            _logger.error("线程执行任务时出错", e);
        } finally {
            threadpool.shutdown();
            threadpool.awaitTermination(10, TimeUnit.SECONDS);
        }
    }
    
    /**
     * 创建需要长时间执行的任务模拟对象。
     * @param sleepTimes 线程休眠时间（单位：毫秒）
     * @return {@link Callable}对象
     */
    private static Callable<Integer> createCallable(final int sleepTimes) {
        Callable<Integer> c = new Callable<Integer>() {

            @Override
            public Integer call() throws Exception {
                Thread.sleep(sleepTimes);
                System.out.println(Thread.currentThread().getName() + ": I'm working");
                return 9;
            }
        };
        
        return c;
    }

}
