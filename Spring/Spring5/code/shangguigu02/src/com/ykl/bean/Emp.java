/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.bean;

/**
 * @author yinkanglong
 * @version : Emp, v 0.1 2022-10-08 15:34 yinkanglong Exp $
 */
public class Emp {
    private String ename;
    private String gender;

    @Override
    public String toString() {
        return "Emp{" +
                "ename='" + ename + '\'' +
                ", gender='" + gender + '\'' +
                ", dept=" + dept +
                '}';
    }

    public void setDept(Dept dept) {
        this.dept = dept;
    }

    private Dept dept;

    public void setEname(String ename) {
        this.ename = ename;
    }


    public void setGender(String gender) {
        this.gender = gender;
    }
}
