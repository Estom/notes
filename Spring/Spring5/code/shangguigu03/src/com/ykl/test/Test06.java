/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.autowire.Emp;
import com.ykl.bean.Order;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author yinkanglong
 * @version : Test05, v 0.1 2022-10-09 10:22 yinkanglong Exp $
 */
public class Test06 {
    @Test
    public void testCollection(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean06.xml");
        Emp emp = context.getBean("emp", Emp.class);
        System.out.println(emp);
    }
}
