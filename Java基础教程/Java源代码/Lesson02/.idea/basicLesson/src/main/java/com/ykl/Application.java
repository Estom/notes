/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl;

/**
 * @author yinkanglong
 * @version : Application, v 0.1 2022-07-11 09:20 yinkanglong Exp $
 */
public class Application {
    public static void main(String[] args) {
        String a = "test";
        String b = "test";
        String c = new String("test");
        String d = new String("test");

        System.out.println(a==b);
        System.out.println(c==d);
        System.out.println("hello world");


    }
}
