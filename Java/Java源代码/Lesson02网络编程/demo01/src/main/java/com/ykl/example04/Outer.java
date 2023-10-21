/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.example04;

/**
 * @author yinkanglong
 * @version : Outer, v 0.1 2022-07-24 13:19 yinkanglong Exp $
 */
public class Outer {
    private int id;
    public void out(){
        System.out.println("outer method");
    }

    public class Inner{
        public void in(){
            System.out.println("inner method");

            //成员内部类可以直接获取外部类的私有属性。
        }
    }

    public static class InnerStatic{

    }
    public void method(){
        class Inner{
            public void inMehtod(){
                System.out.println("这是一个方法内部类");
            }
        }
    }
    public static void main(String[] args) {
        Outer outer = new Outer();
        outer.out();
        //通过外部类的new方法实例化一个对象
        Outer.Inner inner = outer.new Inner();
        inner.in();

        new A().eat();
    }
}

//一个Java文件中有多个类，但是只能有一个public
class A{
    public void eat(){

    }
}
