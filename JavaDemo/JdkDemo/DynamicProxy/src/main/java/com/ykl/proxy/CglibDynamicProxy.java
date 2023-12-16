package com.ykl.proxy;

import com.ykl.proxy.handler.LogInterceptor;
import com.ykl.proxy.service.UserService;
import net.sf.cglib.proxy.Enhancer;

public class CglibDynamicProxy {

    public static void main(String[] args) {
        LogInterceptor logInterceptor = new LogInterceptor();
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(UserService.class);  // 设置超类，cglib是通过继承来实现的
        enhancer.setCallback(logInterceptor);
        UserService userService = (UserService)enhancer.create();   // 创建代理类


        userService.update();
        userService.select();

    }
}
