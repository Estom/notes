/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.code.entity;

/**
 * @author faran
 * @version : User, v 0.1 2022-11-12 13:34 faran Exp $
 */
public class User {
    String name;
    int age;

    /**
     * Getter method for property <tt>name</tt>.
     *
     * @return property value of name
     */
    public String getName() {
        return name;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param name value to be assigned to property name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Getter method for property <tt>age</tt>.
     *
     * @return property value of age
     */
    public int getAge() {
        return age;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param age value to be assigned to property age
     */
    public void setAge(int age) {
        this.age = age;
    }

    /**
     * Getter method for property <tt>pet</tt>.
     *
     * @return property value of pet
     */
    public Pet getPet() {
        return pet;
    }

    /**
     * Setter method for property <tt>counterType</tt>.
     *
     * @param pet value to be assigned to property pet
     */
    public void setPet(Pet pet) {
        this.pet = pet;
    }

    Pet pet;

    public User() {
    }

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
