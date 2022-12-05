package cn.aofeng.demo.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class DateUtil {

    /**
     * @return 返回当前时间的字符串（格式："yyyy-MM-dd HH:mm:ss"）
     */
    public static String getCurrentTime() {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return dateFormat.format(new Date());
    }

    /**
     * @return 下一分钟秒数为0的时间
     */
    public static Date getNextMinute() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MINUTE, 1);
        cal.set(Calendar.SECOND, 0);
        
        return cal.getTime();
    }

}
