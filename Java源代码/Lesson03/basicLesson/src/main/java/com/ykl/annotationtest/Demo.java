/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.annotationtest;

/**
 * @author yinkanglong
 * @version : Demo, v 0.1 2022-07-12 09:49 yinkanglong Exp $
 */
/**
 * @author qiyu
 */
@MyAnnotation(getValue = "annotation on class")
public class Demo {

    @MyAnnotation(getValue = "annotation on field")
    public String name;

    @MyAnnotation(getValue = "annotation on method")
    public void hello() {}

    @MyAnnotation() // 故意不指定getValue
    public void defaultMethod() {}
}