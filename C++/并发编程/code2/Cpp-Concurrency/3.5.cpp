//
//  3.5.cpp 发现接口内在的条件竞争
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  线程安全的堆栈简单实现

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
        std::lock_guard<std::mutex> lock(m);
        data.push(new_value);
    }
    
    std::shared_ptr<T> pop() {
        std::lock_guard<std::mutex> lock(m);
        // 调用pop前，检查栈是否为空
        if (data.empty())
            throw empty_stack();
        // 在修改堆栈前，分配出返回值
        std::shared_ptr<T> const res(std::make_shared<T>(data.top()));
        data.pop();
        return res;
                                     
    }
    
    void pop(T& value) {
        std::lock_guard<std::mutex> lock(m);
        if (data.empty())
            throw empty_stack();
        value = data.top();
        data.pop();
    }
    
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
