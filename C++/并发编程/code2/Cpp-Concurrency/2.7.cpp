//
//  2.7.cpp 转移线程所有权
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//  量产线程，等待它们结束

#include <vector>
#include <thread>
#include <algorithm>
#include <functional>

void do_work(unsigned id) {
}

void f() {
    std::vector<std::thread> threads;
    for (unsigned i = 0; i < 20; ++i) {
        threads.push_back(std::thread(do_work, i));
    }
    std::for_each(threads.begin(), threads.end(), std::mem_fn(&std::thread::join)); // 让容器vector中的每一个元素都执行一遍join()
}

int main() {
    f();
}
