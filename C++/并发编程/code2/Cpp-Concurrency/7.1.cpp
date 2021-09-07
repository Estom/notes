//
//  7.1.cpp 无锁数据结构的例子->写一个无锁的线程安全栈
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  链表栈
//  添加一个节点
//  1.创建一个新节点
//  2.将当前节点的next指针指向当前head的节点
//  3.让head指针指向新节点
//  应对其中的竞争条件->在第三步的时候使用一个原子“比较/交换”操作，来保证在2读取head时，不会对head进行修改
//  不用锁实现栈的push()

#include <atomic>

template <typename T>
class lock_free_stack {
private:
    struct node {
        T data;
        node* next;
        node(T const& data_): data(data_) {}
    };
    std::atomic<node*> head;
public:
    void push(T const& data) {
        node* const new_node = new node(data); // 1.创建一个新节点
        new_node->next = head.load(); // 2.将当前节点的next指针指向当前head的节点
        
        // compare_exchange_weak->相同，返回false，说明更新了栈顶；不同，则交换两个值，则让head指针指向了新节点
        // compare_exchange_weak如果失败，则栈顶被更新了，这个时候更新的新栈顶会被更新到new_node->next，因此循环可以再次尝试压栈而无需手动更新new_node->next
        // ->保证在步骤3的时候栈顶和步骤2中获得的栈顶相同，如果不同，就自旋->重新获取栈顶
        while (!head.compare_exchange_weak(new_node->next, new_node)); // 3.让head指针指向新节点
    }
};
