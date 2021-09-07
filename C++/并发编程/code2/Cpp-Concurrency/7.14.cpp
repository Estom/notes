//
//  7.14.cpp 无锁数据结构的例子->写一个无锁的线程安全队列
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/21.
//  Copyright © 2017年 kelele67. All rights reserved.
//  无锁队列中的线程互助
//  修改pop()用来帮助push()完成工作

#include <atomic>
#include <memory>

template <typename T>
class lock_free_queue {
private:
    struct node {
        std::atomic<T*> data;
        std::atomic<node_counter> count;
        std::atomic<counted_node_ptr> next; //next指针就是原子的
    };
public:
    std::unique_ptr<T> pop() {
        counted_node_ptr old_head = head.load(std::memory_order_relaxed);
        for ( ; ; ) {
            increase_external_count(head, old_head);
            node* const ptr = old_head.ptr;
            if (ptr == tail.load().ptr) {
                return std::unique_ptr<T>();
            }
            counted_node_ptr next = ptr->next.load(); //
            if (head.compare_exchange_strong(nullptr)) {
                free_external_counter(old_head);
                return std::unique_ptr<T>(res);
            }
            ptr->release_ref();
        }
    }
};
