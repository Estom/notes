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
