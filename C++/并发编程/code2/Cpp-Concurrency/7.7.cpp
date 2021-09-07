//
//  7.7.cpp 无锁数据结构的例子->检测使用风险指针（不可回收）的节点
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  回收函数的简单实现
//  reclaim_later 只是将节点添加到列表中
//  delete_nodes_with_no_hazards 就是搜索整个列表，并将无风险指针的记录进行删除

#include <atomic>
#include <functional>

template <typename T>
void do_delete(void* p) {
    delete static_cast<T*>(p);
}
struct data_to_reclaim {
    void* data;
    std::function<void(void*)> deleter;
    data_to_reclaim* next;
    template <typename T>
    data_to_reclaim(T* p) : data(p), deleter(&do_delete<T>), next(0) {}
    ~data_to_reclaim() {
        deleter(data);
    }
};

std::atomic<data_to_reclaim*> nodes_to_reclaim;
void add_to_reclaim_list(data_to_reclaim* node) {
    node->next = nodes_to_reclaim.load();
    // 访问链表头
    while (!nodes_to_reclaim.compare_exchange_weak(node->next, node));
}

template <typename T>
void reclaim_later(T* data) { // 是一个函数模板，为指针创建一个data_to_reclaim实例
    add_to_reclaim_list(new data_to_reclaim(data)); // 添加data_to_reclaim实例到回收链表
}

void delete_nodes_with_no_hazards() {
    data_to_reclaim* current = nodes_to_reclaim.exchange(nullptr); // 回收已声明的链表节点
    while (current) {
        data_to_reclaim* const next = current->next;
        if (!outstanding_hazard_pointers_for(current->data)) {
            delete current;
        }
        else {
            add_to_reclaim_list(current);
        }
        current = next;
    }
}
