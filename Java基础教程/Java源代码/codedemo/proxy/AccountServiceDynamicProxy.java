package cn.aofeng.demo.proxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 账号服务动态代理。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class AccountServiceDynamicProxy implements InvocationHandler {

    private final static Logger _LOGGER = LoggerFactory.getLogger(AccountServiceDynamicProxy.class);
    
    private AccountService _accountService;
    
    public AccountServiceDynamicProxy(AccountService accountService) {
        this._accountService = accountService;
    }
    
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        _LOGGER.debug("execute method {}, arguments: {}", method.getName(), args);
        Object result = method.invoke(_accountService, args);
        _LOGGER.debug("execute method {}, result:{}", method.getName(), result);
        
        return result;
    }
    
    public static AccountService newInstance(AccountService accountService) {
        ClassLoader loader = accountService.getClass().getClassLoader();
        Class<?>[] interfaces = accountService.getClass().getInterfaces();
        
        return (AccountService) Proxy.newProxyInstance(loader, 
                interfaces, 
                new AccountServiceDynamicProxy(accountService));
    }
}
