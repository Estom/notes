package cn.aofeng.demo.mockito;

import static org.junit.Assert.*;

import org.junit.Test;
import static org.mockito.Mockito.*;

/**
 * {@link UserService}的单元测试用例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class UserServiceTest {

    private UserService _userService = new UserService();
    
    @Test
    public void testIsAdult4UserExist() {
        long userId = 123;
        User user = new User(userId, "张三", 19);
        
        // 大于18岁的测试用例
        UserDao daoMock = mock(UserDao.class);
        when(daoMock.queryById(userId)).thenReturn(user); // 设置行为和对应的返回值
        _userService.setUserDao(daoMock); // 设置mock
        assertTrue(_userService.isAdult(userId)); // 校验结果
        
        // 等于18岁的测试用例
        User user2 = new User(userId, "李四", 18);
        when(daoMock.queryById(userId)).thenReturn(user2);
        _userService.setUserDao(daoMock);
        assertTrue(_userService.isAdult(userId));
        
        // 小于18岁的测试用例
        User user3 = new User(userId, "王五", 17);
        when(daoMock.queryById(userId)).thenReturn(user3);
        _userService.setUserDao(daoMock);
        assertFalse(_userService.isAdult(userId));
    }

    @Test
    public void testIsAdult4UserNotExist() {
        // 用户不存在的测试用例
        long userId = 123;
        UserDao daoMock = mock(UserDao.class);
        when(daoMock.queryById(userId)).thenReturn(null); // 设置行为和对应的返回值
        _userService.setUserDao(daoMock); // 设置mock
        assertFalse(_userService.isAdult(userId)); // 校验结果
    }

    @Test
    public void testBuy() {
        long userId = 12345;
        UserDao daoMock = mock(UserDao.class);
        when(daoMock.queryById(anyLong())).thenReturn(new User(userId, "张三", 19));
        
        String commodityId = "S01A10009823";
        CommodityDao commodityDao = mock(CommodityDao.class);
        when(commodityDao.queryById(anyString())).thenReturn(new Commodity(commodityId, "xxx手机", 1));
        
        _userService.setUserDao(daoMock);
        _userService.setCommodityDao(commodityDao);
        assertTrue(_userService.buy(userId, commodityId));
    }

}
