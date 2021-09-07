
//
//  7.4.cpp 无锁数据结构的例子->停止内存泄漏：使用无锁数据结构管理内存
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  采用引用计数的回收机制try_reclaim()的实现
//  高负荷情况下，不会存在静态，to_be_deleted链表将会无界的增加，并且会再次泄露

#include <atomic>

template <typename T>
class lock_free_stack {
private:
    std::atomic<node*> to_be_deleted;
    static void delete_nodes(node* nodes) {
        while (nodes) {
            node* next = nodes->next;
            delete nodes;
            nodes = next;
        }
    }
    void try_reclaim(node* old_head) {
        if (threads_in_pop == 1) { // 回收节点时，引用计数是1
            node* nodes_to_delete = to_be_deleted.exchange(nullptr); // 声明可删除列表
            if (!--threads_in_pop) { // 是否只有一个线程调用pop()
                delete_nodes(nodes_to_delete); // 只有一个线程时，迭代链表删除待节点
            }
            else if (nodes_to_delete) { // 让引用计数-1后不为0
                chain_peding_nodes(nodes_to_delete); // 挂在待删除列表
            }
            delete old_head; // 删除节点
        }
        else {
            chain_pending_node(old_head); // 引用计数不为1时，继续向等待列表添加节点
            --threads_in_pop;
        }
    }
    
    void chain_pending_node(node* nodes) {
        node* last = nodes;
        while (node* const next = last->next) { // 让next指针指向链表末尾
            last = next;
        }
        chain_pending_node(nodes, last);
    }
    
    void chain_pending_node(node* first, node* last) {
        last->next = to_be_deleted; //
        // 用循环来保证last->next的正确性
        while (!to_be_deleted.compare_exchange_weak(last->next, first));
    }
    
    void chain_pending_node(node* n) {
        chain_pending_node(n, n); //
    }
};
