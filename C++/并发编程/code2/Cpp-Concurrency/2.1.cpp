//
//  2.1.cpp 不等待线程的问题
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//  函数已经结束，线程依旧访问局部变量

#include <thread>

void do_something(int& i) {
    ++i;
}

struct func {
    int& i;
    func(int& i_):i(i_) {}
    void operator()() {
        for (unsigned j = 0; j < 1000000; ++j) {
            do_something(i); // 存在隐患，悬空引用
        }
    }
};

void opps() {
    int some_local_state = 0;
    func my_func(some_local_state);
    std::thread my_thread(my_func);
    my_thread.detach(); // 不等待线程结束
}                       // 新线程可能还在运行

int main() {
    opps();
}
