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
