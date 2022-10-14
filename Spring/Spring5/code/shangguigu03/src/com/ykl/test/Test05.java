/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.bean.Order;
import com.ykl.collectiontype.Book;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author yinkanglong
 * @version : Test05, v 0.1 2022-10-09 10:22 yinkanglong Exp $
 */
public class Test05 {
    @Test
    public void testCollection(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean05.xml");
        Order order = context.getBean("order", Order.class);
        System.out.println("第四步 获取bean实例对象");
        ((ClassPathXmlApplicationContext)context).close();
    }
}
