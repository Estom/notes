package cn.aofeng.demo.java.lang.reflect;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import cn.aofeng.demo.util.LogUtil;

/**
 * 通过反射使用构造方法创建对象实例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class CreateInstance {

    public static void main(String[] args) throws InstantiationException, IllegalAccessException, 
            NoSuchMethodException, SecurityException,
            IllegalArgumentException, InvocationTargetException {
        Class<Man> claz = Man.class;
        
        // 调用默认的public构造方法
        Man man = claz.newInstance();
        LogUtil.log(man.toString());
        
        // 调用带参数的protected构造方法
        Constructor<Man> manC = claz.getDeclaredConstructor(String.class);
        man = manC.newInstance("aofeng");
        LogUtil.log(man.toString());
        
        // 调用带参数的private构造方法
        manC = claz.getDeclaredConstructor(String.class, int.class);
        manC.setAccessible(true);
        man = manC.newInstance("NieYong", 32);
        LogUtil.log(man.toString());
    }

}
