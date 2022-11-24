
> springboot with junit4 &junit5 https://segmentfault.com/a/1190000040803747

## 1 概述
### 多种测试模式


* @RunWith(SpringJUnit4ClassRunner.class)启动Spring上下文环境。
* @RunWith(MockitoJUnitRunner.class)mockito方法进行测试。对底层的类进行mock，测试速度快。
* @RunWith(PowerMockRunner.class)powermock方法进行测试。对底层类进行mock，测试方法更全面。

### spring-boot-starter-test
SpringBoot中有关测试的框架，主要来源于 spring-boot-starter-test。一旦依赖了spring-boot-starter-test，下面这些类库将被一同依赖进去：
* JUnit：java测试事实上的标准。
* Spring Test & Spring Boot Test：Spring的测试支持。
* AssertJ：提供了流式的断言方式。
* Hamcrest：提供了丰富的matcher。
* Mockito：mock框架，可以按类型创建mock对象，可以根据方法参数指定特定的响应，也支持对于mock调用过程的断言。
* JSONassert：为JSON提供了断言功能。
* JsonPath：为JSON提供了XPATH功能。



### junit4 & junit5对比


| 功能               | JUnit4       | JUnit5       |
|------------------|--------------|--------------|
| 声明一种测试方法         | @Test        | @Test        |
| 在当前类中的所有测试方法之前执行 | @BeforeClass | @BeforeAll   |
| 在当前类中的所有测试方法之后执行 | @AfterClass  | @AfterAll    |
| 在每个测试方法之前执行      | @Before      | @BeforeEach  |
| 在每个测试方法之后执行      | @After       | @AfterEach   |
| 禁用测试方法/类         | @Ignore      | @Disabled    |
| 测试工厂进行动态测试       | NA           | @TestFactory |
| 嵌套测试             | NA           | @Nested      |
| 标记和过滤            | @Category    | @Tag         |
| 注册自定义扩展          | NA           | @ExtendWith  |


### RunWith 和 ExtendWith

在 JUnit4 版本，在测试类加 @SpringBootTest 注解时，同样要加上 @RunWith(SpringRunner.class)才生效，即:
```
@SpringBootTest
@RunWith(SpringRunner.class)
class HrServiceTest {
...
}
```
但在 JUnit5 中，官网告知 @RunWith 的功能都被 @ExtendWith 替代，即原 @RunWith(SpringRunner.class) 被同功能的 @ExtendWith(SpringExtension.class) 替代。但 JUnit5 中 @SpringBootTest 注解中已经默认包含了 @ExtendWith(SpringExtension.class)。

因此，在 JUnit5 中只需要单独使用 @SpringBootTest 注解即可。其他需要自定义拓展的再用 @ExtendWith，不要再用 @RunWith 了。


### mockito

Mockito 框架中最核心的两个概念就是 Mock 和 Stub。测试时不是真正的操作外部资源，而是通过自定义的代码进行模拟操作。我们可以对任何的依赖进行模拟，从而使测试的行为不需要任何准备工作或者不具备任何副作用。

1. 当我们在测试时，如果只关心某个操作是否执行过，而不关心这个操作的具体行为，这种技术称为 mock。比如我们测试的代码会执行发送邮件的操作，我们对这个操作进行 mock；测试的时候我们只关心是否调用了发送邮件的操作，而不关心邮件是否确实发送出去了。

2. 另一种情况，当我们关心操作的具体行为，或者操作的返回结果的时候，我们通过执行预设的操作来代替目标操作，或者返回预设的结果作为目标操作的返回结果。这种对操作的模拟行为称为 stub（打桩）。比如我们测试代码的异常处理机制是否正常，我们可以对某处代码进行 stub，让它抛出异常。再比如我们测试的代码需要向数据库插入一条数据，我们可以对插入数据的代码进行stub，让它始终返回1，表示数据插入成功。

### powermock

需要手动引入测试类。依赖mockito，注意版本的对应关系。

```xml
<dependency>
    <groupId>org.powermock</groupId>
    <artifactId>powermock-api-mockito2</artifactId>
</dependency>

<dependency>
    <groupId>org.powermock</groupId>
    <artifactId>powermock-module-junit4</artifactId>
</dependency>

```
## 2 使用

### 注解

@RunWith：
1. 表示运行方式，@RunWith(JUnit4TestRunner)、@RunWith(SpringRunner.class)、@RunWith(PowerMockRunner.class) 三种运行方式，分别在不同的场景中使用。
2. 当一个类用@RunWith注释或继承一个用@RunWith注释的类时，JUnit将调用它所引用的类来运行该类中的测试而不是开发者去在junit内部去构建它。我们在开发过程中使用这个特性

@SpringBootTest：
1. 注解制定了一个测试类运行了Spring Boot环境。提供了以下一些特性：
   1. 当没有特定的ContextConfiguration#loader()（@ContextConfiguration(loader=...)）被定义那么就是SpringBootContextLoader作为默认的ContextLoader。
   2. 自动搜索到SpringBootConfiguration注解的文件。
   3. 允许自动注入Environment类读取配置文件。
   4. 提供一个webEnvironment环境，可以完整的允许一个web环境使用随机的端口或者自定义的端口。
   5. 注册了TestRestTemplate类可以去做接口调用。

2. 添加这个就能取到spring中的容器的实例，如果配置了@Autowired那么就自动将对象注入。

### 基本测试用例

Springboot整合JUnit的步骤
1. 导入测试对应的starter

2. 测试类使用@SpringBootTest修饰

3.使用自动装配的形式添加要测试的对象。

```java
@SpringBootTest(classes = {SpringbootJunitApplication.class})
class SpringbootJunitApplicationTests {
 
    @Autowired
    private UsersDao users;
 
    @Test
    void contextLoads() {
        users.save();
    }
 
}
```


### mock单元测试
因为单元测试不用启动 Spring 容器，则无需加 @SpringBootTest，因为要用到 Mockito，只需要自定义拓展 MockitoExtension.class 即可，依赖简单，运行速度更快。

可以明显看到，单元测试写的代码，怎么是被测试代码长度的好几倍？其实单元测试的代码长度比较固定，都是造数据和打桩，但如果针对越复杂逻辑的代码写单元测试，还是越划算的
```java
@ExtendWith(MockitoExtension.class)
class HrServiceTest {
    @Mock
    private OrmDepartmentDao ormDepartmentDao;
    @Mock
    private OrmUserDao ormUserDao;
    @InjectMocks
    private HrService hrService;

    @DisplayName("根据部门名称，查询用户")
    @Test
    void findUserByDeptName() {
        Long deptId = 100L;
        String deptName = "行政部";
        OrmDepartmentPO ormDepartmentPO = new OrmDepartmentPO();
        ormDepartmentPO.setId(deptId);
        ormDepartmentPO.setDepartmentName(deptName);
        OrmUserPO user1 = new OrmUserPO();
        user1.setId(1L);
        user1.setUsername("001");
        user1.setDepartmentId(deptId);
        OrmUserPO user2 = new OrmUserPO();
        user2.setId(2L);
        user2.setUsername("002");
        user2.setDepartmentId(deptId);
        List<OrmUserPO> userList = new ArrayList<>();
        userList.add(user1);
        userList.add(user2);

        Mockito.when(ormDepartmentDao.findOneByDepartmentName(deptName))
                .thenReturn(
                        Optional.ofNullable(ormDepartmentPO)
                                .filter(dept -> deptName.equals(dept.getDepartmentName()))
                );
        Mockito.doReturn(
                userList.stream()
                        .filter(user -> deptId.equals(user.getDepartmentId()))
                        .collect(Collectors.toList())
        ).when(ormUserDao).findByDepartmentId(deptId);

        List<OrmUserPO> result1 = hrService.findUserByDeptName(deptName);
        List<OrmUserPO> result2 = hrService.findUserByDeptName(deptName + "error");

        Assertions.assertEquals(userList, result1);
        Assertions.assertEquals(Collections.emptyList(), result2);
    }
```


### 集成单元测试
还是那个方法，如果使用Spring上下文，真实的调用方法依赖，可直接用下列方式
```java
@SpringBootTest
class HrServiceTest {
    @Autowired
    private HrService hrService;

    @DisplayName("根据部门名称，查询用户")
    @Test
    void findUserByDeptName() {
        List<OrmUserPO> userList = hrService.findUserByDeptName("行政部");
        Assertions.assertTrue(userList.size() > 0);
    }  
}
```


还可以使用@MockBean、@SpyBean替换Spring上下文中的对应的Bean：
```java
@SpringBootTest
class HrServiceTest {
    @Autowired
    private HrService hrService;
    @SpyBean
    private OrmDepartmentDao ormDepartmentDao;

    @DisplayName("根据部门名称，查询用户")
    @Test
    void findUserByDeptName() {
        String deptName="行政部";
        OrmDepartmentPO ormDepartmentPO = new OrmDepartmentPO();
        ormDepartmentPO.setDepartmentName(deptName);
        Mockito.when(ormDepartmentDao.findOneByDepartmentName(ArgumentMatchers.anyString()))
                .thenReturn(Optional.of(ormDepartmentPO));
        List<OrmUserPO> userList = hrService.findUserByDeptName(deptName);
        Assertions.assertTrue(userList.size() > 0);
    }
}
```