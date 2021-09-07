//
//  5.11.cpp 同步操作和强制排序->释放队列与同步
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用原子操作从队列中读取数据

#include <atomic>
#include <thread>
#include <vector>

std::vector<int> queue_data;
std::atomic<int> count;

// 占据队列
void populate_queue() {
    unsigned const number_of_items = 20;
    queue_data.clear();
    for (unsigned i = 0; i < number_of_items; ++i) {
        queue_data.push_back(i);
    }
    count.store(number_of_items, std::memory_order_release); // 初始化储存
}

// 读取队列
void consume_queue_items() {
    while (true) {
        int item_index;
        if ((item_index = count.fetch_sub(1, std::memory_order_acquire)) <= 0) { // 一个 “读-改-写” 操作
            wait_for_more_items(); // 等待更多元素
            continue;
        }
        process(queue_data[item_index - 1]); // 完全读取queue_data
    }
}

int main() {
    std::thread a(populate_queue);
    std::thread b(consume_queue_items);
    std::thread c(consume_queue_items);
    
    a.join();
    b.join();
    c.join();
}
