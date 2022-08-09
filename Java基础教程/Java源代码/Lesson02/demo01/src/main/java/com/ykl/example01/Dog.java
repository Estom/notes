package com.ykl.example01;

import com.ykl.example01.Animal;

public class Dog extends Animal{
    // final方法默认不能被覆盖，编译器报错。
    // public void eat(){
    //     System.out.println("dog eat");
    // }

    public void say(){
        System.out.println("dog say");
    }
}
