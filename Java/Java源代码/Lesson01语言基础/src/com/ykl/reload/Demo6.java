package com.ykl;
/**
 * 验证函数重载和类型转换的优先级
 */

import java.sql.Array;

public class Demo6 {
    public static void main(String[] args) {
        int [] numbers = {10, 20, 30, 40, 50};
        max(1.1,2);
//        for(int x : numbers ) {
//            if( x == 30 ) {
//                continue;
//            }
//            System.out.print( x );
//            System.out.print("\n");
//        }
//        for (int i = 0; i <= 5; i++) {
//            for (int j = 0; j < i; j++) {
//                System.out.print("*");
//            }
//            for (int k = 0; k < 5; k++) {
//
//            }
//            System.out.println();
//        }
        Integer a = 10;
        Array b;
    }

    public static void max(double a,double b){
        System.out.println(1);
    }
    public static void max(int a,int b){
        System.out.println(2);
    }
    public static void max(int a,int b,int c){
        System.out.println(3);
    }
}
