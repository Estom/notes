package cn.aofeng.demo.java.util.concurret;

import java.util.Date;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import cn.aofeng.demo.util.DateUtil;

/**
 * {@link ScheduledExecutorService}的使用示例：<br>
 * 定时任务1：执行过程中会抛出异常。<br>
 * 定时任务2：执行过程中不会抛出异常。<br>
 * <br>
 * 目的：检测java.util.concurrent.ScheduledExecutorService在执行定时任务的过程中，任务内抛出异常没有捕捉时在下一次执行时间到来时，是否可以正常执行。<br>
 * 测试的JDK版本：1.6.xx。<br>
 * 结果：通过，相比java.util.Timer，完善地解决了定时任务抛异常的问题。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class ScheduledExecutorServiceDemo {

    public static void main(String[] args) {
        ScheduledExecutorService timer = Executors.newScheduledThreadPool(2);
        long delay = computeDelay();
        timer.schedule(new ThrowExceptionTask(timer), delay, TimeUnit.MILLISECONDS);
        timer.schedule(new NotThrowExceptionTask(timer), delay, TimeUnit.MILLISECONDS);
        System.out.println("主线程的功能执行完毕");
    }

    private static long computeDelay() {
        Date now = new Date();
        Date nextMinute = DateUtil.getNextMinute();
        long delay = nextMinute.getTime() - now.getTime();
        return delay;
    }

    static class ThrowExceptionTask implements Runnable {

        private ScheduledExecutorService _timer;
        
        public ThrowExceptionTask(ScheduledExecutorService timer) {
            this._timer = timer;
        }
        
        @Override
        public void run() {
            try {
                System.out.println("任务名:ThrowExceptionTask, 当前时间:"+DateUtil.getCurrentTime());
                
                throw new IllegalArgumentException();
            } finally {
                _timer.schedule(new ThrowExceptionTask(_timer), computeDelay(), TimeUnit.MILLISECONDS);
            }
        }
        
    } // end of ThrowExceptionTask
    
    static class NotThrowExceptionTask implements Runnable {
        
        private ScheduledExecutorService _timer;
        
        public NotThrowExceptionTask(ScheduledExecutorService timer) {
            this._timer = timer;
        }
        
        @Override
        public void run() {
            try {
                System.out.println("任务名:NotThrowExceptionTask, 当前时间:"+DateUtil.getCurrentTime());
            } finally {
                _timer.schedule(new NotThrowExceptionTask(_timer), computeDelay(), TimeUnit.MILLISECONDS);
            }
        }
        
    } // end of NotThrowExceptionTask

}
