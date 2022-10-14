/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.config.TxConfig;
import com.ykl.entity.Account;
import com.ykl.service.AccountService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.context.support.GenericApplicationContext;
import sun.net.www.content.text.Generic;

import java.util.ArrayList;
import java.util.List;

/**
 * @author yinkanglong
 * @version : Test01, v 0.1 2022-10-08 16:09 yinkanglong Exp $
 */
public class Test01 {


    @Test
    public void testBatchAdd(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        AccountService accountService = context.getBean("accountService",AccountService.class);
        accountService.pay();
    }

    @Test
    public void testBatchAdd3(){
        ApplicationContext context = new AnnotationConfigApplicationContext(TxConfig.class);
        AccountService accountService = context.getBean("accountService",AccountService.class);
        System.out.println("start");
        accountService.pay();
        System.out.println("end");
    }

    //函数式风格创建对象，交给对象进行管理
    @Test
    public void testGenericApplicationContext(){
        GenericApplicationContext context = new GenericApplicationContext();

        context.refresh();
        context.registerBean("user1",Account.class,()->new Account());

        //根据类型获取bean（跟@Autowire一样，都是根据类型手动装载）
        Account account = context.getBean("com.ykl.entity.Account",Account.class);
        System.out.println(account);

        //根据名称获取bean(跟@Qualified一样，根据对象的id进行装配)
        Account account2 = context.getBean("user1",Account.class);
        System.out.println(account);
    }

}
