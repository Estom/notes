/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.aopanno;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

/**
 * @author yinkanglong
 * @version : UserProxy, v 0.1 2022-10-09 15:16 yinkanglong Exp $
 */
@Component
@Aspect
public class UserProxy {

    //前置通知
    @Before(value = "execution(* com.ykl.aopanno.User.add(..))")
    public void before(){
        System.out.println("执行前...");
    }

    @After(value = "execution(* com.ykl.aopanno.User.add(..))")
    public void after(){
        System.out.println("after...");
    }

    @AfterReturning(value = "execution(* com.ykl.aopanno.User.add(..))")
    public void afterReturn(){
        System.out.println("afterReturn...");
    }

    @AfterThrowing(value = "execution(* com.ykl.aopanno.User.add(..))")
    public void afterThrow(){
        System.out.println("afterThrow...");
    }

    @Around(value = "execution(* com.ykl.aopanno.User.add(..))")
    public void around(ProceedingJoinPoint proceedingJoinPoint) throws Throwable{
        System.out.println("环绕之前....");

        proceedingJoinPoint.proceed();

        System.out.println("环绕之后....");
    }

}
