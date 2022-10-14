/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.dao;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * @author yinkanglong
 * @version : JDKProxy, v 0.1 2022-10-09 14:31 yinkanglong Exp $
 */
public class JDKProxy {
    public static void main(String[] args) {
        Class[] interfaces = {UserDo.class};

//        Proxy.newProxyInstance(JDKProxy.class.getClassLoader(), interfaces, new InvocationHandler() {
//            @Override
//            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
//                return null;
//            }
//        });

        UserDoImpl userDo = new UserDoImpl();
        UserDo dao = (UserDo)Proxy.newProxyInstance(JDKProxy.class.getClassLoader(),interfaces,new UserDaoProxy(userDo));
        int result = dao.add(1,2);
        System.out.println("结束");
    }
}
class UserDaoProxy implements InvocationHandler{
    Object object;
    //把被代理的对象，传递进来。通过有参构造进行传递
    public UserDaoProxy(Object object){
        this.object=object;
    }
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("方法之前的执行"+method.getName());

        Object res = method.invoke(object,args);

        System.out.println("方法执行后");

        return res;
    }
}
