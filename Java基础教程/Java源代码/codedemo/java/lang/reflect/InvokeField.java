package cn.aofeng.demo.java.lang.reflect;

import java.lang.reflect.Field;

import static cn.aofeng.demo.util.LogUtil.log;

/**
 * 通过反射设置字段。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class InvokeField {

    public static void main(String[] args) throws NoSuchFieldException,
            SecurityException, IllegalArgumentException, IllegalAccessException {
        Man man = new Man();
        Class<?> claz = man.getClass();
        
        log("==========设置public字段的值==========");
        log("height的值:%d", man.height);
        Field field = claz.getField("height");
        field.setInt(man, 175);
        log("height的值:%d", man.height);
        
        log("==========设置private字段的值==========");
        log("power的值:%d", man.getPower());
        field = claz.getDeclaredField("power");
        field.setAccessible(true);
        field.setInt(man, 100);
        log("power的值:%d", man.getPower());
        
        log("==========获取private字段的值==========");
        int power = field.getInt(man);
        log("power的值:%d", power);
    }

}
