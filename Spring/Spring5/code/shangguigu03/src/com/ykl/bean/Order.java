/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.bean;

/**
 * @author yinkanglong
 * @version : order, v 0.1 2022-10-09 10:17 yinkanglong Exp $
 */
public class Order {
    private String oname;

    public Order(String oname) {
        this.oname = oname;
    }

    public Order() {
        System.out.println("第一步 执行无参构造函数创建bean实例");
    }


    public void setOname(String oname) {
        this.oname = oname;
        System.out.println("第二步 调用set方法设置属性值");
    }

    public String getOname() {
        return oname;
    }

    public void initMethod(){
        System.out.println("第三部 调用初始化方法");
    }

    public void destroyMethod(){
        System.out.println("第五步 调用销毁方法");
    }

}
