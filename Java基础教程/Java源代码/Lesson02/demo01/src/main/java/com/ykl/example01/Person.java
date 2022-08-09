/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.example01;

import java.sql.SQLOutput;

/**
 * @author yinkanglong
 * @version : Person, v 0.1 2022-07-24 01:56 yinkanglong Exp $
 */
public class Person {
    //静态变量
    public static int age=10;

    //静态方法
    public static void say(){
        System.out.println("静态方法执行了");
    }

    //代码快
    {
        System.out.println("普通代码块");
    }

    //静态代码快
    static {
        System.out.println("静态代码块");
    }



    public Person(){
        System.out.println("构造器执行了");
    }
}
