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
