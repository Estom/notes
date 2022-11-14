/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.code.entity;

/**
 * @author faran
 * @version : Pet, v 0.1 2022-11-12 13:36 faran Exp $
 */
public class Pet {
    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param name value to be assigned to property name
     */
    public void setName(String name) {
        this.name = name;
    }

    String name;

    public Pet() {
    }

    public Pet(String name) {
        this.name = name;
    }

    /**
     * Getter method for property <tt>name</tt>.
     *
     * @return property value of name
     */
    public String getName() {
        return name;
    }
}
