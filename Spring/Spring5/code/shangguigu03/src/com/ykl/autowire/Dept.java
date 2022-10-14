/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.autowire;

/**
 * @author yinkanglong
 * @version : Detp, v 0.1 2022-10-09 10:55 yinkanglong Exp $
 */
public class Dept {
    private String dname;

    /**
     * Getter method for property <tt>dname</tt>.
     *
     * @return property value of dname
     */
    public String getDname() {
        return dname;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param dname value to be assigned to property dname
     */
    public void setDname(String dname) {
        this.dname = dname;
    }

    @Override
    public String toString() {
        return "Dept{" +
                "dname='" + dname + '\'' +
                '}';
    }
}
