package cn.aofeng.demo.proxy;

/**
 * 代理调用示例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class AccountServiceClient {

    public static void main(String[] args) {
        AccountService as = new AccountServiceImpl();
        
        // 静态代理
        AccountService staticProxy = new AccountServiceStaticProxy(as);
        staticProxy.register(null);
        staticProxy.register("A0001");
        staticProxy.login(null, null);
        staticProxy.login("A0001", "PWD0001");
        
        // 动态代理
        AccountService dynamicProxy = AccountServiceDynamicProxy.newInstance(as);
        dynamicProxy.register(null);
        dynamicProxy.register("A0001");
        dynamicProxy.login(null, null);
        dynamicProxy.login("A0001", "PWD0001");
    }

}
