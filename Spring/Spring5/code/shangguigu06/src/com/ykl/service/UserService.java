/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.service;

import com.ykl.dao.UserDao;
import com.ykl.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.awt.print.Book;
import java.util.List;

/**
 * @author yinkanglong
 * @version : UserService, v 0.1 2022-10-10 09:05 yinkanglong Exp $
 */
@Service
public class UserService {
    @Autowired
    private UserDao userDao;

    public void addUser(User user){
        userDao.addUser(user);
    }

    public void updateUser(User user){
        userDao.updateUser(user);
    }

    public void deleteUser(String id){
        userDao.delete(id);
    }

    public int  findCount(){
        int number = userDao.selectCount();
        return number;
    }
    public User  findOne(String id){
        return userDao.findUserInfo(id);
    }

    public List<User> findAll(){
        return userDao.findAll();
    }


    public void batchAdd(List<Object[]> batchArgs){
        userDao.batchAdd(batchArgs);
    }
}
