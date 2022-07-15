/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * @author yinkanglong
 * @version : MyAnnotation, v 0.1 2022-07-12 09:48 yinkanglong Exp $
 */
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {
    String getValue() default "no description";
}
public class MyAnnotation {
}
