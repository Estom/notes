/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.entity;

/**
 * @author yinkanglong
 * @version : Account, v 0.1 2022-10-11 10:42 yinkanglong Exp $
 */
public class Account {

    private String id;

    private String username;

    private Integer money;

    /**
     * Getter method for property <tt>id</tt>.
     *
     * @return property value of id
     */
    public String getId() {
        return id;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param id value to be assigned to property id
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * Getter method for property <tt>username</tt>.
     *
     * @return property value of username
     */
    public String getUsername() {
        return username;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param username value to be assigned to property username
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * Getter method for property <tt>money</tt>.
     *
     * @return property value of money
     */
    public Integer getMoney() {
        return money;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param money value to be assigned to property money
     */
    public void setMoney(Integer money) {
        this.money = money;
    }
}
