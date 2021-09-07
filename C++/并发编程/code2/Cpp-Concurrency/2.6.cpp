//
//  2.6.cpp 转移线程所有权
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//  定义scoped_thread类来 确保线程程序在退出前完成

#include <thread>
#include <utility>

class scoped_thread {
    std::thread t;
public:
    explicit scoped_thread(std::thread t_): t(std::move(t_)) {
        if (!t.joinable()) {
            throw std::logic_error("No thread");
        }
    }
    ~scoped_thread() {
        t.join();
    }
    scoped_thread(scoped_thread const&) = delete;
    scoped_thread& operator= (scoped_thread const &) = delete;
};

void do_something(int& i) {
    ++i;
}

struct func {
    int& i;
    
    func(int& i_) : i(i_) {}
    
    void operator() () {
        for (unsigned j = 0; j < 1000000; ++j) {
            do_something(i);
        }
    }
};

void do_something_in_current_thread() {
}

void f() {
    int some_local_state;
    scoped_thread t((std::thread(func(some_local_state)))); // 外面需要再加一个括号？Parentheses were disambiguated as a function declaration
    
    do_something_in_current_thread();
}

int main() {
    f();
}
