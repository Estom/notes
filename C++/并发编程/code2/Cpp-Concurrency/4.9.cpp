//
//  4.9.cpp 使用期望等待一次性事件->任务与期望->线程间传递任务
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用 std::packaged_task 执行一个图形界面线程

#include <deque>
#include <mutex>
#include <future>
#include <thread>
#include <utility>

std::mutex m;
std::deque<std::packaged_task<void()> > tasks;

bool gui_shutdown_message_received();
void get_and_process_gui_message();

void gui_thread() { // gui线程一直循环，直到收到关闭信息
    while (!gui_shutdown_message_received()) { // 收到关闭信息
        get_and_process_gui_message(); // 轮询界面消息处理
        std::packaged_task<void()> task;
        {
            std::lock_guard<std::mutex> lk(m);
            if (tasks.empty()) // 没有任务时，再次循环
                continue;
            task = std::move(tasks.front()); // 提取任务
            tasks.pop_front();
        }
        task(); // 释放锁，执行任务
    }
}

std::thread gui_bg_thread(gui_thread);

template <typename Func>
std::future<void> post_task_for_gui_thread(Func f) {
    std::packaged_task<void()> task(f); // 提供一个打包好的任务
    std::future<void> res = task.get_future(); // 通过这个任务调用 get_future() 获取“期望”对象
    std::lock_guard<std::mutex> lk(m);
    tasks.push_back(std::move(task));
    return res;
}
