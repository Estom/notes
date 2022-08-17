// package com.ykl.exceptions;

/**
 * Java工程目录结构
 * * src下的内容才能被识别
 */
public class ExceptionTest{
    public static void main(String[] args) {
        System.out.println("Hello World!");
        int a =0;
        int b =1;

        try {
            System.out.println(b/a);
        } catch (ArithmeticException e) {
            //TODO: handle exception
            System.out.println("数学异常");
            System.out.println("e.toString"+e.toString());
            System.out.println("e.printStackTrace()");
            e.printStackTrace();
            // System.out.println();
            System.out.println("e.getMessage"+e.getMessage());
            System.out.println("e.getCause"+e.getCause());

            System.out.println("e.fillInStackTrace()"+e.fillInStackTrace());
        } finally{
            System.out.println("finnaly清理工作");
        }
    }
}



