/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.dao;

import org.springframework.stereotype.Repository;

/**
 * @author yinkanglong
 * @version : UserDoImpl, v 0.1 2022-10-09 12:04 yinkanglong Exp $
 */
@Repository
public class UserDoImpl implements UserDo{

    @Override
    public int add(int a, int b) {
        System.out.println("add 方法执行了");
        return a+b;
    }

    @Override
    public String update(String id) {
        return id;
    }
}
