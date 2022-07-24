package com.ykl;

import com.ykl.example01.Animal;
import com.ykl.example01.Dog;

/**
 * Hello world!
 *
 */
public class App01
{
    public static void main( String[] args )
    {
        System.out.println( "Hello World!" );
        Dog dd = new Dog();
        Animal ad = new Dog();
        dd.say();
        dd.eat();
        ad.say();
        ad.eat();
    }
}
