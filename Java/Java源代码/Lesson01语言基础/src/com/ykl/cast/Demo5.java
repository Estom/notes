package com.ykl;
/**
 * @author ykl
 * @since 2022
 * @version 1.0
 * 验证前置类型转换的有效性
 */
public class Demo5 {
    /**
     *
     * @param args canshu
     */
    public static void main(String[] args) {
        int i = 128;
        byte b = (byte)i;//-128 强制类型转换，避免内存溢出。
        System.out.println(b);

//        操作比较大的数的时候，注意溢出问题。数字之间可以使用下划线进行分割，只起到标识作用。

    }
}
