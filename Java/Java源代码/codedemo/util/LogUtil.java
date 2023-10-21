package cn.aofeng.demo.util;

/**
 * 日志工具类。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class LogUtil {

    public static void log(String msg) {
        System.out.println(msg);
    }
    
    public static void log(String msg, Object... param) {
        log( String.format(msg, param) );
    }

}
