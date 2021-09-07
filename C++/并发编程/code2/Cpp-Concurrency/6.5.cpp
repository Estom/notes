//
//  6.5.cpp 基于锁的并发数据结构->线程安全队列一一使用细粒度锁和条件变量
//  通过分离数据实现并发
//  预分配一个虚拟节点，永远在队列最后，用来分离头尾指针都能访问的节点
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  带有虚拟节点的队列

#include <memory>
template <typename T>
class queue {
private:
    struct node {
        std::shared_ptr<T> data; // node 存在数据指针中
        std::unique_ptr<node> next;
    };
    
    std::unique_ptr<node> head;
    node* tail;
    
public:
    queue(): head(new node), tail(head.get()) {} // 构造函数
    queue(const queue& other) = delete;
    queue& operator=(const queue& other) = delete;
    
    std::shared_ptr<T> try_pop() {
        if (head.get() == tail) { // 头和尾（虚拟节点）比较，而不需要指针判空
            return std::shared_ptr<T>();
        }
        std::shared_ptr<T> const res(head->data); // node存在指针中，所以直接对指针进行检索，而不是构造一个类型T的新实例
        std::unique_ptr<node> const old_head = std::move(head);
        head = std::move(old_head->next);
        return res;
    }
    
    void push(T new_value) {
        std::shared_ptr<T> new_data(std::make_shared<T>(std::move(new_value))); // make_shared避免内存分配两次
        std::unique_ptr<node> p(new node);
        tail->data = new_data; // 把new_data赋值给虚拟节点
        node* const new_tail = p.get();
        tail->next = std::move(p);
        tail = new_tail;
    }
};
