package cn.aofeng.demo.proxy;

/**
 * 账号服务接口定义。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public interface AccountService {

    /**
     * 注册。
     * 
     * @param username 账号名
     * @return 具体含义查看{@link Result}的说明。
     */
    Result register(String username);
    
    /**
     * 登录。
     * 
     * @param username 账号名
     * @param password 密码
     * @return 具体含义查看{@link Result}的说明。
     */
    Result login(String username, String password);

}
