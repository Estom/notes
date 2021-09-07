//
//  5.6.cpp 同步操作和强制排序->原子操作中的内存顺序
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  非限制操作一一多线程版

#include <thread>
#include <atomic>
#include <iostream>

std::atomic<int> x(0), y(0), z(0); // 三个全局原子比变量
std::atomic<bool> go(false); // 原子变量go确保循环在同时退出
unsigned const loop_count = 10;

struct read_values {
    int x, y, z;
};

read_values values1[loop_count];
read_values values2[loop_count];
read_values values3[loop_count];
read_values values4[loop_count];
read_values values5[loop_count];

void increment(std::atomic<int>* var_to_inc, read_values* values) {
    while (!go)
        std::this_thread::yield(); // 自旋，等待信号
    for (unsigned i = 0; i < loop_count; ++i) {
        values[i].x = x.load(std::memory_order_relaxed);
        values[i].y = y.load(std::memory_order_relaxed);
        values[i].z = z.load(std::memory_order_relaxed);
        var_to_inc->store(i+1, std::memory_order_relaxed); //通过循环来更新其中一个原子变量，剩下的两个负责读取
        std::this_thread::yield();
    }
}

void read_vals(read_values* values) {
    while (!go) {
        std::this_thread::yield();
    }
    for (unsigned i = 0; i < loop_count; ++i) {
        values[i].x = x.load(std::memory_order_relaxed);
        values[i].y = y.load(std::memory_order_relaxed);
        values[i].z = z.load(std::memory_order_relaxed);
        std::this_thread::yield();
    }
}

void print(read_values* v) {
    for (unsigned i = 0; i < loop_count; ++i) {
        if (i) {
            std::cout << ",";
        }
        std::cout << "(" << v[i].x << "," << v[i].y << "," << v[i].z << ")";
    }
    std::cout << std::endl;
}

int main() {
    std::thread t1(increment, &x, values1);
    std::thread t2(increment, &y, values2);
    std::thread t3(increment, &z, values3);
    
    std::thread t4(read_vals, values4);
    std::thread t5(read_vals, values5);
    go = true; // 开始执行主循环的信号
    t5.join();
    t4.join();
    t3.join();
    t2.join();
    t1.join();
    print(values1);
    print(values2);
    print(values3);
    print(values4);
    print(values5);
}

//一种输出结果：
// 更新：
//(0,0,0),(1,1,1),(2,3,3),(3,4,4),(4,5,5),(5,6,6),(6,7,7),(7,8,8),(8,9,9),(9,10,10)
//(1,0,0),(2,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9)
//(1,1,0),(2,2,1),(2,3,2),(3,4,3),(4,5,4),(5,6,5),(6,7,6),(7,8,7),(8,9,8),(9,10,9)
// 读取：
//(1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10)
//(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(10,10,10)
