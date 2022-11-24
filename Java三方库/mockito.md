
> 官网http://mockito.org/
> API http://docs.mockito.googlecode.com/hg/org/mockito/Mockito.html
> 抄笔记，https://www.letianbiji.com/java-mockito/mockito-test-isolate.html
## 基本概念
### 单元测试UT
工作一段时间后，才真正意识到代码质量的重要性。虽然囫囵吞枣式地开发，表面上看来速度很快，但是给后续的维护与拓展制造了很多隐患。
作为一个想专业但还不专业的程序员，通过构建覆盖率比较高的单元测试用例，可以比较显著地提高代码质量。如后续需求变更、版本迭代时，重新跑一次单元测试即可校验自己的改动是否正确。

### 是什么

Mockito是mocking框架，它让你用简洁的API做测试。而且Mockito简单易学，它可读性强和验证语法简洁。

### Stub和Mock异同
相同：Stub和Mock都是模拟外部依赖
不同：Stub是完全模拟一个外部依赖， 而Mock还可以用来判断测试通过还是失败 


### 与Junit框架一同使用

请MockitoAnnotations.initMocks(testClass); 必须至少使用一次。 要处理注释，我们可以使用内置的运行器MockitoJUnitRunner或规则MockitoRule 。 我们还可以在@Before注释的Junit方法中显式调用initMocks()方法。
```java
//1
@RunWith(MockitoJUnitRunner.class)
public class ApplicationTest {
    //code
}
//2
public class ApplicationTest {
    @Rule public MockitoRule rule = MockitoJUnit.rule().strictness(Strictness.STRICT_STUBS);
 
    //code
}
//3
public class ApplicationTest {
    @Before
    public void init() {
        MockitoAnnotations.initMocks(this);
    }
}
```

使得@Mock和@Spy等注解生效

### 使用限制

* 不能mock静态方法
* 不能mock private方法
* 不能mock final class

## 2 使用教程

### 添加依赖
> 在spring-boot-starter-test中包含这两个依赖
```xml
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-all</artifactId>
    <version>1.9.5</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.11</version>
    <scope>test</scope>
</dependency>
```


### 添加引用

```java

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;
```

### 典型事例
```java
package demo;

import org.junit.Assert;
import org.junit.Test;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class ExampleServiceTest {

    @Test
    public void test() {
        // 创建mock对象
        HttpService mockHttpService = mock(HttpService.class);
        // 使用 mockito 对 queryStatus 方法打桩
        when(mockHttpService.queryStatus()).thenReturn(1);
        // 调用 mock 对象的 queryStatus 方法，结果永远是 1
        Assert.assertEquals(1, mockHttpService.queryStatus());

        ExampleService exampleService = new ExampleService();
        exampleService.setHttpService(mockHttpService);
        Assert.assertEquals("Hello", exampleService.hello() );
    }

}
```

1. 通过 mock 函数生成了一个 HttpService 的 mock 对象（这个对象是动态生成的）。

2. 通过 when .. thenReturn 指定了当调用 mock对象的 queryStatus 方法时，返回 1 ，这个叫做打桩。

3. 然后将 mock 对象注入到 exampleService 中，exampleService.hello() 的返回永远是 Hello。


4. mock 对象的方法的返回值默认都是返回类型的默认值。例如，返回类型是 int，默认返回值是 0；返回类型是一个类，默认返回值是 null。


### mock 类


```java
import org.junit.Assert;
import org.junit.Test;
import java.util.Random;

import static org.mockito.Mockito.*;

public class MockitoDemo {

    @Test
    public void test() {
        Random mockRandom = mock(Random.class);

        System.out.println( mockRandom.nextBoolean() );
        System.out.println( mockRandom.nextInt() );
        System.out.println( mockRandom.nextDouble() );
    }
}
    @Test
    public void when_thenReturn(){
        //mock一个Iterator类
        Iterator iterator = mock(Iterator.class);
        //预设当iterator调用next()时第一次返回hello，第n次都返回world
        when(iterator.next()).thenReturn("hello").thenReturn("world");
        //使用mock的对象
        String result = iterator.next() + " " + iterator.next() + " " + iterator.next();
        //验证结果
        assertEquals("hello world world",result);
    }
```


### mock接口

```java
import org.junit.Assert;
import org.junit.Test;

import java.util.List;

import static org.mockito.Mockito.*;

public class MockitoDemo {


    @Test
    public void test() {
        List mockList = mock(List.class);

        Assert.assertEquals(0, mockList.size());
        Assert.assertEquals(null, mockList.get(0));

        mockList.add("a");  // 调用 mock 对象的写方法，是没有效果的

        Assert.assertEquals(0, mockList.size());      // 没有指定 size() 方法返回值，这里结果是默认值
        Assert.assertEquals(null, mockList.get(0));   // 没有指定 get(0) 返回值，这里结果是默认值

        when(mockList.get(0)).thenReturn("a");          // 指定 get(0)时返回 a

        Assert.assertEquals(0, mockList.size());        // 没有指定 size() 方法返回值，这里结果是默认值
        Assert.assertEquals("a", mockList.get(0));      // 因为上面指定了 get(0) 返回 a，所以这里会返回 a

        Assert.assertEquals(null, mockList.get(1));     // 没有指定 get(1) 返回值，这里结果是默认值
    }
}
```

### @Mock注解

@Mock 注解可以理解为对 mock 方法的一个替代。

使用该注解时，要使用MockitoAnnotations.initMocks 方法，让注解生效。

```java
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Random;

import static org.mockito.Mockito.*;

public class MockitoDemo {

    @Mock
    private Random random;

    @Before
    public void before() {
        // 让注解生效
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void test() {
        when(random.nextInt()).thenReturn(100);

        Assert.assertEquals(100, random.nextInt());
    }

}
```

## 3 when参数匹配
参数匹配器可以用在when和verify的方法中。


### 精确匹配

其中when(mockList.get(0)).thenReturn("a"); 指定了get(0)的返回值，这个 0 就是参数的精确匹配。我们还可以让不同的参数对应不同的返回值，例如：

```java
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.List;

import static org.mockito.Mockito.*;

public class MockitoDemo {

    @Mock
    private List<String> mockStringList;

    @Before
    public void before() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void test() {

        mockStringList.add("a");

        when(mockStringList.get(0)).thenReturn("a");
        when(mockStringList.get(1)).thenReturn("b");

        Assert.assertEquals("a", mockStringList.get(0));
        Assert.assertEquals("b", mockStringList.get(1));

    }

}
```

### 模糊匹配

可以使用 Mockito.anyInt() 匹配所有类型为 int 的参数：



```java
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.List;

import static org.mockito.Mockito.*;

public class MockitoDemo {

    @Mock
    private List<String> mockStringList;

    @Before
    public void before() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void test() {

        mockStringList.add("a");

        when(mockStringList.get(anyInt())).thenReturn("a");  // 使用 Mockito.anyInt() 匹配所有的 int

        Assert.assertEquals("a", mockStringList.get(0)); 
        Assert.assertEquals("a", mockStringList.get(1));

    }

    @Test
    public void mockStudent() {
        Student student = mock(Student.class);

        student.sleep(1, "1", "admin");

        verify(student).sleep(anyInt(), anyString(), eq("admin"));
        verify(student).sleep(anyInt(), anyString(), eq("admin"));
    }
}
```


## 4 then返回值
### thenReturn 设置方法的返回值
thenReturn 用来指定特定函数和参数调用的返回值。

比如：
```java
import org.junit.Assert;
import org.junit.Test;
import static org.mockito.Mockito.*;

import java.util.Random;

public class MockitoDemo {

    @Test
    public void test() {

        Random mockRandom = mock(Random.class);

        when(mockRandom.nextInt()).thenReturn(1);

        Assert.assertEquals(1, mockRandom.nextInt());

    }

}
```
thenReturn 中可以指定多个返回值。在调用时返回值依次出现。若调用次数超过返回值的数量，再次调用时返回最后一个返回值。
```java
import org.junit.Assert;
import org.junit.Test;
import static org.mockito.Mockito.*;

import java.util.Random;

public class MockitoDemo {

    @Test
    public void test() {
        Random mockRandom = mock(Random.class);

        when(mockRandom.nextInt()).thenReturn(1, 2, 3);

        Assert.assertEquals(1, mockRandom.nextInt());
        Assert.assertEquals(2, mockRandom.nextInt());
        Assert.assertEquals(3, mockRandom.nextInt());
        Assert.assertEquals(3, mockRandom.nextInt());
        Assert.assertEquals(3, mockRandom.nextInt());
    }

}
```

###  thenThrow 让方法抛出异常
thenThrow 用来让函数调用抛出异常。
```java
import org.junit.Assert;
import org.junit.Test;
import static org.mockito.Mockito.*;

import java.util.Random;

public class MockitoDemo {

    @Test
    public void test() {

        Random mockRandom = mock(Random.class);

        when(mockRandom.nextInt()).thenThrow(new RuntimeException("异常"));

        try {
            mockRandom.nextInt();
            Assert.fail();  // 上面会抛出异常，所以不会走到这里
        } catch (Exception ex) {
            Assert.assertTrue(ex instanceof RuntimeException);
            Assert.assertEquals("异常", ex.getMessage());
        }

    }

}
```
thenThrow 中可以指定多个异常。在调用时异常依次出现。若调用次数超过异常的数量，再次调用时抛出最后一个异常。
```java
import org.junit.Assert;
import org.junit.Test;
import static org.mockito.Mockito.*;

import java.util.Random;

public class MockitoDemo {

    @Test
    public void test() {

        Random mockRandom = mock(Random.class);

        when(mockRandom.nextInt()).thenThrow(new RuntimeException("异常1"), new RuntimeException("异常2"));

        try {
            mockRandom.nextInt();
            Assert.fail();
        } catch (Exception ex) {
            Assert.assertTrue(ex instanceof RuntimeException);
            Assert.assertEquals("异常1", ex.getMessage());
        }

        try {
            mockRandom.nextInt();
            Assert.fail();
        } catch (Exception ex) {
            Assert.assertTrue(ex instanceof RuntimeException);
            Assert.assertEquals("异常2", ex.getMessage());
        }


    }

}
```


### then、thenAnswer 自定义方法处理逻辑
then 和 thenAnswer 的效果是一样的。它们的参数是实现 Answer 接口的对象，在改对象中可以获取调用参数，自定义返回值

```java
import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.when;

public class MockitoDemo {

    static class ExampleService {

        public int add(int a, int b) {
            return a+b;
        }

    }

    @Mock
    private ExampleService exampleService;

    @Test
    public void test() {

        MockitoAnnotations.initMocks(this);

        when(exampleService.add(anyInt(),anyInt())).thenAnswer(new Answer<Integer>() {
            @Override
            public Integer answer(InvocationOnMock invocation) throws Throwable {
                Object[] args = invocation.getArguments();
                // 获取参数
                Integer a = (Integer) args[0];
                Integer b = (Integer) args[1];

                // 根据第1个参数，返回不同的值
                if (a == 1) {
                    return 9;
                }
                if (a == 2) {
                    return 99;
                }
                if (a == 3) {
                    throw new RuntimeException("异常");
                }
                return 999;
            }
        });

        Assert.assertEquals(9, exampleService.add(1, 100));
        Assert.assertEquals(99, exampleService.add(2, 100));

        try {
            exampleService.add(3, 100);
            Assert.fail();
        } catch (RuntimeException ex) {
            Assert.assertEquals("异常", ex.getMessage());
        }
    }


}
```

## 5 verify校验操作


使用 verify 可以校验 mock 对象是否发生过某些操作
示例
```java
import org.junit.Test;

import static org.mockito.Mockito.*;

public class MockitoDemo {

    static class ExampleService {

        public int add(int a, int b) {
            return a+b;
        }

    }

    @Test
    public void test() {

        ExampleService exampleService = mock(ExampleService.class);

        // 设置让 add(1,2) 返回 100
        when(exampleService.add(1, 2)).thenReturn(100);

        exampleService.add(1, 2);

        // 校验是否调用过 add(1, 2) -> 校验通过
        verify(exampleService).add(1, 2);

        // 校验是否调用过 add(2, 2) -> 校验不通过
        verify(exampleService).add(2, 2);

    }

}
```
verify 配合 time 方法，可以校验某些操作发生的次数
示例：
```java
import org.junit.Test;

import static org.mockito.Mockito.*;

public class MockitoDemo {

    static class ExampleService {

        public int add(int a, int b) {
            return a+b;
        }

    }

    @Test
    public void test() {

        ExampleService exampleService = mock(ExampleService.class);

        // 第1次调用
        exampleService.add(1, 2);

        // 校验是否调用过一次 add(1, 2) -> 校验通过
        verify(exampleService, times(1)).add(1, 2);

        // 第2次调用
        exampleService.add(1, 2);

        // 校验是否调用过两次 add(1, 2) -> 校验通过
        verify(exampleService, times(2)).add(1, 2);

    }

}
```

## 6 Spy

spy 和 mock不同，不同点是：
* spy 的参数是对象示例，mock 的参数是 class。
* 被 spy 的对象，调用其方法时默认会走真实方法。mock 对象不会。

### Spy对象
```java
import org.junit.Assert;
import org.junit.Test;
import static org.mockito.Mockito.*;


class ExampleService {

    int add(int a, int b) {
        return a+b;
    }

}

public class MockitoDemo {

    // 测试 spy
    @Test
    public void test_spy() {

        ExampleService spyExampleService = spy(new ExampleService());

        // 默认会走真实方法
        Assert.assertEquals(3, spyExampleService.add(1, 2));

        // 打桩后，不会走了
        when(spyExampleService.add(1, 2)).thenReturn(10);
        Assert.assertEquals(10, spyExampleService.add(1, 2));

        // 但是参数比匹配的调用，依然走真实方法
        Assert.assertEquals(3, spyExampleService.add(2, 1));

    }

    // 测试 mock
    @Test
    public void test_mock() {

        ExampleService mockExampleService = mock(ExampleService.class);

        // 默认返回结果是返回类型int的默认值
        Assert.assertEquals(0, mockExampleService.add(1, 2));

    }


}
```


### @Spy
spy 对应注解 @Spy，和 @Mock 是一样用的。
```java
import org.junit.Assert;
import org.junit.Test;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;

import static org.mockito.Mockito.*;


class ExampleService {

    int add(int a, int b) {
        return a+b;
    }

}

public class MockitoDemo {

    @Spy
    private ExampleService spyExampleService;

    @Test
    public void test_spy() {

        MockitoAnnotations.initMocks(this);

        Assert.assertEquals(3, spyExampleService.add(1, 2));

        when(spyExampleService.add(1, 2)).thenReturn(10);
        Assert.assertEquals(10, spyExampleService.add(1, 2));

    }

}
```

### @Spy初始化

对于@Spy，如果发现修饰的变量是 null，会自动调用类的无参构造函数来初始化。如果没有无参构造函数，必须使用写法2。

```
// 写法1
@Spy
private ExampleService spyExampleService;

// 写法2
@Spy
private ExampleService spyExampleService = new ExampleService();
```

## 7 @InjectMocks

mockito 会将 @Mock、@Spy 修饰的对象自动注入到 @InjectMocks 修饰的对象中。

注入方式有多种，mockito 会按照下面的顺序尝试注入：

* 构造函数注入
* 设值函数注入（set函数）
* 属性注入


package demo;

import java.util.Random;

public class HttpService {

    public int queryStatus() {
        // 发起网络请求，提取返回结果
        // 这里用随机数模拟结果
        return new Random().nextInt(2);
    }

}
package demo;

public class ExampleService {

    private HttpService httpService;

    public String hello() {
        int status = httpService.queryStatus();
        if (status == 0) {
            return "你好";
        }
        else if (status == 1) {
            return "Hello";
        }
        else {
            return "未知状态";
        }
    }

}
编写测试类：
```java
import org.junit.Assert;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.when;


public class ExampleServiceTest {

    @Mock
    private HttpService httpService;

    @InjectMocks
    private ExampleService exampleService = new ExampleService(); // 会将 httpService 注入进去

    @Test
    public void test01() {

        MockitoAnnotations.initMocks(this);

        when(httpService.queryStatus()).thenReturn(0);

        Assert.assertEquals("你好", exampleService.hello());

    }

}
```

## 8 链式调用
thenReturn、doReturn 等函数支持链式调用，用来指定函数特定调用次数时的行为。


```java
import org.junit.Assert;
import org.junit.Test;

import static org.mockito.Mockito.*;

public class MockitoDemo {

    static class ExampleService {

        public int add(int a, int b) {
            return a+b;
        }

    }

    @Test
    public void test() {

        ExampleService exampleService = mock(ExampleService.class);

        // 让第1次调用返回 100，第2次调用返回 200
        when(exampleService.add(1, 2)).thenReturn(100).thenReturn(200);

        Assert.assertEquals(100, exampleService.add(1, 2));
        Assert.assertEquals(200, exampleService.add(1, 2));
        Assert.assertEquals(200, exampleService.add(1, 2));

    }

}
```


### 9 Springboot与Mockito

* spring-boot-starter-test中已经加入了Mockito依赖，所以我们无需手动引入。
* 另外要注意一点，在SpringBoot环境下，我们可能会用@SpringBootTest注解。
```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@BootstrapWith(SpringBootTestContextBootstrapper.class)
@ExtendWith({SpringExtension.class})
public @interface SpringBootTest {
```
* 如果用这个注解，跑单元测试的时候会加载SpringBoot的上下文，初始化Spring容器一次，显得格外的慢，这可能也是很多人放弃在Spring环境下使用单元测试的原因之一。
* 不过我们可以不用这个Spring环境，单元测试的目的应该是只测试这一个函数的逻辑正确性，某些容器中的相关依赖可以通过Mockito仿真。

* 所以我们可以直接拓展自MockitoExtendsion，这样跑测试就很快了。
```
@ExtendWith(MockitoExtension.class)
public class ListMockTest {
}
```