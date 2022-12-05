使用WireMock实现Http Server Mock作单元测试
===
前一篇文章"[使用jetty实现Http Server Mock作单元测试](http://aofengblog.com/2014/05/06/WireMock-%E5%AE%9E%E7%8E%B0Http-Server-Mock%E7%94%A8%E4%BA%8E%E5%8D%95%E5%85%83%E6%B5%8B%E8%AF%95/)"
讲了用Jetty实现Http Server Mock来模拟依赖的外部HTTP服务系统，但如果需要更多的功能，如：区分GET和POST；匹配请求的URL；匹配Http Header；匹配请求内容等等。
实际研发的过程中这些功能都有可能会用到，如果还是用Jetty来实现，需要自己不停地动手去添砖加瓦，虽然有成就感，但在快速迭代的节奏下不一定有足够的时间去做这些。
这时我们需要一个现成的类库来满足我们这些需求，WireMock和MockServer都可以做到，这里只讲WireMock。

预备
---
* [JUnit 4.11](http://junit.org/)
* [wiremock 1.46](http://wiremock.org/)

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

单元测试代码
---
[源码下载](https://raw.githubusercontent.com/aofeng/JavaDemo/master/src/cn/aofeng/demo/wiremock/HttpGetTest.java)
```java
package cn.aofeng.demo.wiremock;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import com.github.tomakehurst.wiremock.junit.WireMockRule;

import cn.aofeng.demo.jetty.HttpGet;

/**
 * {@link HttpGet}的单元测试用例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HttpGetTest {

    private HttpGet _httpGet = new HttpGet();
    
    @Rule
    public WireMockRule _wireMockRule = new WireMockRule(9191);
    
    @Before
    public void setUp() throws Exception {
    }

    @After
    public void tearDown() throws Exception {
    }

    /**
     * 用例：响应状态码为200且有响应内容。
     */
    @Test
    public void testGetSomeThing4Success() throws Exception {
        // 设置Mock
        String response = "Hello, The World!";
        stubFor(get(urlEqualTo("/hello"))
                .willReturn(aResponse()
                        .withStatus(200)
                        .withBody(response)));
        
        String content = _httpGet.getSomeThing("http://localhost:9191/hello");
        assertEquals(response, content);
    }
    
    /**
     * 用例：响应状态码为非200。
     */
    @Test
    public void testGetSomeThing4Fail() throws Exception {
        // 设置Mock
        stubFor(get(urlEqualTo("/hello"))
                .willReturn(aResponse()
                        .withStatus(500)
                        .withBody("Hello, The World!")));
        
        String content = _httpGet.getSomeThing("http://localhost:9191/hello");
        assertNull(content);
    }

}
```