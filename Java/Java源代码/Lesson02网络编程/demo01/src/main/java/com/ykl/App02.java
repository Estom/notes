package com.ykl;

import com.ykl.example01.Animal;
import com.ykl.example01.Dog;

/**
 * Hello world!
 * 用来验证不同的类型转换方法，是否成功和最终输出的结果。
 */
public class App02
{
    public static void main( String[] args )
    {
        System.out.println( "Hello World!" );
        Dog dd = new Dog();
        Animal aa = new Animal();
        Animal ad = new Dog();

        dd.say();  //dog say
        ((Animal)dd).say();//dog say
        aa.say();// animal say
//        ((Dog) aa).say();// down
        ad.say();//dog say
        ((Dog) ad).say();//dog say
    }
}
