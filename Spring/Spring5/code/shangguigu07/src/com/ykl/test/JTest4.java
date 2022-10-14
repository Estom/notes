/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import com.ykl.service.AccountService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @author yinkanglong
 * @version : JTest4, v 0.1 2022-10-12 11:30 yinkanglong Exp $
 */

//@ExtendWith(SpingExtension.class)
@ContextConfiguration("classpath:bean01.xml")
public class JTest4 {
    @Autowired
    private AccountService accountService;

    @Test
    public void test01(){
        accountService.pay();
    }
}
