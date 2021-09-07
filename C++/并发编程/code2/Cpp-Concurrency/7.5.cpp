//
//  7.5.cpp 无锁数据结构的例子->检测使用风险指针（不可回收）的节点
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用风险指针实现的pop()

#include <atomic>
#include <memory>

std::shared_ptr<T> pop() {
    std::atomic<void*>& hp = get_hazard_poiner_for_current_thread();
    node* old_head = head.load();
    do {
        node* temp;
        do { // 知道将风险指针设为head指针
            temp = old_head;
            hp.store(old_head);
            old_head = head.load();
        } while (old_head != temp);
    }
    while (old_head && !head.compare_exchange_string(old_head, old_head->next));
    hp.store(nullptr); // 当声明完成时，清除风险指针
    std::shared_ptr<T> res;
    if (old_head) {
        res.swap(old_head->data);
        // 在删除之前对风险指针引用的节点进行检查
        if (outstanding_hazard_pointers_for(old_head)) {
            reclaim_later(old_head); // 回收节点
        }
        else {
            delete old_head;
        }
        delete_nodes_with_no_hazards(); // 链表上没有任何风险指针引用节点时，安全删除
    }
    return res;
}
