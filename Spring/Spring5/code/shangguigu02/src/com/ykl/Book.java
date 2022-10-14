/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl;

/**
 * @author yinkanglong
 * @version : Book, v 0.1 2022-10-08 14:32 yinkanglong Exp $
 */
public class Book  {
    /**
     * Getter method for property <tt>name</tt>.
     *
     * @return property value of name
     */
    public String getName() {
        return name;
    }

    private String name;

    //set方法注入
    public void setName(String name) {
        this.name = name;
    }

    //有参构造函数注入
    public Book(String name){
        this.name = name;
    }

    public Book(){

    }

    public static void main(String[] args) {
        //使用set方法注入
        Book book = new Book();
        book.setName("123");

        //使用有参构造函数注入
        Book book2 = new Book("abc");
    }
}
