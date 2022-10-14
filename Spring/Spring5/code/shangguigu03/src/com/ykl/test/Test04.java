/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.collectiontype.Book;
import com.ykl.collectiontype.Course;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author yinkanglong
 * @version : Test04, v 0.1 2022-10-09 10:01 yinkanglong Exp $
 */
public class Test04 {
    @Test
    public void testCollection(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean04.xml");
        Book book01 = context.getBean("book", Book.class);
        System.out.println(book01.hashCode());

        Book book02 = context.getBean("book",Book.class);
        System.out.println(book02.hashCode());
    }
}
