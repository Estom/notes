/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

/**
 * @author yinkanglong
 * @version : AccountDaoImpl, v 0.1 2022-10-11 10:42 yinkanglong Exp $
 */
@Repository
public class AccountDaoImpl implements AccountDao{

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void addMoney() {
        String sql = "update account set money=money+? where username=?";
        jdbcTemplate.update(sql,100,"mary");
        System.out.println("addmoney");
    }

    @Override
    public void reduceMoney() {
        String sql = "update account set money=money-? where username=?";
        jdbcTemplate.update(sql,100,"lucy");
        System.out.println("reducemoney");
    }
}
