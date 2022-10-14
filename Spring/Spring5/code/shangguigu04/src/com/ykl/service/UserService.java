/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.service;

import com.ykl.dao.UserDo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

/**
 * 与xml配置等价，value值可以省略不写
 * 默认值是类名称，首字母小写。
 */
@Service
public class UserService {

    @Autowired
    @Qualifier(value = "userDoImpl")
    private UserDo userDo;
    public void add(){
        System.out.println("service add ... ...");

        userDo.add();
    }
}
