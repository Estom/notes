//
//  7.12.cpp 无锁数据结构的例子->写一个无锁的线程安全队列
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用带有引用计数tail，实现的无锁队列中的push()

#include <atomic>
#include <memory>

template <typename T>
class lock_free_queue {
private:
    struct node;
    struct counted_node_ptr {
        int external_count;
        node* ptr;
    };
    std::atomic<counted_node_ptr> head;
    std::atomic<counted_node_ptr> tail; // tail和head都是atomic类型
    struct node_counter {
        unsigned internal_count: 30; // 30bit 保证计数器总体大小是32bit 内部计数器值就有足够空间来保证这个结构体能放在一个机器字中
        unsigned external_count: 2; // 2bit 因为最多就两个计数器
    };
    struct node {
        std::atomic<T*> data;
        std::atomic<node_counter> count; // internal_count 被替换成 count,包含两个数据成员
        counted_node_ptr next;
        node() {
            node_counter new_count;
            new_count.internal_count = 0;
            new_count.external_count = 2; // 因为当新节点加入队列时，都会被tail和上一个节点的next指针所指向
            count.store(new_count);
            next.ptr = nullptr;
            next.external_count = 0;
        }
    };
public:
    void push(T new_value) {
        std::unique_ptr<T> new_data(new T(new_value));
        counted_node_ptr new_next;
        new_next.ptr = new node;
        new_next.external_count = 1;
        counted_node_ptr old_tail = tail.load();
        for ( ; ; ) {
            increase_external_count(tail, old_tail); // 同样，在调用之前，增加计数器的计数
            T* old_data = nullptr;
            // 和7.11类似，保证值得正确性
            if (old_tail.ptr->data.compare_exchange_strong(old_data, new_data.get())) {
                old_tail.ptr->next = new_next;
                old_tail = tail.exchange(new_next);
                free_external_counter(old_tail); // 再对尾部的旧值调用 free_external_counter
                new_data.release();
                break;
            }
            old_tail.ptr->release_ref();
        }
    }
};
