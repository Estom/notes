/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.test;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author yinkanglong
 * @version : UserLog, v 0.1 2022-10-12 10:59 yinkanglong Exp $
 */
public class UserLog {
    private static final Logger log = LoggerFactory.getLogger(UserLog.class);

    public static void main(String[] args) {
        log.info("hello world");
        log.warn("hello log4j");
    }
}
