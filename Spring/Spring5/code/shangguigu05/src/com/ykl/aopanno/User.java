/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.aopanno;

import org.springframework.stereotype.Component;

/**
 * @author yinkanglong
 * @version : User, v 0.1 2022-10-09 15:16 yinkanglong Exp $
 */
@Component
public class User {
    public void add(){
        System.out.println("User add ...");
    }
}
