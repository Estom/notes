//
//  9.2.cpp 高级线程管理->线程池
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/22.
//  Copyright © 2017年 kelele67. All rights reserved.
//  可等待任务的线程池

#include <queue>
#include <future>
#include <memory>
#include <functional>
#include <iostream>

class function_wrapper {
    struct impl_base {
        virtual void call() = 0;
        virtual ~impl_base() {}
    };
    std::unique_ptr<impl_base> impl;
    template <typename F>
    struct impl_type : impl_base {
        F f;
        impl_type(F&& f_) : f(std::move(f_)) {}
        void call() { f(); }
    };
public:
    template <typename F>
    function_wrapper(F&& f) : impl(new impl_type<F>(std::move(f))) {}
    void call() { impl->call(); };
    
    function_wrapper(function_wrapper&& other) : impl(std::move(other.impl)) {}
    
    function_wrapper& operator=(function_wrapper&& other) {
        impl = std::move(other.impl);
        return *this;
    }
    
    function_wrapper(const function_wrapper&) = delete;
    function_wrapper(function_wrapper&) = delete;
    function_wrapper& operator=(const function_wrapper&) = delete;
};

class thread_pool {
public:
    std::queue<function_wrapper> work_queue; // 使用function_wrapper，而非使用std::function
    
    void worker_thread() {
        while(!done) {
            function wrapper task;
            if (work_queue.try_pop(task)) {
                task();
            }
            else {
                std::this_thread::yield();
            }
        }
    }
public:
    
    template<typename FunctionType>
    std::future<typename std::result_of<FunctionType()>::type> // 返回一个 std::future<>保存任务的返回值，并允许调用者等待任务完全结束
    submit(FunctionType f) {
        typedef typename std::result_of<FunctionType()>::type result_type; // 对 result_type 使用 std::result_of
        
        std::packaged_task<result_type()> task(std::move(f)); // 将f包装入std::packaged_task<result_type()>
        std::future<result_type> res(task.get_future()); // 从 std::packaged_task<>中获取future
        work_queue.push_back(std::move(task)); // 向任务队列推送任务
        return res; // 返回future
    }
};
