/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.collectiontype;

import java.util.List;

/**
 * @author yinkanglong
 * @version : Book, v 0.1 2022-10-08 16:29 yinkanglong Exp $
 */
public class Book {
    private List<String > bookList;


    public void setBookList(List<String> bookList) {
        this.bookList = bookList;
    }

    @Override
    public String toString() {
        return "Book{" +
                "bookList=" + bookList +
                '}';
    }
}
