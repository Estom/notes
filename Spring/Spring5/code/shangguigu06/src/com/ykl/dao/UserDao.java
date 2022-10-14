/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.dao;

import com.ykl.entity.User;

import java.awt.print.Book;
import java.util.List;

/**
 * @author yinkanglong
 * @version : UserDo, v 0.1 2022-10-09 12:03 yinkanglong Exp $
 */
public interface UserDao {
    public int addUser(User user);

    public void updateUser(User user);

    public void delete(String id);

    int selectCount();

    User findUserInfo(String id);

    List<User> findAll();

    void batchAdd(List<Object[]> batchArgs);
}
