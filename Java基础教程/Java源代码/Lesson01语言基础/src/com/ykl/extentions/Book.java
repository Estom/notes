package com.ykl.extentions;

/**
 * 验证静态变量能够被类的实例访问
 */

class Book{
    private String name;
    private int price;
    static final String id="BOOK";
    public static void main(String[] args) {
        Book book = new Book();
        System.out.println(book.name);
        System.out.println(book.price);
        // 事实证明这三种方法都能够访问到类变量
        System.out.println(id);
        System.out.println(Book.id);
        System.out.println(book.id);
    }
 }