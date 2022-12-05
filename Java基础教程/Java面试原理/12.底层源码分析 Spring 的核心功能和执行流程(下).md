# 底层源码分析 Spring 的核心功能和执行流程(下)

上一课时我们讲了 Bean 相关的内容，它其实也是属于 IOC 的具体实现之一，本课时我们就来讲讲 Spring 中其他几个高频的面试点，希望能起到抛砖引玉的作用，能为你理解 Spring 打开一扇门。因为 Spring 涉及的内容和知识点太多了，用它来写一本书也绰绰有余，因此这里我们只讲核心的内容，希望下来你能查漏补缺，完善自己的 Spring 技术栈。

我们本课时的面试题是，谈一谈你对 IOC 和 DI 的理解。

## 典型回答

**IOC**（Inversion of Control，翻译为“控制反转”）不是一个具体的技术，而是一种设计思想。与传统控制流相比，IOC 会颠倒控制流，在传统的编程中需要开发者自行创建并销毁对象，而在 IOC 中会把这些操作交给框架来处理，这样开发者就不用关注具体的实现细节了，拿来直接用就可以了，这就是控制反转。

IOC 很好的体现出了面向对象的设计法则之一——好莱坞法则：“别找我们，我们找你”。即由 IOC 容器帮对象找到相应的依赖对象并注入，而不是由对象主动去找。

举个例子，比如说传统找对象，先要设定好你的要求，如身高、体重、长相等，然后再一个一个的主动去找符合要求的对象，而 IOC 相当于，你把这些要求直接告诉婚介中心，由他们直接给你匹配到符合要求的对象，理想情况下是直接会帮你找到合适的对象，这就是传统编程模式和 IOC 的区别。

**DI**（Dependency Injection，翻译为“依赖注入”）表示组件间的依赖关系交由容器在运行期自动生成，也就是说，由容器动态的将某个依赖关系注入到组件之中，这样就能提升组件的重用频率。通过依赖注入机制，我们只需要通过简单的配置，就可指定目标需要的资源，完成自身的业务逻辑，而不需要关心资源来自哪里、由谁实现等问题。

IOC 和 DI 其实是同一个概念从不同角度的描述的，由于控制反转这个概念比较含糊（可能只理解成了容器控制对象这一个层面，很难让人想到谁来维护对象关系），所以 2004 年被开发者尊称为“教父”的 Martin Fowler（世界顶级专家，敏捷开发方法的创始人之一）又给出了一个新的名字“依赖注入”，相对 IOC 而言，“依赖注入”明确描述了“被注入对象依赖 IOC 容器配置依赖对象”。

## 考点分析

IOC 和 DI 为 Spring 框架设计的精髓所在，也是面试中必问的考点之一，这个优秀的设计思想对于初学者来说可能理解起来比较困难，但对于 Spring 的使用者来说可以很快的看懂。因此如果对于此概念还有疑问的话，建议先上手使用 Spring 实现几个小功能再回头来看这些概念，相信你会豁然开朗。

Spring 相关的高频面试题，还有以下这些：

* Spring IOC 有哪些优势？
* IOC 的注入方式有哪些？
* 谈一谈你对 AOP 的理解。

# 知识扩展

## 1.Spring IOC 的优点
IOC 的优点有以下几个：

* 使用更方便，拿来即用，无需显式的创建和销毁的过程；
* 可以很容易提供众多服务，比如事务管理、消息服务等；
* 提供了单例模式的支持；
* 提供了 AOP 抽象，利用它很容易实现权限拦截、运行期监控等功能；
* 更符合面向对象的设计法则；
* 低侵入式设计，代码的污染极低，降低了业务对象替换的复杂性。

## 2.Spring IOC 注入方式汇总
IOC 的注入方式有三种：构造方法注入、Setter 注入和接口注入。

### 1.构造方法注入

构造方法注入主要是依赖于构造方法去实现，构造方法可以是有参的也可以是无参的，我们平时 new 对象时就是通过类的构造方法来创建类对象的，每个类对象默认会有一个无参的构造方法，Spring 通过构造方法注入的代码示例如下：

```java
public class Person {
    public Person() {
	}
	public Person(int id, String name) {
		this.id = id;
		this.name = name;
	}
	private int id;
	private String name;
    // 忽略 Setter、Getter 的方法
}
```

applicationContext.xml 配置如下：

```xml
<bean id="person" class="org.springframework.beans.Person">
    <constructor-arg value="1" type="int"></constructor-arg>
    <constructor-arg value="Java" type="java.lang.String"></constructor-arg>
</bean>
```

### 2.Setter注入

Setter 方法注入的方式是目前 Spring 主流的注入方式，它可以利用 Java Bean 规范所定义的 Setter/Getter 方法来完成注入，可读性和灵活性都很高，它不需要使用声明式构造方法，而是使用 Setter 注入直接设置相关的值，实现示例如下：

```xml
<bean id="person" class="org.springframework.beans.Person">
    <property name="id" value="1"/>
    <property name="name" value="Java"/>
</bean>
```

### 3.接口注入

接口注入方式是比较古老的注入方式，因为它需要被依赖的对象实现不必要的接口，带有侵入性，因此现在已经被完全舍弃了，所以本文也不打算做过多的描述，大家只要知道有这回事就行了。

## 3.Spring AOP

AOP（Aspect-Oriented-Programming，面向切面编程）可以说是 OOP（Object-Oriented Programing，面向对象编程）的补充和完善，OOP 引入封装、继承和多态性等概念来建立一种公共对象处理的能力，当我们需要处理公共行为的时候，OOP 就会显得无能为力，而 AOP 的出现正好解决了这个问题。比如统一的日志处理模块、授权验证模块等都可以使用 AOP 很轻松的处理。

Spring AOP 目前提供了三种配置方式：

* 基于 Java API 的方式；
* 基于 @AspectJ（Java）注解的方式；
* 基于 XML` <aop /> `标签的方式。

### 1.基于Java API的方式

此配置方式需要实现相关的接口，例如 `MethodBeforeAdvice` 和 `AfterReturningAdvice`，并且在 XML 配置中定义相应的规则即可实现。

我们先来定义一个实体类，代码如下：

```java
package org.springframework.beans;


public class Person {
   public Person findPerson() {
      Person person = new Person(1, "JDK");
      System.out.println("findPerson 被执行");
      return person;
   }
   public Person() {
   }
   public Person(Integer id, String name) {
      this.id = id;
      this.name = name;
   }
   private Integer id;
   private String name;
   // 忽略 Getter、Setter 方法
}
```

再定义一个 advice 类，用于对拦截方法的调用之前和调用之后进行相关的业务处理，实现代码如下：

```java
import org.springframework.aop.AfterReturningAdvice;
import org.springframework.aop.MethodBeforeAdvice;

import java.lang.reflect.Method;

public class MyAdvice implements MethodBeforeAdvice, AfterReturningAdvice {
   @Override
   public void before(Method method, Object[] args, Object target) throws Throwable {
      System.out.println("准备执行方法: " + method.getName());
   }

   @Override
   public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
      System.out.println(method.getName() + " 方法执行结束");
   }
```

然后需要在 application.xml 文件中配置相应的拦截规则，配置如下：

```xml
<!-- 定义 advisor -->
<bean id="myAdvice" class="org.springframework.advice.MyAdvice"></bean>
<!-- 配置规则，拦截方法名称为 find* -->
<bean class="org.springframework.aop.support.RegexpMethodPointcutAdvisor">
    <property name="advice" ref="myAdvice"></property>
    <property name="pattern" value="org.springframework.beans.*.find.*"></property>
</bean>

<!-- 定义 DefaultAdvisorAutoProxyCreator 使所有的 advisor 配置自动生效 -->
<bean class="org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator"></bean>
```

从以上配置中可以看出，我们需要配置一个拦截方法的规则，然后定义一个 DefaultAdvisorAutoProxyCreator 让所有的 advisor 配置自动生效。

最后，我们使用测试代码来完成调用：

```java
public class MyApplication {
   public static void main(String[] args) {
      ApplicationContext context =
            new ClassPathXmlApplicationContext("classpath*:application.xml");
      Person person = context.getBean("person", Person.class);
      person.findPerson();
   }
}
```

以上程序的执行结果为：

```
准备执行方法: findPerson
findPerson 被执行
findPerson 方法执行结束
```

可以看出 AOP 的拦截已经成功了。

### 2.基于@AspectJ注解的方式

首先需要在项目中添加 aspectjweaver 的 jar 包，配置如下：

```xml
<!-- https://mvnrepository.com/artifact/org.aspectj/aspectjweaver -->
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.5</version>
</dependency>
```

此 jar 包来自于 AspectJ，因为 Spring 使用了 AspectJ 提供的一些注解，因此需要添加此 jar 包。之后，我们需要开启 @AspectJ 的注解，开启方式有两种。

可以在 application.xml 配置如下代码中开启 @AspectJ 的注解：

```xml
<aop:aspectj-autoproxy/>
```

也可以使用 `@EnableAspectJAutoProxy`注解开启，代码如下：

```java
@Configuration
@EnableAspectJAutoProxy
public class AppConfig {
}
```

之后我们需要声明拦截器的类和拦截方法，以及配置相应的拦截规则，代码如下：

```java
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;

@Aspect
public class MyAspectJ {

   // 配置拦截类 Person
   @Pointcut("execution(* org.springframework.beans.Person.*(..))")
   public void pointCut() {
   }

   @Before("pointCut()")
   public void doBefore() {
      System.out.println("执行 doBefore 方法");
   }

   @After("pointCut()")
   public void doAfter() {
      System.out.println("执行 doAfter 方法");
   }
}
```

然后我们只需要在 application.xml 配置中添加注解类，配置如下：

```xml
<bean class="org.springframework.advice.MyAspectJ"/>
```

紧接着，我们添加一个需要拦截的方法：

```java
package org.springframework.beans;

// 需要拦截的 Bean
public class Person {
   public Person findPerson() {
      Person person = new Person(1, "JDK");
      System.out.println("执行 findPerson 方法");
      return person;
   }
    // 获取其他方法
}
```

最后，我们开启测试代码：

```java
import org.springframework.beans.Person;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MyApplication {
   public static void main(String[] args) {
      ApplicationContext context =
            new ClassPathXmlApplicationContext("classpath*:application.xml");
      Person person = context.getBean("person", Person.class);
      person.findPerson();
   }
}
```

以上程序的执行结果为：

```
执行 doBefore 方法
执行 findPerson 方法
执行 doAfter 方法
```

可以看出 AOP 拦截成功了。

### 3.基于 XML `<aop />` 标签的方式

基于 XML 的方式与基于注解的方式类似，只是无需使用注解，把相关信息配置到 application.xml 中即可，配置如下：

```xml
<!-- 拦截处理类 -->
<bean id="myPointcut" class="org.springframework.advice.MyPointcut"></bean>
<aop:config>
    <!-- 拦截规则配置 -->
    <aop:pointcut id="pointcutConfig"
                    expression="execution(* org.springframework.beans.Person.*(..))"/>
    <!-- 拦截方法配置 -->
    <aop:aspect ref="myPointcut">
        <aop:before method="doBefore" pointcut-ref="pointcutConfig"/>
        <aop:after method="doAfter" pointcut-ref="pointcutConfig"/>
    </aop:aspect>
</aop:config>
```

之后，添加一个普通的类来进行拦截业务的处理，实现代码如下：

```java
public class MyPointcut {
   public void doBefore() {
      System.out.println("执行 doBefore 方法");
   }
   public void doAfter() {
      System.out.println("执行 doAfter 方法");
   }
}
```

拦截的方法和测试代码与第二种注解的方式相同，这里就不在赘述。

最后执行程序，执行结果为：

```
执行 doBefore 方法
执行 findPerson 方法
执行 doAfter 方法
```

可以看出 AOP 拦截成功了。

Spring AOP 的原理其实很简单，它其实就是一个动态代理，我们在调用 getBean() 方法的时候返回的其实是代理类的实例，而这个代理类在 Spring 中使用的是 JDK Proxy 或 CgLib 实现的，它的核心代码在 DefaultAopProxyFactory#createAopProxy(...) 中，源码如下：

```java
public class DefaultAopProxyFactory implements AopProxyFactory, Serializable {

	@Override
	public AopProxy createAopProxy(AdvisedSupport config) throws AopConfigException {
		if (config.isOptimize() || config.isProxyTargetClass() || hasNoUserSuppliedProxyInterfaces(config)) {
			Class<?> targetClass = config.getTargetClass();
			if (targetClass == null) {
				throw new AopConfigException("TargetSource cannot determine target class: " +
						"Either an interface or a target is required for proxy creation.");
			}
            // 判断目标类是否为接口
			if (targetClass.isInterface() || Proxy.isProxyClass(targetClass)) {
                // 是接口使用 jdk 的代理
				return new JdkDynamicAopProxy(config);
			}
            // 其他情况使用 CgLib 代理
			return new ObjenesisCglibAopProxy(config);
		}
		else {
			return new JdkDynamicAopProxy(config);
		}
	}
    // 忽略其他代码
}
```

# 小结

本课时讲了 IOC 和 DI 概念，以及 IOC 的优势和 IOC 注入的三种方式：构造方法注入、Setter 注入和接口注入，最后讲了 Spring AOP 的概念与它的三种配置方式：基于 Java API 的方式、基于 Java 注解的方式和基于 XML 标签的方式。