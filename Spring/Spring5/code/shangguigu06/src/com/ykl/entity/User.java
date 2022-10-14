/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.entity;

/**
 * @author yinkanglong
 * @version : User, v 0.1 2022-10-10 09:14 yinkanglong Exp $
 */
public class User {
    private String userId;
    private String username;
    private String userStatus;

    /**
     * Getter method for property <tt>userId</tt>.
     *
     * @return property value of userId
     */
    public String getUserId() {
        return userId;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param userId value to be assigned to property userId
     */
    public void setUserId(String userId) {
        this.userId = userId;
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
     * Getter method for property <tt>userStatus</tt>.
     *
     * @return property value of userStatus
     */
    public String getUserStatus() {
        return userStatus;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param userStatus value to be assigned to property userStatus
     */
    public void setUserStatus(String userStatus) {
        this.userStatus = userStatus;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId='" + userId + '\'' +
                ", username='" + username + '\'' +
                ", userStatus='" + userStatus + '\'' +
                '}';
    }
}
