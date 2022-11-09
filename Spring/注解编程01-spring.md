# 注解总结


> 注解位置
> 
> 类注解
> @Component、@Repository、@Controller、@Service以及JavaEE6的@ManagedBean和@Named注解
>
> 方法注解
> 
> @Bean、@Autowire、@Value、@Resource以及EJB和WebService相关的注解等
> 
> 属性注解

> 必须被扫描到的类
> 启动类@SpringBootApplication--@ComponentScan-->扫描类@Component->扫描方法@Bean

## 1 配置类相关注解
> 启动Spring扫描的基础类。

### @SpringBootApplication

@SpringBootApplication申明让spring boot自动给程序进行必要的配置，这个配置等同于：@Configuration ，@EnableAutoConfiguration 和 @ComponentScan 三个配置。

使用了此注解的类首先会让Spring Boot启动对base package以及其sub-pacakage下的类进行component scan。



### @ComponentScan
@ComponentScan主要就是定义扫描的路径从中找出标识了需要装配的类自动装配到spring的bean容器中。默认注册到了spring容器中

```java
//扫描com.demo下的组件
@ComponentScan(value="com.demo")
@Configuration
public class myConfig {
}
```

### @Configuration
Spring3.0，相当于传统的xml配置文件，如果有些第三方库需要用到xml文件，建议仍然通过@Configuration类作为项目的配置主类可以使用@ImportResource注解加载xml配置文件。

proxyBeanMethods属性默认值是true,也就是说该配置类会被代理（CGLIB），在同一个配置文件中调用其它被@Bean注解标注的方法获取对象时会直接从IOC容器之中获取。(@Bean中的参数可以获取@Autowired等，直接从SpringIOC容器红获取。)

```java
@Configuration
public class AppConfig {
    // 未指定bean 的名称，默认采用的是 "方法名" + "首字母小写"的配置方式
    @Bean
    public MyBean myBean(){
        return new MyBean();
    }
}
```


### @WishlyConfiguration
为@Configuration与@ComponentScan的组合注解，可以替代这两个注解

### @Bean
注解在方法上，声明当前方法的返回值为一个bean，替代xml中的方式（方法上）。@Bean 注解的属性有：value、name、autowire、initMethod、destroyMethod。
* name 和 value 两个属性是相同的含义的， 在代码中定义了别名。为 bean 起一个名字，如果默认没有写该属性，那么就使用方法的名称为该 bean 的名称。
* autowire指定 bean 的装配方式， 根据名称 和 根据类型 装配， 一般不设置，采用默认即可。autowire指定的装配方式 有三种Autowire.NO (默认设置)、Autowire.BY_NAME、Autowire.BY_TYPE。
* initMethod和destroyMethod指定bean的初始化方法和销毁方法， 直接指定方法名称即可，不用带括号。
```java
public class MyBean {
    public MyBean(){
        System.out.println("MyBean Initializing");
    }
    public void init(){
        System.out.println("Bean 初始化方法被调用");
    }
    public void destroy(){
        System.out.println("Bean 销毁方法被调用");
    }
}
@Configuration
public class AppConfig {
    @Bean(initMethod = "init", destroyMethod = "destroy")
    public MyBean myBean(){
        return new MyBean();
    }
}
```

### @Scope
@Scope注解是springIoc容器中的一个作用域，在 Spring IoC 容器中具有以下几种作用域：基本作用域singleton（单例）、prototype(多例)[By 博客园 GoCircle]，Web 作用域（reqeust、session、globalsession），自定义作用域。

prototype原型模式：
@Scope(value=ConfigurableBeanFactory.SCOPE_PROTOTYPE)在每次注入的时候回自动创建一个新的bean实例

* singleton单例模式：@Scope(value=ConfigurableBeanFactory.SCOPE_SINGLETON)单例模式，在整个应用中只能创建一个实例

* globalsession模式：@Scope(value=WebApplicationContext.SCOPE_GLOBAL_SESSION)全局session中的一般不常用

* Web作用域@Scope(value=WebApplicationContext.SCOPE_APPLICATION)在一个web应用中只创建一个实例

* request模式：@Scope(value=WebApplicationContext.SCOPE_REQUEST)在一个请求中创建一个实例

* session模式：@Scope(value=WebApplicationContext.SCOPE_SESSION)每次创建一个会话中创建一个实例

```java
@Configuration
public class myConfig {
    //默认是单例的。不需要特别说明
    @Bean("person")
    public Person person(){
        return new Person("binghe002", 18);
    }
}
@Configuration
public class myConfig {
    //Person对象的作用域修改成prototype,多例的
    @Scope("prototype")
    @Bean("person")
    public Person person(){
        return new Person("binghe002", 18);
    }
}
```

### 其他配置
* @StepScope 在Spring Batch中还有涉及

* @PostConstruct 由JSR-250提供，在构造函数执行完之后执行，等价于xml配置文件中bean的initMethod

* @PreDestory 由JSR-250提供，在Bean销毁之前执行，等价于xml配置文件中bean的destroyMethod

* @Conditional是Spring4新提供的注解，它的作用是按照一定的条件进行判断，满足条件给容器注册bean。

### @EnableAutoConfiguration
SpringBoot自动配置（auto-configuration）：尝试根据你添加的jar依赖自动配置你的Spring应用。

例如，如果你的classpath下存在HSQLDB，并且你没有手动配置任何数据库连接beans，那么我们将自动配置一个内存型（in-memory）数据库。

## 2 声明bean的注解
spring创建bean的注解

### @Component
@Component组件，泛指各种组件，就是说当我们的类不属于各种归类的时候（不属于@Controller、@Services等的时候），我们就可以使用@Component来标注这个类，把普通pojo实例化到spring容器中，相当于配置文件中的：`<bean id="" class=""/>`。

```java
@Component("conversionImpl")
//其实默认的spring中的Bean id 为 conversionImpl(首字母小写)
public class ConversionImpl implements Conversion {
    @Autowired
    private RedisClient redisClient;
}
```
### @Service
在业务逻辑层使用（service层）
```java
@Service()
public class UserService{
    @Resource
    private UserDao userDao;
    public void add(){
        userDao.add();
    }
}
```

### @Repository

在数据访问层使用（dao层）,在daoImpl类上面注解。

### @Controller

在表现层使用，控制器的声明


## 3 注入bean的注解
Spring注入bean的注解

### @Autowired&@Qualifier
@Autowired为Spring提供的注解，需要导入包org.springframework.beans.factory.annotation.Autowired，只按照byType注入。

可以写在字段和setter方法上。两者如果都写在字段上，那么就不需要再写setter方法。

@Autowired注解是按照类型（byType）装配依赖对象，默认情况下它要求依赖对象必须存在，如果允许null值，可以设置它的required属性为false。如果我们想使用按照名称（byName）来装配，可以结合@Qualifier注解一起使用。

```java
public class TestServiceImpl {
    // 下面两种@Autowired只要使用一种即可
    @Autowired
    private UserDao userDao; // 用于字段上
    @Autowired
    public void setUserDao(UserDao userDao) { // 用于属性的方法上
        this.userDao = userDao;
    }

    @Autowired
    @Qualifier("userDao")
    private UserDao userDao;
}
```

### @Inject&@Named
@Inject是JSR330 (Dependency Injection for Java)中的规范，需要导入javax.inject.Inject;实现注入。@Inject可以作用在变量、setter方法、构造函数上。根据类型进行自动装配的，如果需要按名称进行装配，[Power By听雨的人]则需要配合@Named。

@Named("XXX") 中的XXX是 Bean 的名称，所以 @Inject和 @Named结合使用时，自动注入的策略就从 byType 转变成 byName 了。

```
public class User{
    private Person person;
    @Inject
    pbulic void setPerson(Person person){
        this.person = person;
    }
    @Inject
    pbulic void setPerson1(@Named("main")Person person)
    {
        this.person = person;
    }
}
```

### @Resource
@Resource默认按照ByName自动注入，由J2EE提供，是JSR250规范的实现，需要导入javax.annotation实现注入。

@Resource有两个重要的属性：name(id)和type，而Spring将@Resource注解的name属性解析为bean的名字，而type属性则解析为bean的类型。所以，如果使用name属性，则使用byName的自动注入策略，而使用type属性时则使用byType自动注入策略。如果既不制定name也不制定type属性，这时将通过反射机制使用byName自动注入策略。

可以写在字段和setter方法上。两者如果都写在字段上，那么就不需要再写setter方法。

```java
public class TestServiceImpl {
    // 下面两种@Resource只要使用一种即可
    @Resource(name="userDao")
    private UserDao userDao; // 用于字段上
    @Resource(name="userDao")
    public void setUserDao(UserDao userDao) {
        // 用于属性的setter方法上
        this.userDao = userDao;
    }
}
```



## 4 @Import&@ImportResource导入Bean注解

@Import通过快速导入的方式实现把实例加入spring的IOC容器中。但应注意是@Import在使用时,必须要保证能被IOC容器扫描到，所以通常它会和@Configuration或@ComponentScan配套使用。@Import在使用时可以声明在JAVA类上，或者作为元注解使用（即声明在其他注解上）

### @Import直接导入外部类
```
public class Dog {
    public void run() {
        System.out.println("Dog run");
    }
}

@Import(Dog.class)
@Configuration
public class AppConfig {
}
// 测试类
public class annoTest {
    private static AnnotationConfigApplicationContext classPath;
    @Test
    public void testConsutrator(){
        classPath = new AnnotationConfigApplicationContext(AppConfig.class);
        Dog exampleBean = classPath.getBean(Dog.class);
        System.out.println(exampleBean);
    }
}
```

### @Import导入实现了ImportSelector的类
通过ImportSelector类能够实现多个类的导入。

* 返回值： 就是我们实际上要导入到容器中的组件全类名
* 参数： AnnotationMetadata表示当前被@Import的类上的所有注解信息
```java
public class MyImportSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata annotationMetadata) {
        Set<String> annotationTypes = annotationMetadata.getAnnotationTypes();
        for (String str:annotationTypes) {
            System.out.println(str);
        }
        return new String[]{"com.picc.spring.annotation.Dog"};
    }
}

@Import({MyImportSelector.class})
@Configuration
public class AppConfig {
}

public class annoTest {
    private static AnnotationConfigApplicationContext classPath;
    @Test
    public void testConsutrator(){
        classPath = new AnnotationConfigApplicationContext(AppConfig.class);
        Dog exampleBean = classPath.getBean(Dog.class);
        System.out.println(exampleBean);
    }
}
```


### @Import导入实现了ImportBeanDefinitionRegistrar的类
```
public class MyImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {
    @Override
    public void registerBeanDefinitions(AnnotationMetadata annotationMetadata, BeanDefinitionRegistry beanDefinitionRegistry) {
        Set<String> annotationTypes = annotationMetadata.getAnnotationTypes();
        for (String str:annotationTypes) {
            System.out.println(str);
        }
        RootBeanDefinition rootBeanDefinition = new RootBeanDefinition(Dog.class);
        beanDefinitionRegistry.registerBeanDefinition("dog",rootBeanDefinition);
    }
}

@Import({MyImportBeanDefinitionRegistrar.class})
@Configuration
public class AppConfig {
}
```


### @ImportResource导入spring配置文件


@ImportResource 注解用于导入Spring 的配置文件。使用 @ImportResource 标注在一个配置类上让 Spring 的配置文件生效。
```java
@ImportResource(locations = "classpath:applicationContext.xml")
@SpringBootApplication
@RestController
public class FirstSpringbootApplication {

    public static void main(String[] args) {
        SpringApplication.run(FirstSpringbootApplication.class, args);
    }
}
```
### @PropertySource


## 5 @Value注解
@Value的作用是通过注解将常量、配置文件中的值、其他bean的属性值注入到变量中，作为变量的初始值。

### 支持如下方式的注入：

* 注入普通字符
* 注入操作系统属性
* 注入表达式结果
* 注入其它bean属性
* 注入文件资源
* 注入网站资源
* 注入配置文件

```java
@Value("张三")
private String name; // 注入普通字符串
```
### @Value三种情况的用法。
```
${}是去找外部配置的参数，将值赋过来
#{}是SpEL表达式，去寻找对应变量的内容
#{}直接写字符串就是将字符串的值注入进去
```

```java
// 注入其他Bean属性：注入beanInject对象的属性another，类具体定义见下面
@Value("#{beanInject.another}")
private String fromAnotherBean;
// 注入操作系统属性
@Value("#{systemProperties['os.name']}")
private String systemPropertiesName;
//注入表达式结果
@Value("#{T(java.lang.Math).random() * 100.0 }")
private double randomNumber;
```




## 6 切面（AOP）相关注解

在运行时，动态地将代码切入到类的指定方法、指定位置上的编程思想就是面向切面的编程，简称AOP（aspect object programming）。

AOP编程，可以将一些系统性相关的编程工作，独立提取出来，独立实现，然后通过切面切入进系统。从而避免了在业务逻辑的代码中混入很多的系统相关的逻辑——比如权限管理，事物管理，日志记录等等。这些系统性的编程工作都可以独立编码实现，然后通过AOP技术切入进系统即可。

Spring支持AspectJ的注解式切面编程。

### @Aspect
声明一个切面（类上）

### @After、@Before、@Around、@AfterRunning、@AfterThrowing
定义通知（advice），可直接将拦截规则（切点）作为参数。
* @Before前置通知[By cnblogs.com/GoCircle], 在方法执行之前执行。
* @After后置通知, 在方法执行之后执行。
* @AfterRunning 返回通知, 在方法返回结果之后[By cnblogs.com/GoCircle]执行。
* @AfterThrowing 异常通知, 在方法抛出异常之后。
* @Around环绕通知, 围绕着方法执行。
* 
### @PointCut
声明切点。声明切点，是植入Advice（通知）的触发条件。每个Pointcut的定义包括2部分，一是表达式，二是方法签名。方法签名必须是 public及v[欢迎转载听雨的人博客]oid型。可以将Pointcut中的方法看作是一个被Advice引用的助记符，因为表达式不直观，因此我们可以通过方法签名的方式为 此表达式命名。因此Pointcut中的方法只需要方法签名，而不需要在方法体内编写实际代码。

```java
/**
 * 日志切面
 */
@Component
@Aspect
public class LoggingAspect {
    /**
     * 前置通知：目标方法执行之前执行以下方法体的内容
     */
    @Before("execution(* com.qcc.beans.aop.*.*(..))")
    public void beforeMethod(JoinPoint jp){
        String methodName = jp.getSignature().getName();
        System.out.println("【前置通知】the method 【" + methodName + "】 begins with " + Arrays.asList(jp.getArgs()));
    }
    /**
     * 返回通知：目标方法正常执行完毕时执行以下代码
     */
    @AfterReturning(value="execution(* com.qcc.beans.aop.*.*(..))",returning="result")
    public void afterReturningMethod(JoinPoint jp, Object result){
        String methodName = jp.getSignature().getName();
        System.out.println("【返回通知】the method 【" + methodName + "】 ends with 【" + result + "】");
    }
    /**
     * 后置通知：目标方法执行之后执行以下方法体的内容，不管是否发生异常。
     * @param jp
     */
    @After("execution(* com.qcc.beans.aop.*.*(..))")
    public void afterMethod(JoinPoint jp){
        System.out.println("【后置通知】this is a afterMethod advice...");
    }
    /**
     * 异常通知：目标方法发生异常的时候执行以下代码
     */
    @AfterThrowing(value="execution(* com.qcc.beans.aop.*.*(..))",throwing="e")
    public void afterThorwingMethod(JoinPoint jp, NullPointerException e){
        String methodName = jp.getSignature().getName();
        System.out.println("【异常通知】the method 【" + methodName + "】 occurs exception: " + e);
    }
}
```

### @ControllerAdvice&@ExceptionHandler（Exception.class）

相当于一个全局的切面异常类。不建议使用。

包含@Component。可以被扫描到。统一处理异常。用在方法上面表示遇到这个异常就执行以下方法。

### @EnableAspectJAutoProxy

在java配置类中使用@EnableAspectJAutoProxy注解开启Spring对AspectJ代理的支持（类上）
```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Import(AspectJAutoProxyRegistrar.class)
public @interface EnableAspectJAutoProxy {
    /**
     * Indicate whether subclass-based (CGLIB) proxies are to be created as opposed
     * to standard Java interface-based proxies. The default is {@code false}.
     */
    boolean proxyTargetClass() default false;
    /**
     * Indicate that the proxy should be exposed by the AOP framework as a {@code ThreadLocal}
     * for retrieval via the {@link org.springframework.aop.framework.AopContext} class.
     * Off by default, i.e. no guarantees that {@code AopContext} access will work.
     * @since 4.3.1
     */
    boolean exposeProxy() default false;
}
```
这里有两个方法,一个是控制aop的具体实现方[Power By听雨的人]式,为true 的话使用cglib,为false的话使用java的Proxy,默认为false,第二个参数控制代理的暴露方式,解决内部调用不能使用代理的场景，默认为false。

## 7 环境切换
@Profile

指定组件在哪个环境的情况下才能被注册到容器中，不指定，任何环境下都能注册这个组件。

@Conditional

通过实现Condition接口，并重写matches方法，从而决定该bean是否被实例化。


## 8 异步相关
@EnableAsync

配置类中通过此注解开启对异步任务的支持；

@Async

在实际执行的bean方法使用该注解来声明其是一个异步任务（方法上或类上所有的方法都将异步，需要@EnableAsync开启异步任务）

## 9 定时任务相关
@EnableScheduling

在配置类上使用，开启计划任务的支持（类上）

@Scheduled

来申明这是一个任务，包括cron,fixDelay,fixRate等类型（方法上，需先开启计划任务的支持）


## 10 属性配置相关

### @ConfigurationProperties
前缀外部属性将绑定到类的字段上

* 根据 Spring Boot 宽松的绑定规则，类的属性名称必须与外部属性的名称匹配。我们可以简单地用一个值初始化一个字段来定义一个默认值
* 类本身可以是包私有的类的字段必须有公共setter 方法
* 激活 @ConfigurationProperties。只有当类所在的包被 Spring @ComponentScan 注解扫描到才会生效。

可以通过添加 @Component 注解让 ComponentScan 扫描到。

```java
@Component
@ConfigurationProperties(prefix = "demo")
class DemoProperties {
}
```


## 11 Enable***注解说明
这些注解主要是用来开启对xxx的支持：

@EnableAspectAutoProxy：开启对AspectJ自动代理的支持；
@EnableAsync：开启异步方法的支持；
@EnableScheduling：开启计划任务的支持；
@EnableWebMvc：开启web MVC的配置支持；
@EnableConfigurationProperties：开启对@ConfigurationProperties注解配置Bean的支持；
@EnableJpaRepositories：开启对SpringData JPA Repository的支持；
@EnableTransactionManagement：开启注解式事务的支持；
@EnableCaching：开启注解式的缓存支持；

## 12 测试相关注解
@RunWith

运行器，Spring中通常用于对JUnit的支持

@ContextConfiguration

用来加载配置配置文件，其中classes属性用来加载配置类。

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath*:/*.xml"})
public class CDPlayerTest {
 
}
@ContextConfiguration这个注解通常与@RunWith(SpringJUnit4ClassRunner.class)联合使用用来测试。

@ContextConfiguration括号里的locations = {"classpath*:/*.xml"}就表示将classpath路径里所有的xml文件都包括进来，自动扫描的bean就可以拿到，此时就可以在测试类中使用@Autowired注解来获取之前自动扫描包下的所有bean。


## 13 事务注解

### @EnableTransactionManagement
在入口处增加 @EnableTransactionManagement 注解
```java
package com.cm.aps;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableTransactionManagement
public class ApsApplication {
    public static void main(String[] args) {
        SpringApplication.run(ApsApplication.class, args);
    }
}
```

### @Transactional 
@Transactional 注解放在类级别时，表示所有该类的公共方法都配置相同的事务属性信息。当类级别配置了@Transactional，方法级别也配置了@Transactional，应用程序会以方法级别的事务属性信息来管理事务。

| 属性名 | 说明 |
|--|--|
| name |	当在配置文件中有多个 TransactionManager , 可以用该属性指定选择哪个事务管理器。|
| propagation | 事务的传播行为，默认值为 REQUIRED。|
| isolation	| 事务的隔离度，默认值采用 DEFAULT。
| timeout | 事务的超时时间，默认值为-1。如果超过该时间限制但事务还没有完成，则自动回滚事务。|
| read-only	 | 指定事务是否为只读事务，默认值为 false；为了忽略那些不需要事务的方法，比如读取数据，可以设置 read-only 为 true。|
| rollback-for | 用于指定能够触发事务回滚的异常类型，如果有多个异常类型需要指定，各类型之间可以通过逗号分隔。|
| no-rollback-for | 抛出 no-rollback-for 指定的异常类型，不回滚事务。

```java
@Override
@Transactional(rollbackFor = Exception.class)  //这里回滚进行定义
public int update(Prdtv prdtv) throws RuntimeException{
    //注意在这里处理业务时，不要使用Try ...异常捕获，否则不回滚
    return prdtvMapper.update(prdtv);
}
```
## 14 json常用注解
### @JsonIgnoreProperties
此注解是类注解，作用是json序列化时将java bean中的一些属性忽略掉，序列化和反序列化都受影响。

写法将此标签加在user类的类名上 ，可以多个属性也可以单个属性。
```
//生成json时将name和age属性过滤
@JsonIgnoreProperties({"name"},{"age"})
public class  user {
 
    private  String name;
    private int age;
}
```
### @JsonIgnore
此注解用于属性或者方法上（最好是属性上），作用和上面的@JsonIgnoreProperties一样。
```
//生成json 时不生成age 属性
public class user {
 
    private String name;
    @JsonIgnore
    private int age;
}
```
### @JsonFormat
此注解用于属性或者方法上（最好是属性上），可以方便的把Date类型直接转化为我们想要的模式，比如：
```
public class User{
    @JsonFormat(pattern = “yyyy-MM-dd HH-mm-ss”)
    private Date date;
}
```
### @JsonSerialize
此注解用于属性或者getter方法上，用于在序列化时嵌入我们自定义的代码，比如序列化一个double时在其后面限制两位小数点。

### @JsonDeserialize
此注解用于属性或者setter方法上，用于在反序列化时可以嵌入我们自定义的代码，类似于上面的@JsonSerialize

### @Transient
如果一个属性并非数据库表的字段映射，就务必将其标示为@Transient，否则ORM框架默认其注解为@Basic；

### @JsonIgnoreType
标注在类上，当其他类有该类作为属性时，该属性将被忽略。

### @JsonProperty
@JsonProperty 可以指定某个属性和json映射的名称。例如我们有个json字符串为{“user_name”:”aaa”}，
而java中命名要遵循驼峰规则，则为userName，这时通过@JsonProperty 注解来指定两者的映射规则即可。这个注解也比较常用。
```
public class SomeEntity {
    @JsonProperty("user_name")
    private String userName;
}
```
### @JsonPropertyOrder
只在序列化情况下生效的注解

在将 java pojo 对象序列化成为 json 字符串时，使用 @JsonPropertyOrder 可以指定属性在 json 字符串中的顺序。

### @JsonInclude
只在序列化情况下生效的注解

在将 java pojo 对象序列化成为 json 字符串时，使用 @JsonInclude 注解可以控制在哪些情况下才将被注解的属性转换成 json，例如只有属性不为 null 时。

### @JsonInclude(JsonInclude.Include.NON_NULL)
只在序列化情况下生效的注解

这个注解放在类头上，返给前端的json里就没有null类型的字段，即实体类与json互转的时候 属性值为null的不参与序列化。
另外还有很多其它的范围，例如 NON_EMPTY、NON_DEFAULT等

### @JsonSetter
在反序列化情况下生效的注解
@JsonSetter 标注于 setter 方法上，类似 @JsonProperty ，也可以解决 json 键名称和 java pojo 字段名称不匹配的问题。
