//
//  4.1.cpp 等待一个事件或其他事件->等待条件达成
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用 std::condition_variable 处理数据等待

#include <mutex>
#include <condition_variable>
#include <thread>
#include <queue>

bool more_data_to_prepare() {
    return false;
}

struct data_chunk {
    
};

data_chunk prepare_data() {
    return data_chunk();
}

void process(data_chunk&) {
    
}

bool is_last_chunk(data_chunk&) {
    return true;
}

std::mutex mut;
std::queue<data_chunk> data_queue; // 两个线程之间传递数据的队列
std::condition_variable data_cond;

void data_preparation_thread() {
    while (more_data_to_prepare()) {
        data_chunk const data = prepare_data();
        std::lock_guard<std::mutex> lk(mut);
        data_queue.push(data); // 准备好的数据放入队列
        data_cond.notify_one(); // 通知等待线程
    }
}

void data_processing_thread() {
    while (true) {
        std::unique_lock<std::mutex> lk(mut); // 这里 unique_lock 比 lock_guard 好
                                              // 因为等待中的线程必须在等待期间解锁互斥量，并在这之后对互斥量再次上锁
                                              // 所以需要用灵活的 unique_lock，如果在休眠期间锁不能解开就不能满足以上条件
        data_cond.wait(lk, [] { return !data_queue.empty(); }); // wait传递一个锁 和 lambda->检查队列是否为空
        data_chunk data = data_queue.front();
        data_queue.pop();
        lk.unlock(); // 解锁不仅可以用于wait，还可以用于待处理的数据
        process(data);
        if (is_last_chunk(data))
            break;
    }
}

int main() {
    std::thread t1(data_preparation_thread);
    std::thread t2(data_processing_thread);
    
    t1.join();
    t2.join();
}
