# 动态代理是如何实现的？JDK Proxy 和 CGLib 有什么区别？

90% 的程序员直接或者间接的使用过动态代理，无论是日志框架或 Spring 框架，它们都包含了动态代理的实现代码。动态代理是程序在运行期间动态构建代理对象和动态调用代理方法的一种机制。

我们本课时的面试题是，如何实现动态代理？JDK Proxy 和 CGLib 有什么区别？

## 典型回答

动态代理的常用实现方式是反射。反射机制是指程序在运行期间可以访问、检测和修改其本身状态或行为的一种能力，使用反射我们可以调用任意一个类对象，以及类对象中包含的属性及方法。

但动态代理不止有反射一种实现方式，例如，动态代理可以通过 CGLib 来实现，而 CGLib 是基于 ASM（一个 Java 字节码操作框架）而非反射实现的。简单来说，动态代理是一种行为方式，而反射或 ASM 只是它的一种实现手段而已。

JDK Proxy 和 CGLib 的区别主要体现在以下几个方面：

* JDK Proxy 是 Java 语言自带的功能，无需通过加载第三方类实现；
* Java 对 JDK Proxy 提供了稳定的支持，并且会持续的升级和更新 JDK Proxy，例如 Java 8 版本中的 JDK Proxy 性能相比于之前版本提升了很多；
* JDK Proxy 是通过拦截器加反射的方式实现的；
* JDK Proxy 只能代理继承接口的类；
* JDK Proxy 实现和调用起来比较简单；
* CGLib 是第三方提供的工具，基于 ASM 实现的，性能比较高；
* CGLib 无需通过接口来实现，它是通过实现子类的方式来完成调用的。

## 考点分析

本课时考察的是你对反射、动态代理及 CGLib 的了解，很多人经常会把反射和动态代理划为等号，但从严格意义上来说，这种想法是不正确的，真正能搞懂它们之间的关系，也体现了你扎实 Java 的基本功。和这个问题相关的知识点，还有以下几个：

* 你对 JDK Proxy 和 CGLib 的掌握程度。
* Lombok 是通过反射实现的吗？
* 动态代理和静态代理有什么区别？
* 动态代理的使用场景有哪些？
* Spring 中的动态代理是通过什么方式实现的？

# 知识扩展

## 1. JDK Proxy 和 CGLib 的使用及代码分析

### JDK Proxy 动态代理实现

JDK Proxy 动态代理的实现无需引用第三方类，只需要实现 InvocationHandler 接口，重写 invoke() 方法即可，整个实现代码如下所示：

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * JDK Proxy 相关示例
 */
public class ProxyExample {
    static interface Car {
        void running();
    }

    static class Bus implements Car {
        @Override
        public void running() {
            System.out.println("The bus is running.");
        }
    }

    static class Taxi implements Car {
        @Override
        public void running() {
            System.out.println("The taxi is running.");
        }
    }

    /**
     * JDK Proxy
     */
    static class JDKProxy implements InvocationHandler {
        private Object target; // 代理对象

        // 获取到代理对象
        public Object getInstance(Object target) {
            this.target = target;
            // 取得代理对象
            return Proxy.newProxyInstance(target.getClass().getClassLoader(),
                    target.getClass().getInterfaces(), this);
        }

        /**
         * 执行代理方法
         * @param proxy  代理对象
         * @param method 代理方法
         * @param args   方法的参数
         * @return
         * @throws InvocationTargetException
         * @throws IllegalAccessException
         */
        @Override
        public Object invoke(Object proxy, Method method, Object[] args)
                throws InvocationTargetException, IllegalAccessException {
            System.out.println("动态代理之前的业务处理.");
            Object result = method.invoke(target, args); // 执行调用方法（此方法执行前后，可以进行相关业务处理）
            return result;
        }
    }

    public static void main(String[] args) {
        // 执行 JDK Proxy
        JDKProxy jdkProxy = new JDKProxy();
        Car carInstance = (Car) jdkProxy.getInstance(new Taxi());
        carInstance.running();
    }
```

以上程序的执行结果是：

```
动态代理之前的业务处理.
The taxi is running.
```

可以看出 JDK Proxy 实现动态代理的核心是实现 Invocation 接口，我们查看 Invocation 的源码，会发现里面其实只有一个 invoke() 方法，源码如下：

```java
public interface InvocationHandler {
  public Object invoke(Object proxy, Method method, Object[] args)
          throws Throwable;
}
```

这是因为在动态代理中有一个重要的角色也就是代理器，它用于统一管理被代理的对象，显然 InvocationHandler 就是这个代理器，而 invoke() 方法则是触发代理的执行方法，我们通过实现 Invocation 接口来拥有动态代理的能力。

### CGLib 的实现

在使用 CGLib 之前，我们要先在项目中引入 CGLib 框架，在 pom.xml 中添加如下配置：

```xml
<!-- https://mvnrepository.com/artifact/cglib/cglib -->
<dependency>
    <groupId>cglib</groupId>
    <artifactId>cglib</artifactId>
    <version>3.3.0</version>
</dependency>
```

CGLib 实现代码如下：

```java
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

import java.lang.reflect.Method;

public class CGLibExample {

    static class Car {
        public void running() {
            System.out.println("The car is running.");
        }
    }

    /**
     * CGLib 代理类
     */
    static class CGLibProxy implements MethodInterceptor {
        private Object target; // 代理对象

        public Object getInstance(Object target) {
            this.target = target;
            Enhancer enhancer = new Enhancer();
            // 设置父类为实例类
            enhancer.setSuperclass(this.target.getClass());
            // 回调方法
            enhancer.setCallback(this);
            // 创建代理对象
            return enhancer.create();
        }

        @Override
        public Object intercept(Object o, Method method,
                                Object[] objects, MethodProxy methodProxy) throws Throwable {
            System.out.println("方法调用前业务处理.");
            Object result = methodProxy.invokeSuper(o, objects); // 执行方法调用
            return result;
        }
    }

    // 执行 CGLib 的方法调用
    public static void main(String[] args) {
        // 创建 CGLib 代理类
        CGLibProxy proxy = new CGLibProxy();
        // 初始化代理对象
        Car car = (Car) proxy.getInstance(new Car());
        // 执行方法
        car.running();
    }
```

以上程序的执行结果是：

```
方法调用前业务处理.
The car is running.
```

可以看出 CGLib 和 JDK Proxy 的实现代码比较类似，都是通过实现代理器的接口，再调用某一个方法完成动态代理的，唯一不同的是，CGLib 在初始化被代理类时，是通过 Enhancer 对象把代理对象设置为被代理类的子类来实现动态代理的。因此被代理类不能被关键字 final 修饰，如果被 final 修饰，再使用 Enhancer 设置父类时会报错，动态代理的构建会失败。

## 2. Lombok 原理分析
在开始讲 Lombok 的原理之前，我们先来简单地介绍一下 Lombok，它属于 Java 的一个热门工具类，使用它可以有效的解决代码工程中那些繁琐又重复的代码，如 Setter、Getter、toString、equals 和 hashCode 等等，向这种方法都可以使用 Lombok 注解来完成。

例如，我们使用比较多的 Setter 和 Getter 方法，在没有使用 Lombok 之前，代码是这样的：

```java
public class Person {
    private Integer id;
    private String name;
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
```

在使用 Lombok 之后，代码是这样的：

```java
@Data
public class Person {
    private Integer id;
    private String name;
}
```

可以看出 Lombok 让代码简单和优雅了很多。

> 小贴士：如果在项目中使用了 Lombok 的 Getter 和 Setter 注解，那么想要在编码阶段成功调用对象的 set 或 get 方法，我们需要在 IDE 中安装 Lombok 插件才行，比如 Idea 的插件如下图所示：
>
> ![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200606112218.png)

接下来讲讲 Lombok 的原理。

Lombok 的实现和反射没有任何关系，前面我们说了反射是程序在运行期的一种自省（introspect）能力，而 Lombok 的实现是在编译期就完成了，为什么这么说呢？

回到我们刚才 Setter/Getter 的方法，当我们打开 Person 的编译类就会发现，使用了 Lombok 的 @Data 注解后的源码竟然是这样的：

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200606112319.png)

可以看出 Lombok 是在编译期就为我们生成了对应的字节码。

其实 Lombok 是基于 Java 1.6 实现的 JSR 269: Pluggable Annotation Processing API 来实现的，也就是通过编译期自定义注解处理器来实现的，它的执行步骤如下：

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200606112419.png)

从流程图中可以看出，在编译期阶段，当 Java 源码被抽象成语法树（AST）之后，Lombok 会根据自己的注解处理器动态修改 AST，增加新的代码（节点），在这一切执行之后就生成了最终的字节码（.class）文件，这就是 Lombok 的执行原理。

## 3.动态代理知识点扩充

当面试官问动态代理的时候，经常会问到它和静态代理的区别？静态代理其实就是事先写好代理类，可以手工编写也可以使用工具生成，但它的缺点是每个业务类都要对应一个代理类，特别不灵活也不方便，于是就有了动态代理。

动态代理的常见使用场景有 RPC 框架的封装、AOP（面向切面编程）的实现、JDBC 的连接等。

Spring 框架中同时使用了两种动态代理 JDK Proxy 和 CGLib，当 Bean 实现了接口时，Spring 就会使用 JDK Proxy，在没有实现接口时就会使用 CGLib，我们也可以在配置中指定强制使用 CGLib，只需要在 Spring 配置中添加 `<aop:aspectj-autoproxy proxy-target-class="true"/> `即可。

# 小结
本课时我们介绍了 JDK Proxy 和 CGLib 的区别，JDK Proxy 是 Java 语言内置的动态代理，必须要通过实现接口的方式来代理相关的类，而 CGLib 是第三方提供的基于 ASM 的高效动态代理类，它通过实现被代理类的子类来实现动态代理的功能，因此被代理的类不能使用 final 修饰。

除了 JDK Proxy 和 CGLib 之外，我们还讲了 Java 中常用的工具类 Lombok 的实现原理，它其实和反射是没有任何关系的；最后讲了动态代理的使用场景以及 Spring 中动态代理的实现方式。