package cn.aofeng.demo.proxy;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * {@link AccountServiceImpl}的代理类，增加了输出入参和响应的日志。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class AccountServiceStaticProxy implements AccountService {

    private AccountService _delegate;
    
    private final static Logger _LOGGER = LoggerFactory.getLogger(AccountServiceStaticProxy.class);
    
    public AccountServiceStaticProxy(AccountService accountService) {
        this._delegate = accountService;
    }
    
    @Override
    public Result register(String username) {
        _LOGGER.debug("execute method register, arguments: username={}", username);
        Result result = _delegate.register(username);
        _LOGGER.debug("execute method register, result:{}", result);
        
        return result;
    }

    @Override
    public Result login(String username, String password) {
        _LOGGER.debug("execute method login, arguments: username={}, password={}", username, password);
        Result result = _delegate.login(username, password);      
        _LOGGER.debug("execute method login, result:{}", result);
        
        return result;
    }

}
