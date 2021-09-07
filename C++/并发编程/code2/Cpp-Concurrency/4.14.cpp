//
//  4.14.cpp 使用同步操作简化代码->使用“期望”的函数式编程
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  比起使用 std::async(),
//  对 std::packaged_task 和 std::thread 做简单包装->spawn_task()
//  spawn_task 的简单实现

#include <future>
#include <thread>

template <typename F, typename A>
std::future<typename std::result_of<F(A&&)>::type> spawn_task(F&& f, A&& a) {
    typedef typename std::result_of<F(A&&)>::type result_type;
    std::packaged_task<result_type(A&&)> task(std::move(f));
    std::future<result_type> res(task.get_future());
    std::thread t(std::move(task), std::move(a));
    t.detach();
    return res;
}
