/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.aopanno.User;
import com.ykl.aopxml.Book;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author yinkanglong
 * @version : Test02, v 0.1 2022-10-09 15:28 yinkanglong Exp $
 */
public class Test02 {

    @Test
    public void testAop(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean02.xml");
        User user = context.getBean("user", User.class);
        user.add();
    }

    @Test
    public void testAopXml(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean03.xml");
        Book book = context.getBean("book", Book.class);
        book.add();
    }
}
