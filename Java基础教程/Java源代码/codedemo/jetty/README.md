使用Jetty实现Http Server Mock作单元测试
===
在研发过程中发现许多模块对外部系统的调用并没有沉淀成专门的客户端，代码中直接调用URL发送请求和获取响应内容，导致做单元测试的时候非常麻烦。
特别是对已有系统做改造的时候，要先写单元测试用例，保证后续的重构和修改不偏离原来的业务需求。

这样问题就来了：该如何模拟外部系统返回各种正常和异常的响应内容呢？
办法总是有的，这里就用Jetty实现Http Server Mock，模拟服务端返回各种响应数据。

预备
---
* [JUnit 4.11](http://junit.org/)
* [Jetty 7.6.9](http://www.eclipse.org/jetty/)

业务示例代码
---
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
 * 抓取页面内容。
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
用Jetty实现的Http Server Mock
---
[源码下载](https://raw.githubusercontent.com/aofeng/JavaDemo/master/src/cn/aofeng/demo/jetty/HttpServerMock.java)
```java
package cn.aofeng.demo.jetty;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.AbstractHandler;

/**
 * HTTP服务器MOCK，可用于单元测试时模拟HTTP服务器的响应。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HttpServerMock {

    public final static int DEFAULT_PORT = 9191;
    public final static String DEFAULT_CONTENT_TYPE = "application/json";
    public final static int DEFAULT_STATUS_CODE=HttpServletResponse.SC_OK;
    
    private Server _httpServer;
    private int _port;
    
    public HttpServerMock() {
        _port = DEFAULT_PORT;
    }
    
    public HttpServerMock(int port) {
        _port = port;
    }
    
    /**
     * 启动Jetty服务器。默认的响应status code为"200"，content type为"application/json"。
     * @param content 响应内容
     */
    public void start(String content) throws Exception {
        start(content, DEFAULT_CONTENT_TYPE, DEFAULT_STATUS_CODE);
    }
    
    /**
     * 启动Jetty服务器。默认的响应status code为"200"。
     * @param content 响应内容
     * @param contentType 响应内容的MIME类型
     */
    public void start(String content, String contentType) throws Exception {
        start(content, contentType, DEFAULT_STATUS_CODE);
    }
    
    /**
     * 启动Jetty服务器。
     * @param content 响应内容
     * @param contentType 响应内容的MIME类型
     * @param statuCode 响应状态码
     */
    public void start(String content, String contentType, 
            int statuCode) throws Exception {
        _httpServer = new Server(_port);
        _httpServer.setHandler(createHandler(content, contentType, statuCode));
        _httpServer.start();
    }
    
    /**
     * 停止Jetty服务器。
     */
    public void stop() throws Exception {
        if (null != _httpServer) {
            _httpServer.stop();
            _httpServer = null;
        }
    }
    
    private Handler createHandler(final String content, final String contentType, 
            final int statusCode) {
        return new AbstractHandler() {
            @Override
            public void handle(String target, Request baseRequest, HttpServletRequest request,
                    HttpServletResponse response) throws IOException, ServletException {
                response.setContentType(contentType);
                response.setStatus(statusCode);
                baseRequest.setHandled(true);
                response.getWriter().print(content);
            }
        };
    }

}
```
单元测试代码
---
[源码下载](https://raw.githubusercontent.com/aofeng/JavaDemo/master/src/cn/aofeng/demo/jetty/HttpGetTest.java)
```java
package cn.aofeng.demo.jetty;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/**
 * {@link HttpGet}的单元测试用例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HttpGetTest {
    
    private HttpServerMock _mock;
    private HttpGet _httpGet = new HttpGet();

    @Before
    public void setUp() throws Exception {
        _mock = new HttpServerMock();
    }

    @After
    public void tearDown() throws Exception {
        if (null != _mock) {
            _mock.stop();
        }
    }

    /**
     * 用例：响应状态码为200且有响应内容。
     */
    @Test
    public void testGetSomeThing4Success() throws Exception {
        String response = "Hello, The World!";
        _mock.start(response, "text/plain");
        
        String content = _httpGet.getSomeThing("http://localhost:9191/hello");
        assertEquals(response, content);
    }
    
    /**
     * 用例：响应状态码为非200。
     */
    @Test
    public void testGetSomeThing4Fail() throws Exception {
        String response = "Hello, The World!";
        _mock.start(response, "text/plain", 500);
        
        String content = _httpGet.getSomeThing("http://localhost:9191/hello");
        assertNull(content);
    }

}
```

