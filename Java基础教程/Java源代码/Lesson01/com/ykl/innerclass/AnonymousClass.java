// package com.ykl.innerclass;
import java.lang.Thread;
 /**
  * AnonymousClass
  */
 public class AnonymousClass {
 
    private int a;

    public static void main(String[] args){
        new AnonymousClass().test(2);
    }

    //事实证明匿名内部类
    public void test(final int a){
        int b =10;
        int c =11;
        new Thread(){
            public void run() {
                System.out.println(a);
                System.out.println(b);
            }
        }.start();
        b = 12;
        System.out.print(b);
    }

 }