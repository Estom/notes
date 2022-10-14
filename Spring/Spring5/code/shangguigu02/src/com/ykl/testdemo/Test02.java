/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.testdemo;

import com.ykl.User;
import com.ykl.service.UserService;
import org.junit.Test;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author yinkanglong
 * @version : Tst02, v 0.1 2022-10-08 15:23 yinkanglong Exp $
 */
public class Test02 {
    @Test
    public void testAdd(){
//        加载spring的配置文件
        ApplicationContext context = new ClassPathXmlApplicationContext("bean02.xml");

        //        获取配置创建的对象
        UserService user = context.getBean("userService", UserService.class);
        user.add();
    }
}
