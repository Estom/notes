package cn.aofeng.demo.java.util.timer;

import java.util.Timer;
import java.util.TimerTask;

import cn.aofeng.demo.util.DateUtil;

/**
 * {@link Timer}的使用示例：<br>
 * 定时任务1：执行过程中会抛出异常。<br>
 * 定时任务2：执行过程中不会抛出异常。<br>
 * <br>
 * 目的：检测java.util.Timer在执行定时任务的过程中，任务内抛出异常没有捕捉时在下一次执行时间到来时，是否可以正常执行。<br>
 * 测试的JDK版本：1.6.xx。<br>
 * 结果：不通过，定时任务抛出异常时，整个Timer中止，其他定时任务也中止。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class TimerDemo {

    public static void main(String[] args) {
        Timer timer = new Timer("aofeng-timer-demo");
        timer.schedule(new ThrowExceptionTask(), DateUtil.getNextMinute(), 60*1000);
        timer.schedule(new NotThrowExceptionTask(), DateUtil.getNextMinute(), 60*1000);
    }

    static class ThrowExceptionTask extends TimerTask {

        @Override
        public void run() {
            System.out.println("任务名:ThrowExceptionTask, 当前时间:"+DateUtil.getCurrentTime());
            
            throw new IllegalArgumentException();
        }
        
    } // end of ThrowExceptionTask
    
    static class NotThrowExceptionTask extends TimerTask {
        
        @Override
        public void run() {
            System.out.println("任务名:NotThrowExceptionTask, 当前时间:"+DateUtil.getCurrentTime());
        }
        
    } // end of NotThrowExceptionTask

}
