/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.collectiontype;

/**
 * @author yinkanglong
 * @version : Course, v 0.1 2022-10-08 16:15 yinkanglong Exp $
 */
public class Course {
    private String cname;

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param cname value to be assigned to property cname
     */
    public void setCname(String cname) {
        this.cname = cname;
    }

    @Override
    public String toString() {
        return "Course{" +
                "cname='" + cname + '\'' +
                '}';
    }
}
