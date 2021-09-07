//
//  5.10.cpp 同步操作和强制排序->原子操作中的内存顺序
//  获取-释放序列
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用 std::memory_order_consume 同步数据

#include <string>
#include <thread>
#include <atomic>
#include <chrono>
#include <assert.h>

struct X {
    int i;
    std::string s;
};

std::atomic<X*> p;
std::atomic<int> a;

void create_x() {
    X* x = new X;
    x->i = 42;
    x->s = "hello";
    a.store(99, std::memory_order_relaxed); // 在p之前储存a
    p.store(x, std::memory_order_release);
}

void use_x() {
    X* x;
    while (!(x = p.load(std::memory_order_consume))) // std::memory_order_consume 意味着储存前需要先加载
        std::this_thread::sleep_for(std::chrono::microseconds(1));
    assert(x->i == 42); // 不会触发
    assert(x->s == "hello"); // 不会触发
    assert(a.load(std::memory_order_relaxed) == 99); // 不能确定
}

int main() {
    std::thread t1(create_x);
    std::thread t2(use_x);
    t1.join();
    t2.join();
}
