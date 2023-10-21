用EasyMock生成模拟对象进行单元测试 ｜ Testing with EasyMock
===
当项目达到一定规模时会根据业务或功能进行模块化，这时研发团队在协作时会碰到一个问题：如何让相互依赖的各模块并行开发？常用的办法是：各模块之间有清晰的边界，模块之间的交互通过接口。在设计阶段定义模块的接口，然后各个模块开发时遵循接口的定义进行实现和调用。

OK，并行开发的问题解决了。但不同的模块因其复杂度和工作量不同，进度不一致。当研发同学完成所负责的模块时，但依赖的模块还没有完成开发，不好进行测试。
这里就讲如何用EasyMock生成Mock Object模拟所依赖模块的接口来完成单元测试。

![EasyMock](http://img1.ph.126.net/wErY4T7Ne-KeyB66As_PLA==/6608670713840748025.gif)

预备
---
* easymock-3.2.jar
* easymockclassextension-3.2.jar
* cglib-2.2.2.jar
* objenesis-1.2.jar
* asm-3.1.jar
* asm-commons-3.1.jar
* asm-util-3.1.jar
* gson-2.2.4.jar   // *用于处理JSON*

注：上面的jar文件均可从[MAVEN仓库](http://mvnrepository.com)下载。


使用EasyMock的五部曲
---
1、引入EasyMock。
```java
import static org.easymock.EasyMock.*;
```
2、创建Mock Object。
```java
mock = createMock(InterfaceOrClass.class);
```
3、设置Mock Object的行为和预期结果。
```java
mock.doSomeThing();
expectLastCall().times(1);   // 至少要调用一次doSomeThing方法
```
或者
```java
// 模拟抛出异常
expect(mock.getSomeThing(anyString()))
    .andThrow(new IOException("单元测试特意抛的异常")); 

// 模拟返回指定的数据
expect(mock.getSomeThing(anyString()))
    .andReturn("abcd");  
```
4、设置Mock Object变成可用状态。
```java
replay(mock);
```
5、运行单元测试代码（会调用到Mock Object的方法）。
```java
// 如果是校验调用次数就要用到verify方法
verify(mock);
```

实践
---
### 业务代码
[源码下载](https://raw.githubusercontent.com/aofeng/JavaDemo/master/src/cn/aofeng/demo/easymock/UserService.java)
```java
package cn.aofeng.demo.easymock;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.Map;

import org.apache.log4j.Logger;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import cn.aofeng.demo.jetty.HttpGet;

/**
 * 用户相关服务。如：获取用户昵称。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class UserService {

    private static Logger _logger = Logger.getLogger(UserService.class);
    
    private HttpGet _httpGet = new HttpGet();
    
    /**
     * 根据用户的账号ID获取昵称。
     * 
     * @param accountId 用户的账号ID
     * @return 如果账号ID有效且请求成功，返回昵称；否则返回默认的昵称"用户xxx"。
     */
    public String getNickname(String accountId) {
        String targetUrl = "http://192.168.56.102:8080/user?method=getNickname&accountId="+accountId;
        String response = null;
        try {
            response = _httpGet.getSomeThing(targetUrl);
        } catch (IOException e) {
            _logger.error("获取用户昵称时出错,账号ID:"+accountId, e);
        }
        
        if (null != response) {
            // 响应数据结构示例：{"nickname":"张三"}
            Type type = new TypeToken<Map<String, String>>() {}.getType();
            Map<String, String> data = new Gson().fromJson(response, type);
            if (null != data && data.containsKey("nickname")) {
                return data.get("nickname");
            }
        }
        
        return "用户"+accountId;
    }

    protected void setHttpGet(HttpGet httpGet) {
        this._httpGet = httpGet;
    }

}
```

[源码下载](https://raw.githubusercontent.com/aofeng/JavaDemo/master/src/cn/aofeng/demo/jetty/HttpGet.java)
```java
package cn.aofeng.demo.jetty;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.commons.io.IOUtils;

/**
 * HTTP GET请求。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HttpGet {

    public String getSomeThing(String urlStr) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection urlConn = (HttpURLConnection) url.openConnection();
        urlConn.setConnectTimeout(3000);
        urlConn.setRequestMethod("GET");
        urlConn.connect();
        
        InputStream ins = null;
        try {
            if (200 == urlConn.getResponseCode()) {
                ins = urlConn.getInputStream();
                ByteArrayOutputStream outs = new ByteArrayOutputStream(1024);
                IOUtils.copy(ins, outs);
                return outs.toString("UTF-8");
            }
        } catch (IOException e) {
            throw e;
        } finally {
            IOUtils.closeQuietly(ins);
        }
        
        return null;
    }

}
```

### 单元测试代码
[源码下载](https://raw.githubusercontent.com/aofeng/JavaDemo/master/src/cn/aofeng/demo/easymock/UserServiceTest.java)
```java
package cn.aofeng.demo.easymock;

import static org.junit.Assert.*;

import java.io.IOException;

import static org.easymock.EasyMock.*;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import cn.aofeng.demo.jetty.HttpGet;

/**
 * {@link UserService}的单元测试用例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class UserServiceTest {

    private HttpGet _mock = createMock(HttpGet.class);
    
    @Before
    public void setUp() throws Exception {
    }
    
    @After
    public void tearDown() throws Exception {
        reset(_mock);
    }
    
    
    /**
     * 测试用例：获取用户昵称 <br/>
     * 前置条件：
     * <pre>
     * 网络请求时发生IO异常
     * </pre>
     * 
     * 测试结果：
     * <pre>
     * 返回默认的用户昵称"用户xxx"
     * </pre>
     */
    @Test
    public void testGetNickname4OccursIOError() throws IOException {
        // 设置Mock
        expect(_mock.getSomeThing(anyString()))
                .andThrow(new IOException("单元测试特意抛的异常"));
        replay(_mock);
        
        UserService us = new UserService();
        us.setHttpGet(_mock);
        String nickname = us.getNickname("123456");
        verify(_mock); // 校验mock
        assertEquals("用户123456", nickname); // 检查返回值
    }

    /**
     * 测试用例：获取用户昵称 <br/>
     * 前置条件：
     * <pre>
     * 1、网络请求成功。
     * 2、响应状态码为200且响应内容符合接口定义（{\"nickname\":\"张三\"}）。
     * </pre>
     * 
     * 测试结果：
     * <pre>
     * 返回"张三"
     * </pre>
     */
    @Test
    public void testGetNickname4Success() throws IOException {
        // 设置Mock
        _mock.getSomeThing(anyString());
        expectLastCall().andReturn("{\"nickname\":\"张三\"}");
        expectLastCall().times(1);
        replay(_mock);
        
        UserService us = new UserService();
        us.setHttpGet(_mock);
        String nickname = us.getNickname("123456");
        verify(_mock); // 校验方法的调用次数
        assertEquals("张三", nickname); // 校验返回值
    }

}
```
