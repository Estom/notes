//
//  4.4.cpp 等待一个事件或其他事件->使用条件变量构建线程安全队列
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  从4.1提取出 push() 和 wait_and_pop()

#include <mutex>
#include <condition_variable>
#include <queue>

template <typename T>

class threadsafe_queue {
private:
    std::mutex mut;
    std::queue<T> data_queue;
    std::condition_variable data_cond;
public:
    void push(T new_value) {
        std::lock_guard<std::mutex> lk(mut);
        data_queue.push(new_value);
        data_cond.notify_one();
    }
    
    void wait_and_pop(T& value) {
        std::unique_lock<std::mutex> lk(mut);
        data_cond.wait(lk, [this] { return !data_queue.empty(); });
        value = data_queue.front();
        data_queue.pop();
    }
};

struct data_chunk {
    
};

data_chunk prepare_data();
bool more_data_to_process();
void process(data_chunk);
bool is_last_chunk(data_chunk);

threadsafe_queue<data_chunk> data_queue;

void data_preparation_thread() {
    while (more_data_to_process()) {
        data_chunk const data = prepare_data();
        data_queue.push(data);
    }
}

void data_processing_thread() {
    while (true) {
        data_chunk data;
        data_queue.wait_and_pop(data);
        process(data);
        if (is_last_chunk(data))
            break;
    }
}
