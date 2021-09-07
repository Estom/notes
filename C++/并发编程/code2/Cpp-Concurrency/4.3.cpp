//
//  4.3.cpp 等待一个事件或其他事件->使用条件变量构建线程安全队列
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  线程安全的队列接口

#include <memory>

template <typename T>
class threadsafe_queue {
public:
    threadsafe_queue();
    threadsafe_queue(const threadsafe_queue&);
    threadsafe_queue& operator=(const threadsafe_queue&) = delete;
    
    void push(T new_value);
    
    bool try_pop(T& value);
    std::shared_ptr<T> try_pop();
    
    void wait_and_pop(T& value);
    std::shared_ptr<T> wait_and_pop();
    
    bool empty() const;
};

int main() {
    
}
