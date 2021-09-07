//
//  7.10.cpp 无锁数据结构的例子->应用于无锁栈上的内存模型
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  基于引用计数和松散原子操作的无锁栈

#include <atomic>
#include <memory>

template <typename T>
class lock_free_stack {
private:
    struct node;
    struct counted_node_ptr {
        int external_count; // 外部引用计数
        node* ptr;
    };
    struct node {
        std::shared_ptr<T> data;
        std::atomic<int> internal_count; // 内部引用计数
        counted_node_ptr next;
        node(T const& data_) : data(std::make_shared<T>(data_)), internal_count(0) {}
    };
    std::atomic<counted_node_ptr> head; // 特化std::atomic<> 模板来对head进行声明，counted_node_ptr体积够小，能让std::atomic<>无锁->因为平台支持”双字比较和交换“，如果平台不支持，最好还是使用std::shared_ptr
    
    // pop()
    void increase_head_count(counted_node_ptr& old_counter) {
        counted_node_ptr new_counter;
        do {
            new_counter = old_counter;
            ++new_counter.external_count;
        }
        while (!head.compare_exchange_strong(old_counter,
                                             new_counter,
                                             std::memory_order_acquire,
                                             std::memory_order_relaxed)); // 增加外部引用计数，通过增加外部引用计数，保证指针在访问期间的合法性
        old_counter.external_count = new_counter.external_count;
    }
public:
    ~lock_free_stack() {
        while (pop());
    }
    
    void push(T const& data) {
        counted_node_ptr new_node;
        new_node.ptr = new node(data);
        new_node.external_count = 1; // 新节点，只有一个head指针的外部引用
        new_node.ptr->next = head.load(std::memory_order_relaxed);
        while (!head.compare_exchange_weak(new_node.ptr->next,
                                           new_node,
                                           std::memory_order_release,
                                           std::memory_order_relaxed));
    }
    
    // pop()
    std::shared_ptr<T> pop() {
        counted_node_ptr old_head = head.load(std::memory_order_relaxed);
        for (; ;) {
            increase_head_count(old_head); //外部引用计数增加后，才能访问指向的节点
            node* const ptr = old_head.ptr;
            if (!ptr) {
                return std::shared_ptr<T>();
            }
            if (head.compare_exchange_strong(old_head,
                                             ptr->next,
                                             std::memory_order_relaxed)) { // 当指针不为空
                std::shared_ptr<T> res;
                res.swap(ptr->data);
                int const count_increase = old_head.external_count - 2; // 相加的值要-2
                if (ptr->internal_count.fetch_add(count_increase, std::memory_order_release) == -count_increase) { // 使用原子操作fetch_add，将外部计数加到内部计数中去->如果现在引用计数为0，那么之前fetch_add返回的值在相加之前一定是一个负数，这种情况下可以删除节点
                    delete ptr;
                }
                return res; // 无论节点是否删除，都返回获取的数据
            }
            else if (ptr->internal_count.fetch_add(-1, std::memory_order_relaxed) == 1) { // 当比较/交换 失败，说明节点在之前被删除或者添加了一个新节点到栈中->所以要将当前节点上的引用计数-1，因为当前线程已经无法访问这个节点了，如果当前线程是最后一个持有引用，那么内部引用计数将会为1，即可以删除该节点
                ptr->internal_count.load(std::memory_order_acquire);
                delete ptr;
            }
        }
    }
};
