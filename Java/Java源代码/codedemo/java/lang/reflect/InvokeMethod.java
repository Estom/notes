package cn.aofeng.demo.java.lang.reflect;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import static cn.aofeng.demo.util.LogUtil.log;

/**
 * 通过反射调用方法。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class InvokeMethod {

    /**
     * 调用父类的方法。
     * 
     * @param claz
     *            类
     * @param man
     *            类对应的实例
     */
    private static void invokeParentMethod(Class<Man> claz, Man man)
            throws NoSuchMethodException, IllegalAccessException,
            InvocationTargetException {
        // 调用父类的public方法
        Method method = claz.getMethod("setName", String.class);
        method.invoke(man, "NieYong");
        log(man.toString());

        method = claz.getMethod("getName");
        Object result = method.invoke(man);
        log("name:%s", result);

        // 调用父类的private方法
        method = claz.getSuperclass().getDeclaredMethod("reset");
        method.setAccessible(true);
        result = method.invoke(man);
        log(man.toString());
    }

    /**
     * 调用自身的方法。
     * 
     * @param claz
     *            类
     * @param man
     *            类对应的实例
     */
    private static void invokeSelfMethod(Class<Man> claz, Man man)
            throws NoSuchMethodException, IllegalAccessException,
            InvocationTargetException {
        man.setName("XiaoMing");
        // 调用自身的private方法
        Method method = claz.getDeclaredMethod("setPower", int.class);
        method.setAccessible(true);
        method.invoke(man, 99);
        log("power:%d", man.getPower());

        // 调用自身的public方法
        log("%s is marry:%s", man.getName(), (man.isMarry() ? "Yes" : "No"));
        method = claz.getDeclaredMethod("setMarry", boolean.class);
        method.invoke(man, true);
        log("%s is marry:%s", man.getName(), (man.isMarry() ? "Yes" : "No"));

        // 调用静态方法，可将实例设置为null，因为静态方法属于类
        Man a = new Man("张三");
        Man b = new Man("李四");
        method = claz.getMethod("fight", Man.class, Man.class);
        method.invoke(null, a, b); //
    }

    public static void main(String[] args) throws NoSuchMethodException,
            SecurityException, IllegalAccessException,
            IllegalArgumentException, InvocationTargetException,
            InstantiationException {
        Class<Man> claz = Man.class;
        Man man = claz.newInstance();

        invokeParentMethod(claz, man);
        invokeSelfMethod(claz, man);
    }

}
