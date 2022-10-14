/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.testdemo;

import com.ykl.Book;
import com.ykl.Order;
import com.ykl.User;
import org.junit.Test;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author yinkanglong
 * @version : Test01, v 0.1 2022-10-08 11:27 yinkanglong Exp $
 */
public class Test01 {
    @Test
    public void testAdd(){
//        加载spring的配置文件
//        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        BeanFactory context = new ClassPathXmlApplicationContext("bean01.xml");

        //        获取配置创建的对象
        User user = context.getBean("user", User.class);
        System.out.println(user);
        user.add();
    }

    @Test
    public void testBook(){

//        在创建对象的过程中就完成了属性的注入
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");

        Book book = context.getBean("book", Book.class);

        System.out.println(book.getName());

    }

    @Test
    public void testOrder(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");

        Order order = context.getBean("order", Order.class);

        order.test();
    }
}
