//
//  5.2.cpp 同步操作和强制排序
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  不同线程对数据的读写
//  对于非原子操作，使用原子操作对操作进行强制排序

#include <vector>
#include <atomic>
#include <iostream>
#include <chrono>
#include <thread>

std::vector<int> data;
std::atomic_bool data_ready(false);

void reader_thread() {
    while (!data_ready.load()) { // 等待数据
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }
    std::cout << "The answer=" << data[0] << "\n"; // 非原子读出数据
}

void writer_thread() {
    data.push_back(42); // 非原子写入数据
    data_ready = true;
}
