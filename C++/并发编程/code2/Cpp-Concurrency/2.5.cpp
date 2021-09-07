//
//  2.5.cpp 转移线程所有权
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//  函数返回 std::thread 对象

#include <thread>

void some_function() {

}

void some_other_function(int) {
    
}

std::thread f() {
    void some_function();
    return std::thread(some_function);
}

std::thread g() {
    void some_other_function(int);
    std::thread t(some_other_function, 42);
    return t;
}

int main() {
    std::thread t1 = f();
    t1.join();
    std::thread t2 = g();
    t2.join();
}
