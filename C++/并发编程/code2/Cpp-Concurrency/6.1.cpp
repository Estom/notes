//
//  6.1.cpp 基于锁的并发数据结构->线程安全栈一一使用锁
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  对3.5中线程安全栈的进一步分析

#include <exception>
#include <stack>
#include <mutex>
#include <memory>

struct empty_stack: std::exception {
    const char* what() const throw() {
        return "empty stack";
    }
};

template <typename T>
class threadsafe_stack {
private:
    std::stack<T> data;
    mutable std::mutex m;
public:
    threadsafe_stack() {}
    threadsafe_stack(const threadsafe_stack& other) {
        std::lock_guard<std::mutex> lock(other.m);
        data = other.data;  // 在构造函数体中执行拷贝
    }
    threadsafe_stack& operator=(const threadsafe_stack&) = delete;
    
    void push(T new_value) {
        std::lock_guard<std::mutex> lock(m); /* 可能异常，但是很罕见*/
        data.push(std::move(new_value)); /* 可能异常，内存不足时*/ /* 可能死锁 */
    }
    
    /* empty() 和 pop() 存在潜在的竞争，但是因为在pop()上锁时会检查栈是否为空，所以竞争是非恶性的 */
    /* 如果pop() 直接返回弹出值，就可以避免潜在竞争 */
    std::shared_ptr<T> pop() {
        std::lock_guard<std::mutex> lock(m);
        // 调用pop前，检查栈是否为空
        if (data.empty())
            throw empty_stack();
        // 在修改堆栈前，分配出返回值
        /* res的创建可能异常*/
        /* 1. 对于 std::make_shared的调用，可能内存不足 */
        /* 2. 在拷贝或移动构造到新分配的内存中返回时抛出异常 */
        /* 但是在c++运行库和标准库中，这里是安全的，“异常-安全” */
        std::shared_ptr<T> const res(std::make_shared<T>(std::move(data.top()))); /* 可能死锁 */
        data.pop();
        return res;
        
    }
    
    /* 也是 “异常-安全” */
    void pop(T& value) {
        std::lock_guard<std::mutex> lock(m);
        if (data.empty())
            throw empty_stack();
        value = std::move(data.top()); /* 可能死锁 */
        data.pop();
    }
    
    /* 也是 “异常-安全” */
    bool empty() const {
        std::lock_guard<std::mutex> lock(m);
        return data.empty();
    }
};

int main() {
    threadsafe_stack<int> si;
    si.push(5);
    si.pop();
    if (!si.empty()) {
        int x;
        si.pop(x);
    }
}
