/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.entity.User;
import com.ykl.service.UserService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import sun.security.util.ArrayUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * @author yinkanglong
 * @version : Test01, v 0.1 2022-10-08 16:09 yinkanglong Exp $
 */
public class Test01 {


    @Test
    public void testAdd(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        UserService userService = context.getBean("userService",UserService.class);
        User user = new User();
        user.setUserId("123");
        user.setUsername("yinkanglong");
        user.setUserStatus("up");
        userService.addUser(user);
    }

    @Test
    public void testUpdate(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        UserService userService = context.getBean("userService",UserService.class);
        User user = new User();
        user.setUserId("1");
        user.setUsername("ykl1");
        user.setUserStatus("up1");
        userService.addUser(user);

        user.setUserStatus("down1");
        userService.updateUser(user);

    }

    @Test
    public void testDelete(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        UserService userService = context.getBean("userService",UserService.class);
        User user = new User();
        user.setUserId("2");
        user.setUsername("ykl2");
        user.setUserStatus("up2");
        userService.addUser(user);

        userService.deleteUser(user.getUserId());
    }


    @Test
    public void testFindCount(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        UserService userService = context.getBean("userService",UserService.class);
        int num = userService.findCount();
        System.out.println(num);
    }

    @Test
    public void testFindOne(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        UserService userService = context.getBean("userService",UserService.class);
        User user = userService.findOne("123");
        System.out.println(user);
    }

    @Test
    public void testFindAll(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        UserService userService = context.getBean("userService",UserService.class);
        List<User> users = userService.findAll();
        System.out.println(users);
    }

    @Test
    public void testBatchAdd(){
        ApplicationContext context = new ClassPathXmlApplicationContext("bean01.xml");
        UserService userService = context.getBean("userService",UserService.class);


        List<Object[]> batchArgs = new ArrayList<>();

        Object[] o1 = {"111","java","a"};
        Object[] o2 = {"222","c++","b"};
        Object[] o3 = {"333","mysql","c"};
        batchArgs.add(o1);
        batchArgs.add(o2);
        batchArgs.add(o3);

        userService.batchAdd(batchArgs);
    }
}
