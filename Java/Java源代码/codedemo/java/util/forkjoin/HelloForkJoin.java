package cn.aofeng.demo.java.util.forkjoin;

import java.util.Arrays;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;
import java.util.concurrent.TimeUnit;

/**
 * Fork/Join练习。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HelloForkJoin extends RecursiveTask<Long> {

    private static final long serialVersionUID = -2386438994963147457L;

    private int[] _intArray;
    
    private int _threshold = 10;
    
    private long _result = 0;
    
    public HelloForkJoin(int[] intArray) {
        this._intArray = intArray;
    }
    
    @Override
    protected Long compute() {
        if (null == _intArray || _intArray.length <= 0) {
            return 0L;
        }
        
        if (_intArray.length <= _threshold) {   // 如果数组长度小于等于指定的值，执行累加操作
            for (int item : _intArray) {
                _result += item;
            }
            System.out.println( String.format("线程：%s，累加数组%s中的值，结果：%d", Thread.currentThread(), Arrays.toString(_intArray), _result) );
        } else {   // 如果数组长度大于指定的值，做任务分解
            int[] temp = new int[_threshold];
            System.arraycopy(_intArray, 0, temp, 0, _threshold);
            HelloForkJoin subTask1 = new HelloForkJoin(temp);
            subTask1.fork();
            
            if (_intArray.length - _threshold > 0) {
                int remain[] = new int[_intArray.length - _threshold];
                System.arraycopy(_intArray, _threshold, remain, 0, remain.length);
                HelloForkJoin task = new HelloForkJoin(remain);
                task.fork();
                _result += task.join();
            }
            
            _result += subTask1.join();
            
            return _result;
        }
        
        return _result;
    }
    
    public static void main(String[] args) throws InterruptedException {
        int count = 10000;
        
        serialCompute(count);
        parallelCompute(count);
    }

    /**
     * 使用fork/join并行计算数字累加。
     * 
     * @param count 数字个数（从1开始）
     * @throws InterruptedException
     */
    private static void parallelCompute(int count)
            throws InterruptedException {
        int[] numbers = new int[count];
        for (int i = 0; i < count; i++) {
            numbers[i] = i+1;
        }
        ForkJoinPool pool = new ForkJoinPool(4);
        HelloForkJoin task = new HelloForkJoin(numbers);
        long startTime = System.currentTimeMillis();
        pool.submit(task);
        pool.shutdown();
        pool.awaitTermination(10, TimeUnit.SECONDS);
        
        System.out.println( String.format("并行计算结果：%d，耗时：%d毫秒", task._result, System.currentTimeMillis()-startTime) );
    }

    /**
     * 使用for循环串行计算数字累加。
     * 
     * @param count 数字个数（从1开始） 
     */
    private static void serialCompute(int count) {
        long startTime = System.currentTimeMillis();
        int sum = 0;
        for (int i = 0; i < count; i++) {
            sum += (i+1);
        }
        System.out.println( String.format("串行计算结果：%d，耗时：%d毫秒", sum, System.currentTimeMillis()-startTime) );
    }

}
