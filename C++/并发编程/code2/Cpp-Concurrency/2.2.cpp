//
//  2.2.cpp 等待线程完成
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//

#include <thread>

void do_something(int &i) {
    ++i;
}

struct func {
    int& i;
    
    func (int& i_):i(i_){}
    
    void operator()() {
        for (unsigned j = 0; j < 10000000; ++j) {
            do_something(i);
        }
    }
};

void do_something_in_current_thread() {

}

void f() {
    int some_local_state = 0;
    func my_func(some_local_state);
    std::thread t(my_func);
    try {
        do_something_in_current_thread();
    }
    catch(...) {
        t.join();
        throw;
    }
    t.join();
}

int main() {
    f();
}
