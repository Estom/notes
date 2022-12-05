package cn.aofeng.demo.proxy;

import java.util.Random;

import wiremock.org.apache.commons.lang.StringUtils;

/**
 * 
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class AccountServiceImpl implements AccountService {

    private final static Random NUM = new Random(System.currentTimeMillis());
    
    @Override
    public Result register(String username) {
        if (StringUtils.isBlank(username)) {
            return createResult(4000001, "注册失败");
        }
        
        User user = new User();
        user.setUid(NUM.nextInt());
        user.setNickname("用户"+user.getUid());
        return createResult(2000001, "注册成功", user);
    }

    @Override
    public Result login(String username, String password) {
        if (StringUtils.isBlank(username) || StringUtils.isBlank(password)) {
            return createResult(4000001, "登录失败");
        }
        
        User user = new User();
        user.setUid(NUM.nextInt());
        user.setNickname("用户"+user.getUid());
        return createResult(2000001, "登录成功", user);
    }

    private Result createResult(int code, String msg) {
        Result result = new Result(code, msg);
                
        return result;
    }

    private Result createResult(int code, String msg, User user) {
        Result result = new Result(code, msg);
        result.setData(user);
                
        return result;
    }

}
