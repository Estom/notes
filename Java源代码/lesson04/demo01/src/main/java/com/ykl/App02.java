package com.ykl.example01;

/**
 * Hello world!
 *
 */
public class App02
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
