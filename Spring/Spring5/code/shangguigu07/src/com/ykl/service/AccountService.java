/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.service;

import com.ykl.dao.AccountDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author yinkanglong
 * @version : AccountService, v 0.1 2022-10-11 10:42 yinkanglong Exp $
 */
@Service
@Transactional
public class AccountService {

    @Autowired
    private AccountDao accountDao;

    public void pay(){

        accountDao.reduceMoney();
//        int i= 1/0;
        accountDao.addMoney();
    }
}
