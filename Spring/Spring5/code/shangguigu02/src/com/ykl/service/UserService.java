/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.service;

import com.ykl.dao.UserDao;

/**
 * @author yinkanglong
 * @version : UserService, v 0.1 2022-10-08 15:14 yinkanglong Exp $
 */
public class UserService {

    public UserDao getUserDao() {
        return userDao;
    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    UserDao userDao;


    public void add(){
        System.out.println("service add ...");

        userDao.update();
    }
}
