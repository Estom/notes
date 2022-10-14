/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.collectiontype.Book;
import com.ykl.collectiontype.Student;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author yinkanglong
 * @version : Test01, v 0.1 2022-10-08 16:09 yinkanglong Exp $
 */
public class Test02 {

    @Test
    public void testCollection(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean02.xml");
        Book book = context.getBean("book",Book.class);
        System.out.println(book);
    }

}
