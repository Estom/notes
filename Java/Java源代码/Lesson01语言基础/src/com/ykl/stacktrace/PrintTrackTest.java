package com.ykl.stacktrace;

import java.lang.System;
import java.lang.RuntimeException;
import java.lang.Thread;
import java.util.stream.Stream;

public class PrintTrackTest {

    void printTrackTest() {
        // 1.打印调用堆栈
        RuntimeException e = new RuntimeException("print stacktrace");

       // e.fillInStackTrace();

        System.out.println("1.打印调用堆栈");
        Stream.of(e.getStackTrace()).forEach(System.out::println);

        // 2.打印调用堆栈
        System.out.println("2.打印调用堆栈");
        Stream.of(Thread.currentThread().getStackTrace()).forEach(System.out::println);
    }

    public void first_method(){
        second_method();
    }

    public void second_method(){
        printTrackTest();
    }

    
    public static void main(String[] args) {
        new PrintTrackTest().first_method();
    }
    
}
