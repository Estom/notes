/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.autowire;

/**
 * @author yinkanglong
 * @version : Emp, v 0.1 2022-10-09 10:55 yinkanglong Exp $
 */
public class Emp {
    private Dept dept;

    /**
     * Getter method for property <tt>dept</tt>.
     *
     * @return property value of dept
     */
    public Dept getDept() {
        return dept;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param dept value to be assigned to property dept
     */
    public void setDept(Dept dept) {
        this.dept = dept;
    }

    @Override
    public String toString() {
        return "Emp{" +
                "dept=" + dept +
                '}';
    }
}
