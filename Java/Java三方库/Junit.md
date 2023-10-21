## 1 概述

### 是什么

https://blog.csdn.net/weixin_43498556/article/details/120839089

JUnit是Java编程语言的单元测试框架，用于编写和可重复运行的自动化测试。


1. 编码完成就可以立刻测试，尽早发现问题
2. 将测试保存成为了代码，可以随时快速执行
3. 可以嵌入持续集成流水线，自动为每次代码修改保驾护航


### 注意事项

* 测试方法必须使用 @Test 修饰
* 测试方法必须使用 public void 进行修饰，不能带参数
* 一般使用单元测试会新建一个 test 目录存放测试代码，在生产部署的时候只需要将 test 目录下代码删除即可
* 测试代码的包应该和被测试代码包结构保持一致
* 测试单元中的每个方法必须可以独立测试，方法间不能有任何依赖
* 测试类一般使用 Test 作为类名的后缀
* 测试方法使一般用 test 作为方法名的前缀

### 测试失败


* Failure：一般是由于测试结果和预期结果不一致引发的，表示测试的这个点发现了问题
* Error：是由代码异常引起的，它可以产生于测试代码本身的错误，也可以是被测试代码中隐藏的 bug


## 2 无框架使用


### 创建 Test Case 类

1. 创建一个名为 TestJunit.java 的测试类。
2. 向测试类中添加名为 testPrintMessage() 的方法。
3. 向方法中添加 Annotaion @Test。
4. 执行测试条件并且应用 Junit 的 assertEquals API 来检查。
```java
import org.junit.Test;
import static org.junit.Assert.assertEquals;
public class TestJunit {

   String message = "Hello World";  
   MessageUtil messageUtil = new MessageUtil(message);

   @Test
   public void testPrintMessage() {
      assertEquals(message,messageUtil.printMessage());
   }
}
```


### 创建 Test Runner 类
> 不与springboot/maven框架兼容运行时，需要创建字的测试启动类。
> 如果是用maven插件，代码会帮忙自动执行所有的测试类。如果没有maven插件，则需要自己创建TestRunner类，启动测试过程。仍旧是java体系下的基本方法。

1. 创建一个 TestRunner 类
2. 运用 JUnit 的 JUnitCore 类的 runClasses 方法来运行上述测试类的测试案例
3. 获取在 Result Object 中运行的测试案例的结果
4. 获取 Result Object 的 getFailures() 方法中的失败结果
5. 获取 Result object 的 wasSuccessful() 方法中的成功结果

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(TestJunit.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
}  
```

## 3 Junit4使用


### 3.1 注解

* @Test:将一个普通方法修饰成一个测试方法 @Test(excepted=xx.class): xx.class 表示异常类，表示测试的方法抛出此异常时，认为是正常的测试通过的 @Test(timeout = 毫秒数) :测试方法执行时间是否符合预期
* @BeforeClass： 会在所有的方法执行前被执行，static 方法 （全局只会执行一次，而且是第一个运行）
* @AfterClass：会在所有的方法执行之后进行执行，static 方法 （全局只会执行一次，而且是最后一个运行）
* @Before：会在每一个测试方法被运行前执行一次
* @After：会在每一个测试方法运行后被执行一次
* @Ignore：所修饰的测试方法会被测试运行器忽略
* @RunWith：可以更改测试运行器 org.junit.runner.Runner
* @Parameters：参数化注解
* @SuiteClasses 用于套件测试



### 3.2 断言

* assertEquals
* assertNotEquals
* assertFalse
* assertTrue
* assertNotNull
* assertNull
* assertArrayEquals
* assertSame
* assertNotSame
* assertThat
* assertThrowss

```java

public class AssertTests {
  @Test
  public void testAssertArrayEquals() {
    byte[] expected = "trial".getBytes();
    byte[] actual = "trial".getBytes();
    assertArrayEquals("failure - byte arrays not same", expected, actual);
  }

  @Test
  public void testAssertEquals() {
    assertEquals("failure - strings are not equal", "text", "text");
  }

  @Test
  public void testAssertFalse() {
    assertFalse("failure - should be false", false);
  }

  @Test
  public void testAssertNotNull() {
    assertNotNull("should not be null", new Object());
  }

  @Test
  public void testAssertNotSame() {
    assertNotSame("should not be same Object", new Object(), new Object());
  }

  @Test
  public void testAssertNull() {
    assertNull("should be null", null);
  }

  @Test
  public void testAssertSame() {
    Integer aNumber = Integer.valueOf(768);
    assertSame("should be same", aNumber, aNumber);
  }

  // JUnit Matchers assertThat
  @Test
  public void testAssertThatBothContainsString() {
    assertThat("albumen", both(containsString("a")).and(containsString("b")));
  }

  @Test
  public void testAssertThatHasItems() {
    assertThat(Arrays.asList("one", "two", "three"), hasItems("one", "three"));
  }

  @Test
  public void testAssertThatEveryItemContainsString() {
    assertThat(Arrays.asList(new String[] { "fun", "ban", "net" }), everyItem(containsString("n")));
  }

  // Core Hamcrest Matchers with assertThat
  @Test
  public void testAssertThatHamcrestCoreMatchers() {
    assertThat("good", allOf(equalTo("good"), startsWith("good")));
    assertThat("good", not(allOf(equalTo("bad"), equalTo("good"))));
    assertThat("good", anyOf(equalTo("bad"), equalTo("good")));
    assertThat(7, not(CombinableMatcher.<Integer> either(equalTo(3)).or(equalTo(4))));
    assertThat(new Object(), not(sameInstance(new Object())));
  }

  @Test
  public void testAssertTrue() {
    assertTrue("failure - should be true", true);
  }
}
```
### 3.3 测试执行顺序

```java
import org.junit.*;

/**
 * JunitTest
 *
 * @author Brian Tse
 * @since 2021/10/19 9:10
 */
public class JunitTest {

    @BeforeClass
    public static void beforeClass() {
        System.out.println("@BeforeClass --> 全局只会执行一次，而且是第一个运行");
    }

    @AfterClass
    public static void afterClass() {
        System.out.println("@AfterClass --> 全局只会执行一次，而且是最后一个运行");
    }

    @Before
    public void before() {
        System.out.println("@Before --> 在测试方法运行之前运行（每个测试方法之前都会执行一次）");
    }

    @After
    public void after() {
        System.out.println("@After --> 在测试方法运行之后允许（每个测试方法之后都会执行一次）");
    }

    @Test
    public void testCase1() {
        System.out.println("@Test --> 测试方法1");
    }

    @Test
    public void testCase2() {
        System.out.println("@Test --> 测试方法2");
    }

}
```

### 3.4 异常测试

### 3.5 忽略测试
带有@Ignore注解的测试方法不会被执行

```java
    @Ignore
    @Test
    public void testCase2() {
        System.out.println("@Test --> 测试方法2");
    }
```
### 3.6 超时测试

JUnit提供了一个超时选项，如果一个测试用例比起指定的毫秒数花费了更多的时间，那么JUnit将自动将它标记为失败，timeout参数和@Test注解一起使用，例如@Test(timeout=1000)。 继续使用刚才的例子，现在将testCase1的执行时间延长到2000毫秒，并加上时间参数,设置超时为1000毫秒，然后执行测试类
```
@Test(timeout = 1000)
    public void testCase1() throws InterruptedException {
        TimeUnit.SECONDS.sleep(2);
        System.out.println("@Test --> 测试方法1");
    }
```


### 3.7 参数化测试
JUnit 4引入了一项名为参数化测试的新功能。参数化测试允许开发人员使用不同的值反复运行相同的测试。创建参数化测试需要遵循五个步骤:

1. 使用@RunWith（Parameterized.class）注释测试类。
2. 创建一个使用@Parameters注释的公共静态方法，该方法返回一个对象集合作为测试数据集。
3. 创建一个公共构造函数，它接受相当于一行“测试数据”的内容。
4. 为测试数据的每个“列”创建一个实例变量。
5. 使用实例变量作为测试数据的来源创建测试用例。
6. 对于每行数据，将调用一次测试用例。让我们看看参数化测试的实际效果。
```java
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.Collection;

import static org.junit.Assert.assertEquals;

/**
 * PrimeNumberCheckerTest
 *
 * @author Brian Tse
 * @since 2021/10/19 10:44
 */
//使用 @RunWith（Parameterized.class）注释测试类
@RunWith(Parameterized.class)
public class PrimeNumberCheckerTest {

    // 为测试数据的每个“列”创建一个实例变量
    private Integer inputNumber;
    private Boolean expectedResult;
    private PrimeNumberChecker primeNumberChecker;

    @Before
    public void initialize() {
        primeNumberChecker = new PrimeNumberChecker();
    }

    // 创建一个公共构造函数，它接受相当于一行“测试数据”的内容
    public PrimeNumberCheckerTest(Integer inputNumber, Boolean expectedResult) {
        this.inputNumber = inputNumber;
        this.expectedResult = expectedResult;
    }

    //创建一个使用 @Parameters注释的公共静态方法，该方法返回一个对象集合作为测试数据集
    @Parameterized.Parameters
    public static Collection primeNumbers() {
        return Arrays.asList(new Object[][]{{2, true}, {6, false}, {19, true}, {22, false}, {23, true}});
    }

    @Test
    public void testPrimeNumberChecker() {
        // 使用实例变量作为测试数据的来源创建测试用例
        System.out.println("Parameterized Number is : " + inputNumber);
        assertEquals(expectedResult, primeNumberChecker.validate(inputNumber));
    }
}
```

结果如下

```java
Parameterized Number is : 2

Parameterized Number is : 6

Parameterized Number is : 19

Parameterized Number is : 22

Parameterized Number is : 23
```



## 4 异常测试用例

如何验证代码是否按预期抛出异常？验证代码是否正常完成很重要，但确保代码在异常情况下按预期运行也很重要。


### assertThrows方法
Unit 4.13版本可以使用assertThrows方法。此方法可以断言给定的函数调用（例如，指定为lambda表达式或方法引用）会导致引发特定类型的异常。此外，它还返回抛出的异常，以便进一步断言（例如，验证抛出的消息和原因是否符合预期）。此外，可以在引发异常后对域对象的状态进行断言。


```
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;

/**
 * ExceptionTest
 *
 * @author Brian Tse
 * @since 2021/10/19 9:25
 */
public class ExceptionTest {

    @Test
    public void testExceptionAndState() {
        List<Object> list = new ArrayList<>();
        // 可以断言给定的函数调用会导致引发特定类型的异常
        IndexOutOfBoundsException thrown = assertThrows(
                IndexOutOfBoundsException.class,
                () -> list.add(1, new Object()));

        // 根据返回抛出的异常，进一步断言抛出的消息和原因是否符合预期
        assertEquals("Index: 1, Size: 0", thrown.getMessage());
        // 在引发异常后对域对象的状态进行断言
        assertTrue(list.isEmpty());
    }
}

```


### Try/Catch 语句
如果项目中尚未使用JUnit 4.13或代码库不支持lambdas，则可以使用JUnit 3.x中流行的try/catch习惯用法：
```
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.fail;

/**
 * ExceptionTest
 *
 * @author Brian Tse
 * @since 2021/10/19 9:25
 */
public class ExceptionTest {

    @Test
    public void testExceptionAndState() {
        List<Object> list = new ArrayList<>();

        try {
            Object o = list.get(0);
            fail("Expected an IndexOutOfBoundsException to be thrown");
        } catch (IndexOutOfBoundsException anIndexOutOfBoundsException) {
            assertThat(anIndexOutOfBoundsException.getMessage(), is("Index: 0, Size: 0"));
        }
    }
}
```


### expected 参数和 @Test 注释一起使用
Junit 用代码处理提供了一个追踪异常的选项。你可以测试代码是否它抛出了想要得到的异常。expected 参数和 @Test 注释一起使用。现在让我们看看 @Test(expected)。

```java
import org.junit.Test;

import java.util.ArrayList;

/**
 * ExceptionTest
 *
 * @author Brian Tse
 * @since 2021/10/19 9:25
 */
public class ExceptionTest {

    @Test(expected = IndexOutOfBoundsException.class)
    public void testExceptionAndState() {
        new ArrayList<Object>().get(0);
    }
}

```
应谨慎使用’expected’参数。如果方法中的any代码抛出’IndexOutOfBoundsException’，则上述测试将通过。使用该方法，无法测试异常中消息的值，或引发异常后域对象的状态


## 5 assertThat和Matchers
### assertThat
此断言语法的优点包括：更具可读性和可键入性。

JUnit中的部分断言的可读性并不是很好，有时我们不得不自己编写表达式并断言其结果，并且因为我们没有提供失败的信息，当这个断言失败时只会抛出java.lang.AssertionError，无法知道到底是哪一部分出错。
```
assertTrue(responseString.contains("color") || responseString.contains("colour"));
// ==> failure message: 
// java.lang.AssertionError:

assertThat(responseString, anyOf(containsString("color"), containsString("colour")));
// ==> failure message:
// java.lang.AssertionError: 
// Expected: (a string containing "color" or a string containing "colour")
//      but: was "responseString字符串"
```

JUnit4.4引入了Hamcrest框架，Hamcest提供了一套匹配符Matcher，这些匹配符更接近自然语言，可读性高，更加灵活。并且使用全新的断言语法：assertThat，结合Hamcest提供的匹配符，只用这一个方法，就可以实现所有的测试。

assertThat语法如下：
```java
assertThat(T actual, Matcher matcher);
assertThat(String reason, T actual, Matcher matcher);
```
其中reason为断言失败时的输出信息，actual为断言的值或对象，matcher为断言的匹配器，里面的逻辑决定了给定的actual对象满不满足断言。

JUnit4的匹配器定义在org.hamcrest.CoreMatchers 和 org.junit.matchers.JUnitMatchers 中。通过静态导入的方式引入相应的匹配器。

### JUnitMatchers
org.junit.matchers.JUnitMatchers比较器中大部分都被标记为Deprecated，并使用org.hamcrest.CoreMatchers对应方法进行取代，但有两个方法得到了保留：
```java
static <T extends Exception> Matcher<T> isException(Matcher<T> exceptionMatcher)
static <T extends Throwable> Matcher<T> isThrowable Matcher<T> throwableMatcher)
```
### CoreMatchers
Hamcrest CoreMatchers在JUnit4.9版本被包含在JUnit的分发包中。

```java
@Test
public void test() {
	
	// 一般匹配符
    // allOf：所有条件必须都成立，测试才通过
    assertThat(actual, allOf(greaterThan(1), lessThan(3)));
    // anyOf：只要有一个条件成立，测试就通过
    assertThat(actual, anyOf(greaterThan(1), lessThan(1)));
    // anything：无论什么条件，测试都通过
    assertThat(actual, anything());
    // is：变量的值等于指定值时，测试通过
    assertThat(actual, is(2));
    // not：和is相反，变量的值不等于指定值时，测试通过
    assertThat(actual, not(1));
	
	// 数值匹配符
    // closeTo：浮点型变量的值在3.0±0.5范围内，测试通过
    assertThat(actual, closeTo(3.0, 0.5));
    // greaterThan：变量的值大于指定值时，测试通过
    assertThat(actual, greaterThan(3.0));
    // lessThan：变量的值小于指定值时，测试通过
    assertThat(actual, lessThan(3.5));
    // greaterThanOrEuqalTo：变量的值大于等于指定值时，测试通过
    assertThat(actual, greaterThanOrEqualTo(3.3));
    // lessThanOrEqualTo：变量的值小于等于指定值时，测试通过
    assertThat(actual, lessThanOrEqualTo(3.4));
	
	// 字符串匹配符
    // containsString：字符串变量中包含指定字符串时，测试通过
    assertThat(actual, containsString("ci"));
    // startsWith：字符串变量以指定字符串开头时，测试通过
    assertThat(actual, startsWith("Ma"));
    // endsWith：字符串变量以指定字符串结尾时，测试通过
    assertThat(actual, endsWith("i"));
    // euqalTo：字符串变量等于指定字符串时，测试通过
    assertThat(actual, equalTo("Magci"));
    // equalToIgnoringCase：字符串变量在忽略大小写的情况下等于指定字符串时，测试通过
    assertThat(actual, equalToIgnoringCase("magci"));
    // equalToIgnoringWhiteSpace：字符串变量在忽略头尾任意空格的情况下等于指定字符串时，测试通过
    assertThat(actual, equalToIgnoringWhiteSpace(" Magci   "));

    // 集合匹配符
    // hasItem：Iterable变量中含有指定元素时，测试通过
    assertThat(actual, hasItem("Magci"));
    // hasEntry：Map变量中含有指定键值对时，测试通过
    assertThat(actual, hasEntry("mgc", "Magci"));
    // hasKey：Map变量中含有指定键时，测试通过
    assertThat(actual, hasKey("mgc"));
    // hasValue：Map变量中含有指定值时，测试通过
    assertThat(actual, hasValue("Magci"));
}
```



## 6 Springboot & Junit

### 步骤
1. 导入Springboot相关的依赖，spring-boot-starter
2. 写测试类，添加@SpringbootTest。该注解能够增加Spring的上下文，及@Autowire进行bean的注入。
3. 写测试方法，添加@Test注解，填写测试用例。通过Assertions方法，进行断言。
4. @BeforeEach、@BeforeAll、@AfterEach、@AfterAll。能够在不同阶段执行相关的操作。
5. 通过MockBean添加mock规则。使用when().thenReturn()方法进行mock掉一个bean的所有方法。可以在@BeforeEach中执行mock方法，或者@BeforeAll中执行。没配置的规则，返回默认值。
6. 通过Spybean进行部分注Mock。首先注入bean，只mock配置规则的部分，没有配置规则的部分使用原来的方法。


### 实例
```java
/**
 * 类上面的两个注解不能缺少
 *@RunWith(SpringRunner.class)
 *@SpringBootTest(classes = 启动类（引导类）.class)
 * 当此测试类所在的包与启动类所在的包：在同一级包下或是启动类所在包的子包
 *测试方法的注解不能缺少
 *@Test
 *直接注入UserService对象就能够实现测试接口的调用，记得加@Autowired。
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = SpringbootTestApplication.class)
public class UserServiceImplTest {
 
    @Autowired
    private UserService userService;
 
    @Test
    public void addUser() {
        String str = "哈希辣妈";
        int i = userService.addUser(str);
        System.out.println("返回结果：" + i);
    }
}
```




