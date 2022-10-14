/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl;

/**
 * @author yinkanglong
 * @version : User, v 0.1 2022-10-08 11:22 yinkanglong Exp $
 */
public class User {
    public User(String username) {
        Username = username;
    }

    public User() {
    }
    /**
     * Getter method for property <tt>Username</tt>.
     *
     * @return property value of Username
     */
    public String getUsername() {
        return Username;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param Username value to be assigned to property Username
     */
    public void setUsername(String username) {
        Username = username;
    }

    private String Username;


    public void add(){
        System.out.println("add user");
    }
}
