package com.ykl;

import com.ykl.example01.Person;

/**
 * Hello world!
 * 用来验证初始化的执行顺序。
 */
public class App03
{
    public static void main( String[] args )
    {
        Person person = new Person();
        Person person3 = new Person();
        person.say();

    }
}
