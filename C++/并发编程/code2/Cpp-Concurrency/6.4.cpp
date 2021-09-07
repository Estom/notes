//
//  6.4.cpp 基于锁的并发数据结构->线程安全队列一一使用细粒度锁和条件变量
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  队列实现一一单线程版

#include <memory>

template <typename T>
class queue {
private:
    struct node {
        T data;
        std::unique_ptr<node> next;
        
        node(T data_): data(std::move(data_)) {}
    };
    
    std::unique_ptr<node> head;
    node* tail;
    
public:
    queue(): tail(nullptr) {}
    queue(const queue& other) = delete;
    queue& operator=(const queue& other) = delete;
    
    std::shared_ptr<T> try_pop() {
        if (!head) {
            return std::shared_ptr<T>();
        }
        std::shared_ptr<T> const res(std::make_shared<T>(std::move(head->data)));
        std::unique_ptr<node> const old_head = std::move(head);
        head = std::move(old_head->next);
        return res;
    }
    
    void push(T new_value) {
        std::unique_ptr<node> p(new node(std::move(new_value)));
        node* const new_tail = p.get();
        if (tail) {
            tail->next = std::move(p);
        }
        else {
            head = std::move(p);
        }
        tail = new_tail;
    }
};
