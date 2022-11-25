
> 参考文献https://www.zhihu.com/question/486985113/answer/2627178730
## 1 概述
### JavaSPI机制概述
Java SPI机制：SPI全称为Service Provider Interface，服务提供接口，是Java提供的一套用来被第三方实现或者扩展的API，它可以用来启用框架扩展和替换组件。

SPI就是一种将服务接口与服务实现分离以达到解耦、大大提升了程序可扩展行性的机制。引入服务提供者就是即SPI接口的实现者，通过本地注册来发现获取到具体的实现类。实现轻松可插拔。

![](image/2022-11-25-14-12-57.png)

> Java SPI本质上其实就是“基于接口编程+策略模式+配置文件”组合实现的**动态加载机制**。

> 为了实现在模块装配的时候不用在程序里动态指明，这就需要一种本地**服务发现机制**。Java spi就是提供这样的一个机制：为某个接口寻找服务实现的机制。

> JavaSpi起本身也是一种**控制反转思想**。通过额外的程序注入类的实现。包括控制反转和依赖注入两个过程。“Service Provider”和相应的工具”ServiceLoader”。其声明文件相当于Spring的Bean配置文件，实现控制反转，ServiceLoader类实现了依赖的注入。


### 底层原理


相关标准中对”Service Provider”的定义可以总结为三句话：

1. ”Service”(服务)。是一组知名的接口或(通常是抽象)类的集合，“Service Provider“(服务提供者)就是对服务的特定实现；
2. 服务提供者。通过jar包中的“META-INF/services/fully-qualified.name.of.service.Interface“文件包含实现类的完全限定名，将实现类发布为提供者；
3. 服务查找机制。通过遍历ClassPath中所有的上述文件内容，来查找并创建提供者的实例


### 应用举例
* 脚本引擎ScriptEngine,
* 字符集Charset,
* 文件系统FileSystems,
* 网络通讯NIO
* Web标准Servlet3.0, 
* 通用日志接口slf4j-api:1.3
* jdbc（Java 规定了JDBC的接口，可由不同厂商来实现MySQL,Oracle等）


## 2 使用教程

### 服务发现机制

SPI的使用当服务的提供者，提供了接口的一种实现后，需要在Jar包的**META-INF/services/**目录下，创建一个以接口的名称（包名.接口名的形式）命名的文件，在文件中配置接口的实现类（完整的包名+类名）。

当外部程序通过「java.util.ServiceLoader」类装载这个接口时，就能够通过该Jar包的**META/Services/**目录里的配置文件找到具体的实现类名，装载实例化，完成注入。

同时，SPI的规范规定了接口的实现类必须有一个无参构造方法。SPI中查找接口的实现类是通过「java.util.ServiceLoader」，而在「java.util.ServiceLoader」类中有一行代码如下：
```
// 加载具体实现类信息的前缀，也就是以接口命名的文件需要放到Jar包中的META-INF/services/目录下
private static final String PREFIX = "META-INF/services/";
```

### 创建Maven工程
1. 在IDEA中创建Maven项目spi-demo，如下：


![](image/2022-11-25-14-29-35.png)

```xml

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <artifactId>spi-demo</artifactId>
    <groupId>io.binghe.spi</groupId>
    <packaging>jar</packaging>
    <version>1.0.0-SNAPSHOT</version>
    <modelVersion>4.0.0</modelVersion>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.6.0</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```
2. 创建类加载工具。创建MyServiceLoader，MyServiceLoader类中直接调用JDK的ServiceLoader类加载Class。代码如下所示

```java
/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.alipay.ykl.spidemo;

import java.util.ServiceLoader;

/**
 * @author faran
 * @version : SpiLoader, v 0.1 2022-11-25 14:30 faran Exp $
 */
public class SpiLoader {

    /**
     * 使用SPI机制加载所有的Class
     */
    public static <S> ServiceLoader<S> loadAll(final Class<S> clazz) {
        return ServiceLoader.load(clazz);
    }

}
```

3. 创建接口服务名。创建接口MyService，作为测试接口，接口中只有一个方法，打印传入的字符串信息。
```java
/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.alipay.ykl.spidemo;

/**
 * @author faran
 * @version : SpiService, v 0.1 2022-11-25 14:32 faran Exp $
 */
public interface SpiService {

        /**
         *  打印信息
         */
        void print(String info);
}

```

4. 创建多个实现类。

```java
package com.alipay.ykl.spidemo;

/**
 * @author faran
 * @version : SpiServiceImpl1, v 0.1 2022-11-25 14:32 faran Exp $
 */
public class SpiServiceImpl1 implements SpiService{
    @Override
    public void print(String info) {
        System.out.println(SpiServiceImpl1.class.getName() + " print " + info);
    }
}
```

```java
package com.alipay.ykl.spidemo;

/**
 * @author faran
 * @version : SpiServiceImpl2, v 0.1 2022-11-25 14:33 faran Exp $
 */
public class SpiServiceImpl2 implements SpiService{
    @Override
    public void print(String info) {
        System.out.println(SpiServiceImpl2.class.getName() + " print " + info);
    }
}
```

5. 创建接口文件。在项目的src/main/resources目录下创建**META-INF/services/**目录，文件必须是接口MyService的全名，之后将实现MyService接口的类配置到文件中


```
com.alipay.ykl.spidemo.SpiServiceImpl1
com.alipay.ykl.spidemo.SpiServiceImpl2
```

6. 创建测试类

```java
package com.alipay.ykl.spidemo;

import org.junit.Test;

import java.util.ServiceLoader;
import java.util.stream.StreamSupport;

/**
 * @author faran
 * @version : SpiTest, v 0.1 2022-11-25 14:04 faran Exp $
 */
public class SpiTest {


    @Test
    public void testSpi(){
        ServiceLoader<SpiService> loader = SpiLoader.loadAll(SpiService.class);
        for (SpiService spiService : loader) {
            spiService.print("hello world");
        }

    }
}

```

7. 查看结果

```java
com.alipay.ykl.spidemo.SpiServiceImpl1 print hello world
com.alipay.ykl.spidemo.SpiServiceImpl2 print hello world

Process finished with exit code 0
```


## 3 源码解读

### java.util.SeerviceLoader

* 可以遍历。「java.util.ServiceLoader」的源码，可以看到ServiceLoader类实现了「java.lang.Iterable」接口，说明ServiceLoader类是可以遍历迭代的。
* 内部变量
```java

    private static final String PREFIX = "META-INF/services/";

    // The class or interface representing the service being loaded
    private final Class<S> service;

    // The class loader used to locate, load, and instantiate providers
    private final ClassLoader loader;

    // The access control context taken when the ServiceLoader is created
    private final AccessControlContext acc;

    // Cached providers, in instantiation order
    private LinkedHashMap<String,S> providers = new LinkedHashMap<>();

    // The current lazy-lookup iterator
    private LazyIterator lookupIterator;
```