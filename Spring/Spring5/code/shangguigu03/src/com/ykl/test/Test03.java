/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.collectiontype.Book;
import com.ykl.collectiontype.Course;
import com.ykl.factorybean.MyBean;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author yinkanglong
 * @version : Test03, v 0.1 2022-10-09 09:39 yinkanglong Exp $
 */
public class Test03 {

    @Test
    public void testCollection(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean03.xml");
        Course myBean = context.getBean("mybean", Course.class);
        System.out.println(myBean);
    }
}
