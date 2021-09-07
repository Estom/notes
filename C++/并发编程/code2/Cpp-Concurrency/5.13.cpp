//
//  5.13.cpp 同步操作和强制排序->原子操作对非原子的操作排序
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用非原子操作执行序列

#include <atomic>
#include <thread>
#include <assert.h>

bool x = false; // x现在是一个非原子变量
std::atomic<bool> y;
std::atomic<int> z;

void write_x_then_y() {
    x = true;
    std::atomic_thread_fence(std::memory_order_release); // 释放栅栏
    y.store(true, std::memory_order_relaxed);
}

void read_y_then_x() {
    while (!y.load(std::memory_order_relaxed));
    std::atomic_thread_fence(std::memory_order_acquire); // 获取栅栏
    if (x)
        ++z;
}

int main() {
    x = false;
    y = false;
    z = 0;
    
    std::thread a(write_x_then_y);
    std::thread b(read_y_then_x);
    a.join();
    b.join();
    assert(z.load() != 0); // 因为栅栏的存在，断言不会被触发
}
