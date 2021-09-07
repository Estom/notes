//
//  9.1.cpp 高级线程管理->线程池
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/22.
//  Copyright © 2017年 kelele67. All rights reserved.
//  简单的线程池
//  任务没有返回值，需要执行一些阻塞操作时
//  可能会死锁

#include <atomic>
#include <vector>
#include <thread>

class thread_pool {
    std::atomic_bool done; //必须在threads数组前面声明，确保成员能以正确顺序销毁
    thread_safe_queue<std::function<void()> > work_queue; // work queue 必须在threads数组前面声明
    std::vector<std::thread> threads; // thread vector 必须在joiner前面声明
    join_threads joiner; // 汇聚所有线程
    
    void work_thread() {
        while (!done) {
            std::function<void()> task;
            if (work_queue.try_pop(task)) { // 从任务队列上面获取任务
                task(); // 执行这些任务
            }
            else {
                std::this_thread::yield(); // 如果队列上面没有任务，挂起线程，并且给予其他线程向任务队列上推送任务的机会
            }
        }
    }
public:
    thread_pool(): done(false), joiner(threads) {
        unsigned const thread_count = std::thread::hardware_concurrency(); // 获取硬件支持多少个并发线程
        try {
            for (unsigned i = 0; i < thread_count; ++i) {
                threads.push_back(std::thread(&thread_pool::work_thread, this));
            }
        }
        catch(...) {
            done = true;
            throw;
        }
    }
    
    ~thread_pool() {
        done = true;
    }
    
    // 将函数或可调用对象包装成一个 std::function<void()> 实例，并推入队列中
    template <typename FunctionType>
    void submit(FunctionType f) {
        work_queue.push(std::function<void()> (f));
    }
};

