/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.aopanno;

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * @author yinkanglong
 * @version : PersonProxy, v 0.1 2022-10-09 16:01 yinkanglong Exp $
 */
@Component
@Aspect
@Order(1)
public class PersonProxy {


    //前置通知
    @Before(value = "execution(* com.ykl.aopanno.User.add(..))")
    public void before(){
        System.out.println("执行前...");
    }

    @After(value = "execution(* com.ykl.aopanno.User.add(..))")
    public void after(){
        System.out.println("after...");
    }
}
