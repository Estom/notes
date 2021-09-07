//
//  3.4.cpp 定义线程安全的堆栈
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  线程安全的堆栈定义(概述)
//  传入一个引用 + 返回指向弹出值的指针
//  重载了pop()，使用一个局部引用去存储弹出值，并返回 std::shared_ptr<>对象

#include <exception>
#include <memory>

struct empty_stack : std::exception {
    const char* what() const throw();
};

template <typename T>
class threadsafe_stack {
public:
    threadsafe_stack();
    threadsafe_stack(const threadsafe_stack&);
    threadsafe_stack& operator=(const threadsafe_stack&) = delete;
    
    void push(T new_value);
    std::shared_ptr<T> pop();
    void pop(T& value);
    bool empty() const;
};

int main() {
    
}
