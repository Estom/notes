## 框架新功能

1. 基于java8，兼容jdk9

> 本质上，Spring容器的管理有三种主要的方式
> * xml配置方式，能够通过xml声明bean，并且注入bean的属性
> * 注解方式，通过@Bean@Component创建bean，通过@Autowire注入bean
> * 函数方式，同构register函数讲普通的java对象注册为bean，通过context.getBean获取

### 日志功能
自带了通用的日志封装。可以整合第三方日志工具log4j&slf4j
![](image/2022-10-12-11-30-24.png)

1. slf4j是中间层
2. log4j是日志引擎，实现了slf4j提供的接口。可以配合使用

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <appenders>
        <console name="Console" target="SYSTEM_OUT">
            <PatternLayout pattern="%d %-5p %c{2} - %m%n%throwable" charset="UTF-8"/>
        </console>


    </appenders>

    <loggers>
        <root level="info">
            <append-ref ref="Console"/>
        </root>
    </loggers>
</configuration>
```

### @Nullable

* 在属性上，属性值可以为空
* 在方法上，返回值可以为空
* 在参数中，方法参数可以为空


### 支持函数式风格

* GenericApplicationContext能将普通的Java对象注册为Bean对象
* context.getBean("com.ykl.entity.Account",Account.class);能够根据类型进行对象的装载获取
* Account account2 = context.getBean("user1",Account.class);能够根据id进行对象的装载获取。

```
    //函数式风格创建对象，交给对象进行管理
    @Test
    public void testGe(){
        GenericApplicationContext context = new GenericApplicationContext();

        context.refresh();
        context.registerBean("user1",Account.class,()->new Account());

        //根据类型获取bean（跟@Autowire一样，都是根据类型手动装载）
        Account account = context.getBean("com.ykl.entity.Account",Account.class);
        System.out.println(account);

        //根据名称获取bean(跟@Qualified一样，根据对象的id进行装配)
        Account account2 = context.getBean("user1",Account.class);
        System.out.println(account);
    }
```


## 支持JUnit5

### 支持JUnit4

1. 引入Spring中针对测试的相关依赖。Spring-test
2. 编写测试代码，添加Test支持，加载context

```
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:bean01.xml")
public class JTest4 {
    @Autowired
    private AccountService accountService;

    @Test
    public void test01(){
        accountService.pay();
    }
}
```

### 支持Junit5的Jar包

1. 引入junit5的jar包
2. 使用新的测试注解进行测试@Extended(SpringExtended.class)
3. 使用复合注解替代两个注解@SpringJunitContext()




