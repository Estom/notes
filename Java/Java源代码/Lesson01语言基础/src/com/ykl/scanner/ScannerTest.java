package com.ykl;

import java.util.Scanner;

/**
 * 验证scanner输入输出的有效性
 */
public class ScannerTest {
    public static void main(String[] args) {
        Scanner s = new Scanner(System.in);

        System.out.println("使用不同的方式读取数据");

//        // hasNext会一直阻塞，直到由新的内容。
//        while(s.hasNext()){
//            System.out.println("读取前的环节");
//            String str = s.next();
//            System.out.println("读取到的内容位："+str);
//        }
//
//
//        // hasNextLine会一直阻塞，直到由新的内容。测试一下next()是否会阻塞
//        while(s.hasNextLine()){
//            System.out.println("读取前的环节");
//            String str = s.nextLine();
//            System.out.println("读取到的内容位："+str);
//        }
//

        //hasNextInt方法会阻塞，如果不是整数会返回False
        if(s.hasNextInt()){
            System.out.println("读取前的环节");
            int str = s.nextInt();
            System.out.println("读取到的内容位："+str);
        }
        else{
            System.out.println("你输入的不是整数");
        }

        s.close();
    }

}
