/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.bean;

/**
 * @author yinkanglong
 * @version : Dept, v 0.1 2022-10-08 15:33 yinkanglong Exp $
 */
public class Dept {
    private String dname;

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param dname value to be assigned to property pname
     */
    public void setDname(String dname) {
        this.dname = dname;
    }

    @Override
    public String toString() {
        return "Dept{" +
                "pname='" + dname + '\'' +
                '}';
    }
}
