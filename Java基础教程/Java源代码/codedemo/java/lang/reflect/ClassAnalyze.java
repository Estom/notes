package cn.aofeng.demo.java.lang.reflect;

import java.lang.annotation.Annotation;
import java.lang.reflect.AnnotatedElement;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Member;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

/**
 * 通过反射获取类的构造方法、字段、方法和注解等信息。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class ClassAnalyze {

    final static String PREFIX = "==========";
    final static String SUFFIX = PREFIX;
    
    private static void parseClass(Class<?> claz) {
        // 注解
        parseAnnotation(claz);
        
        // 类
        StringBuilder buffer = new StringBuilder(32)
            .append( Modifier.toString(claz.getModifiers()) )
            .append(' ')
            .append(claz.getName());
        log(buffer.toString());
    }
    
    private static void parseConstructor(Constructor<?> c) {
        // 注解
        parseAnnotation(c);
        
        // 构造方法
        StringBuilder buffer = new StringBuilder(32)
            .append( parseMember(c) )
            .append('(');
        
        // 参数
        Class<?>[] params = c.getParameterTypes();
        for (int index = 0; index < params.length; index++) {
            buffer.append(params[index].getName());
            if (index!=params.length-1) {
                buffer.append(", ");
            }
        }
        buffer.append(')');
        
        log(buffer.toString());
    }
    
    private static void parseMethod(Method method) {
        // 注解
        parseAnnotation(method);
        
        // 方法
        StringBuilder buffer = new StringBuilder(32)
            .append( parseMember(method) )
            .append('(');
        
        // 参数
        Class<?>[] params = method.getParameterTypes();
        for (int index = 0; index < params.length; index++) {
            buffer.append(params[index].getName());
            if (index!=params.length-1) {
                buffer.append(", ");
            }
        }
        buffer.append(')');
        
        log(buffer.toString());
    }
    
    private static void parseField(Field field) {
        // 注解
        parseAnnotation(field);
        
        // 字段
        StringBuilder buffer = parseMember(field);
        log(buffer.toString());
    }
    
    /**
     * 解析方法、字段或构造方法的信息。
     * @param member 方法、字段或构造方法
     * @return 修饰符和名称组成的字符串。
     */
    private static StringBuilder parseMember(Member member) {
        StringBuilder buffer = new StringBuilder()
            .append(Modifier.toString(member.getModifiers()))
            .append(' ')
            .append(member.getName());
        return buffer;
    }
    
    /**
     * 解析注解信息。
     */
    private static void parseAnnotation(AnnotatedElement ae) {
        Annotation[] ans = ae.getDeclaredAnnotations();
        for (Annotation annotation : ans) {
            log(annotation.toString());
        }
    }
    
    public static void log(String msg, Object... param) {
        System.out.println( String.format(msg, param) );
    }
    
    public static void main(String[] args) throws ClassNotFoundException {
        if (args.length != 1) {
            log("无效的输入参数！");
            log("示例：");
            log("java cn.aofeng.demo.java.lang.reflect.ClassAnalyze java.util.HashMap");
        }
        Class<?> claz = Class.forName(args[0]);
        
        log("%s类%s", PREFIX, SUFFIX);
        parseClass(claz);
        
        log("%s构造方法%s", PREFIX, SUFFIX);
        Constructor<?>[] cs = claz.getDeclaredConstructors();
        for (Constructor<?> constructor : cs) {
            parseConstructor(constructor);
        }
        
        log("%s字段%s", PREFIX, SUFFIX);
        Field[] fields = claz.getDeclaredFields();
        for (Field field : fields) {
            parseField(field);
        }
        
        log("%s方法%s", PREFIX, SUFFIX);
        Method[] methods = claz.getDeclaredMethods();
        for (Method method : methods) {
            parseMethod(method);
        }
    }

}
