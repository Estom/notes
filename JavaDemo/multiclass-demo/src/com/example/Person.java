package com.example;

import com.example.util.StringUtils;

public class Person {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        // 使用工具类方法
        this.name = StringUtils.capitalize(name);
        this.age = age;
    }
    
    public String getName() {
        return name;
    }
    
    public int getAge() {
        return age;
    }
    
    public void setName(String name) {
        this.name = StringUtils.capitalize(name);
    }
    
    public void setAge(int age) {
        this.age = age;
    }
    
    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }
}