/**
 * 公司：阿里游戏
 * 创建时间：2018年11月2日下午5:56:43
 */
package cn.aofeng.demo.thread;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 守护线程DEMO。
 * 
 * @author <a href="mailto:nieyong.ny@alibaba-inc.com">聂勇</a>
 */
public class DaemonThreadDemo extends Thread {

    private static Logger logger = LoggerFactory.getLogger(DaemonThreadDemo.class);
    
    @Override
    public void run() {
        while (true) {
            System.out.println("守护线程运行, 时间:" + new Date());
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                logger.error("守护线程运行出错", e);
            }
        }
    }
    
    public static void main(String[] args) {
        DaemonThreadDemo thread = new DaemonThreadDemo();
        thread.setDaemon(true);
        thread.start();
        
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            logger.error("主线程运行出错", e);
        }
    }

}
