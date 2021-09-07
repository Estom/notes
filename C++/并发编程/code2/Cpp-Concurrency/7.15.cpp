//
//  7.15.cpp 无锁数据结构的例子->写一个无锁的线程安全队列
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/21.
//  Copyright © 2017年 kelele67. All rights reserved.
//  无锁队列中的线程互助
//  无锁队列中简单的帮助性push()的实现

#include <atomic>
#include <memory>

template <typename T>
class lock_free_queue {
private:
    void set_new_tail(counted_node_ptr &old_tail, // 更新tail指针
                      counted_node_ptr const &new_tail) {
        node* const current_tail_ptr = old_tail.ptr;
        // 使用compare_exchange_weak更新tail
        while (!tail.compare_exchange_weak(old_tail, new_tail) && old_tail.ptr == current_tail_ptr);
        // 当“比较/交换”失败时，先判断新旧ptr是否一样
        if (old_tail.ptr == current_tail_ptr) {
            free_external_counter(old_tail); // 相同时，表示对tail的设置已经完成，释放旧外部计数器
        }
        else {
            current_tail_ptr->release_ref(); // 不同时，可能另一线程已经释放了ptr，只需要将这次引用进行释放即可
        }
    }
public:
    void push(T new_value) {
        std::unique_ptr<T> new_data(new T(new_value));
        counted_node_ptr new_next;
        new_next.ptr new_next;
        new_next.ptr = new node;
        new_next.external_count = 1;
        counted_node_ptr old_tail = tail.load();
        for ( ; ; ) {
            increase_external_count(tail, old_tail);
            T* old_data = nullptr;
            // 对节点的data设置时
            if (old_tail.ptr->data.compare_exchange_strong(old_data, new_data.get())) {
                counted_node_ptr old_next = {0};
                // 使用 compare_exchange_strong()来避免循环
                if (!old_tail.ptr->next.compare_exchange_strong(old_next, new_next)) {
                    delete new_next.ptr; // 当交换失败，删除一开始分配的节点
                    new_next = old_next; // 并且重新分配节点
                }
                set_new_tail(old_tail, new_next);
                new_data.release();
                break;
            }
            // 未能在循环阶段对data指针进行设置时，帮助成功的线程完成更新
            else {
                counted_node_ptr old_next = {0};
                // 尝试更新next指针，让其指向该线程分配的新节点
                if (old_tail.ptr->next.compare_exchange_strong(old_next, new_next)) {
                    old_next = new_next; //新节点作为新的tail节点
                    new_next.ptr = new node; // 分配另一个新节点，用来管理队列中新推送的数据项
                }
                set_new_tail(old_tail, old_next); // 设置tail节点
            }
        }
    }
};
