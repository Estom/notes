//
//  7.13.cpp 无锁数据结构的例子->写一个无锁的线程安全队列
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/21.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用带有引用计数tail，实现的无锁队列中的pop()

#include <atomic>
#include <memory>

template <typename T>
class lock_free_queue {
private:
    struct node {
        // 1. 在无锁队列中释放一个节点引用，对7.10中 lock_free_stack::pop() 修改得到
        void release_ref() {
            node_counter old_counter = count.load(std::memory_order_relaxed);
            node_counter new_counter;
            do {
                new_counter = old_counter;
                --new_counter.internal_count; // 想要修改internal_count
            }
            // -> 需要一个“比较/交换”循环
            while (!count.compare_exchange_strong(old_counter,
                                                  new_counter,
                                                  std::memory_order_acquire,
                                                  std::memory_order_relaxed));
            if (!new_counter.internal_count && !new_counter.external_counters) {
                delete this; // 内外部计数都为0时，代表是最后一次引用
            }
        }
    };
    
    // 2. 从无锁队列中获取一个节点的引用
    static void increase_external_count(std::atomic<counted_node_ptr>& counter,
                                        counted_node_ptr& old_counter) {
        counted_node_ptr new_counter;
        do {
            new_counter = old_counter;
            ++new_counter.external_count;
        }
        while (!counter.compare_exchange_strong(old_counter,
                                                new_counter,
                                                std::memory_order_acquire,
                                                std::memory_order_relaxed));
        old_counter.external_count = new_counter.external_count;
    }
    
    // 3. 无锁队列中释放节点外部计数器
    static void free_external_counter(counted_node_ptr &old_node_ptr) {
        node* const ptr = old_node_ptr.ptr;
        int const count_increase = old_node_ptr.external_count - 2;
        node_counter old_counter = ptr->count.load(std::memory_order_relaxed);
        node_counter new_counter;
        do {
            new_counter = old_counter;
            --new_counter.external_counters;
            new_counter.internal_count += count_increase;
        }
        while (!ptr->count.compare_exchange_strong(old_counter,
                                                   new_counter,
                                                   std::memory_order_acquire,
                                                   std::memory_order_relaxed));
        if (!new_counter.internal_count && !new_counter.external_counters) {
            delete ptr;
        }
    }
public:
    std::unique_ptr<T> pop() {
        counted_node_ptr old_head = head.load(std::memory_order_relaxed); // 加载old_head值作为启动
        for ( ; ; ) {
            increase_external_count(head, old_head);
            node* const ptr = old_head.ptr;
            if (ptr == tail.load().ptr) {
                ptr->release_ref(); // 当head与tail节点相同时，就能对引用进行释放
                return std::unique_ptr<T>(); // 队列中已经没有数据，所以返回的是空指针
            }
            //  如果队列中还有数据
            if (head.compare_exchange_strong(old_head, ptr->next)) {
                T* const res = ptr->data.exchange(nullptr);
                free_external_counter(old_head); // pop出节点后释放外部计数
                return std::unique_ptr<T>(res);
            }
            ptr->release_ref(); // 让外部计数或者指针有变化时，需要将引用释放后，再次循环
        }
    }
};


