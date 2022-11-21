# Bean配置文件


> * bean配置文件：spring配置bean的文件。
>   * java配置文件，通过@Configuration加载
>   * 原生配置文件，xml定义的配置文件
> * 属性配置文件：spring配置key-value的文件


## 1 注解说明

### 注解体系
1. 元注解@Rentention @Docemented,@Inherited,@Target
2. JDK标准注解
3. Spring标准注解@Bean @Component @Serivce,@Controller,@Configuration,@Import,@Autowire
4. springboot补充注解

### @SpringbootConfiguration开启自动配置

```
@SpringBootConfiguration  springboot启动
@EnableAutoConfiguration  通过properties自动加载
@ComponentScan("com.atguigu.boot")扫描范围
```

springboot项目中的启动注解。

### @Configuration配置文件
1. 配置类里边使用@Bean标注在方法上，给容器注册组件，默认也是单实例模式。
2. 配置类本身也是组件，相当于将组件注册到Spring当中。即把类的对象交给Spring管理。
3. proxybeanMethods:代理bean方法，将配置类的中的方法设置为单例模式。可以解决组件间的依赖问题。默认为true，使用spring中的方法代理原方法，不会创建新的对象。
   1. full（proxyBeanMehtods=true）
   2. lite（proxyBeanMethods=false)

```java
@Configuration(proxyBeanMethods = false) //告诉SpringBoot这是一个配置类 == 配置文件
public class MyConfig {

    /**
     * Full:外部无论对配置类中的这个组件注册方法调用多少次获取的都是之前注册容器中的单实例对象
     * @return
     */
    @Bean //给容器中添加组件。以方法名作为组件的id。返回类型就是组件类型。返回的值，就是组件在容器中的实例
    public User user01(){
        User zhangsan = new User("zhangsan", 18);
        //user组件依赖了Pet组件
        zhangsan.setPet(tomcatPet());
        return zhangsan;
    }

    @Bean("tom")
    public Pet tomcatPet(){
        return new Pet("tomcat");
    }
}


################################@Configuration测试代码如下########################################
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan("com.atguigu.boot")
public class MainApplication {

    public static void main(String[] args) {
        //1、返回我们IOC容器
        ConfigurableApplicationContext run = SpringApplication.run(MainApplication.class, args);

        //2、查看容器里面的组件
        String[] names = run.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }

        //3、从容器中获取组件

        Pet tom01 = run.getBean("tom", Pet.class);

        Pet tom02 = run.getBean("tom", Pet.class);

        System.out.println("组件："+(tom01 == tom02));


        //4、com.atguigu.boot.config.MyConfig$$EnhancerBySpringCGLIB$$51f1e1ca@1654a892
        MyConfig bean = run.getBean(MyConfig.class);
        System.out.println(bean);

        //如果@Configuration(proxyBeanMethods = true)代理对象调用方法。SpringBoot总会检查这个组件是否在容器中有。
        //保持组件单实例
        User user = bean.user01();
        User user1 = bean.user01();
        System.out.println(user == user1);


        User user01 = run.getBean("user01", User.class);
        Pet tom = run.getBean("tom", Pet.class);

        System.out.println("用户的宠物："+(user01.getPet() == tom));



    }
}
```
### @Bean 
在java配置文件中装配bean
1. 配置类实用@Bean标注方法上给容器注册组件，默认也是单实例。id默认为方法名。可以通过参数指定
2. 外部类可以从Spring的容器中取出在Configuration类中注册的实例。而且都是单实例对象。

```
@Component @Controller @Service @Repository 都是以前的用法
```

### @Import 
在java配置文件中导入bean

1. 将指定的组件导入到组件。给容器中自动创建指定类型的无参构造的组件。
2. 默认组件的名字是全类名。即包括包和类的名字。
```java
@Import({User.class, DBHelper.class})
@Configuration(proxyBeanMethods = false) //告诉SpringBoot这是一个配置类 == 配置文件
public class MyConfig {
}
```

三种导入类的方法对比

* 每个bean有名称和类型。没有id之说。名称必须唯一。
* @Bean导入的bena默认名称是方法名称
* @Import导入的bean默认是全类名
* @Component导入的bean默认是类名小写首字母。
* @Component和@Import是不会冲突，如果已经通过@Component导入的bean（优先级更高）不会通过@Import重复导入


### ImportResource 

导入原生配置文件
```xml
======================beans.xml=========================
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">

    <bean id="haha" class="com.atguigu.boot.bean.User">
        <property name="name" value="zhangsan"></property>
        <property name="age" value="18"></property>
    </bean>

    <bean id="hehe" class="com.atguigu.boot.bean.Pet">
        <property name="name" value="tomcat"></property>
    </bean>
</beans>
```


```java
@ImportResource("classpath:beans.xml")
public class MyConfig {}

======================测试=================
        boolean haha = run.containsBean("haha");
        boolean hehe = run.containsBean("hehe");
        System.out.println("haha："+haha);//true
        System.out.println("hehe："+hehe);//true
```
### @conditional
1. 条件装配。满足Conditional指定的条件，则进行组件注入。
![](image/2022-11-12-15-49-46.png)

* @ConditionalOnBean(name="bean")当容器中存在指定名称的容器的时候，才会进行注册。

```xml
@=====================测试条件装配==========================
@Configuration(proxyBeanMethods = false) //告诉SpringBoot这是一个配置类 == 配置文件
//@ConditionalOnBean(name = "tom")
@ConditionalOnMissingBean(name = "tom")
public class MyConfig {


    /**
     * Full:外部无论对配置类中的这个组件注册方法调用多少次获取的都是之前注册容器中的单实例对象
     * @return
     */

    @Bean //给容器中添加组件。以方法名作为组件的id。返回类型就是组件类型。返回的值，就是组件在容器中的实例
    public User user01(){
        User zhangsan = new User("zhangsan", 18);
        //user组件依赖了Pet组件
        zhangsan.setPet(tomcatPet());
        return zhangsan;
    }

    @Bean("tom22")
    public Pet tomcatPet(){
        return new Pet("tomcat");
    }
}

public static void main(String[] args) {
        //1、返回我们IOC容器
        ConfigurableApplicationContext run = SpringApplication.run(MainApplication.class, args);

        //2、查看容器里面的组件
        String[] names = run.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }

        boolean tom = run.containsBean("tom");
        System.out.println("容器中Tom组件："+tom);

        boolean user01 = run.containsBean("user01");
        System.out.println("容器中user01组件："+user01);

        boolean tom22 = run.containsBean("tom22");
        System.out.println("容器中tom22组件："+tom22);


    }
```