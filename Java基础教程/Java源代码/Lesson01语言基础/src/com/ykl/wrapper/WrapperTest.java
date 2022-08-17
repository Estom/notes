package com.ykl.wrapper;

/**
 * 用来验证拆箱装箱的有效性
 */
public class WrapperTest {
    public static void main(String[] args) {
        int a=1;
        int b=2;

        Integer c =1;
        Integer d =2;
        Integer e =new Integer(1);
        System.out.println(a==b);
        System.out.println(a==c);
        System.out.println(c==d);
        System.out.println(c==e);//不拆箱
        System.out.println(c.equals(d));
        System.out.println(c.equals(e));
        System.out.println(e.equals(a));//类型不转换

    }
}
