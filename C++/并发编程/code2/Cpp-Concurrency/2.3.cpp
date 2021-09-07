//
//  2.3.cpp 使用RAII等待线程完成
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//  在析构函数中使用join()

#include <thread>

class thread_guard {
    std::thread& t;
public:
    explicit thread_guard(std::thread& t_): t(t_) {}
    ~thread_guard() {
        if (t.joinable()) { // 判断线程是否加入
            t.join();
        }
    }
    thread_guard(thread_guard const&) = delete; // 不让编译器自动生成它们
    thread_guard& operator=(thread_guard const&) = delete;
};

void do_something(int& i) {
    ++i;
}

struct func {
    int& i;
    func(int& i_): i(i_) {}
    
    void operator()() {
        for (unsigned j = 0; j < 1000000; ++j) {
            do_something(i);
        }
    }
};

void do_something_in_current_thread() {

}

void f() {
    int some_local_state;
    func my_func(some_local_state);
    std::thread t(my_func);
    thread_guard g(t);
    
    do_something_in_current_thread();
} // 局部对象被逆序销毁

int main() {
    f();
}
