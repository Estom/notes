//
//  7.11.cpp 无锁数据结构的例子->写一个无锁的线程安全队列
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  基于6.6的单生产者/单消费者模型下的无锁队列

#include <memory>
#include <atomic>

template <typename T>
class lock_free_queue {
private:
    struct node {
        std::shared_ptr<T> data;
        node* next;
        node() : next(nullptr) {}
    };
    std::atomic<node*> head;
    std::atomic<node*> tail;
    node* pop_head() {
        node* const old_head = head.load();
        if (old_head == tail.load()) { //加载tail
            return nullptr;
        }
        head.store(old_head->next);
        return old_head;
    }
public:
    lock_free_queue() : head(new node), tail(head.load()) {}
    lock_free_queue(const lock_free_queue& other) = delete;
    lock_free_queue& operator=(const lock_free_queue& other) = delete;
    ~lock_free_queue() {
        while (node* const old_head = head.load()) {
            head.store(old_head->next);
            delete old_head;
        }
    }
    std::shared_ptr<T> pop() {
        node* old_head = pop_head();
        if (!old_head) {
            return std::shared_ptr<T>();
        }
        std::shared_ptr<T> const res(old_head->data); //加载data指针
        delete old_head;
        return res;
    }
    void push(T new_value) {
        std::shared_ptr<T> new_data(std::make_shared<T>(new_value));
        node* p = new node; // 分配节点作为虚拟节点 -> 会发生竞争
        node* const old_tail = tail.load(); // 读取tail
        old_tail->data.swap(new_value);
        old_tail->next = p;
        tail.store(p); //存储tail
    }
};
