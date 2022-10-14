/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.factorybean;

import com.ykl.collectiontype.Course;
import org.hamcrest.Factory;
import org.springframework.beans.factory.FactoryBean;

/**
 * @author yinkanglong
 * @version : MyBean, v 0.1 2022-10-08 16:42 yinkanglong Exp $
 */
public class MyBean implements FactoryBean<Course> {

    //定义返回bea
    @Override
    public Course getObject() throws Exception {
        Course course = new Course();
        return course;
    }

    @Override
    public Class<?> getObjectType() {
        return null;
    }

    @Override
    public boolean isSingleton() {
        return FactoryBean.super.isSingleton();
    }
}
