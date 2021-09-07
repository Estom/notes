//
//  7.2.cpp 无锁数据结构的例子->写一个无锁的线程安全栈
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  删除一个节点
//  1.读取当前head指针的值
//  2.读取head->next
//  3.设置head到head->next
//  4.通过索引node,返回data数据
//  5.删除索引节点
//  多线程情况->读取到了同一个head->一个到步骤5，另一个到步骤2，步骤2的线程会解引用一个空指针
//  所以我们现在只能跳过节点5，让节点泄漏
//  多线程情况->两个线程读取到同一个head，返回同一个节点
//  带有节点泄漏的无锁栈

#include <atomic>
#include <memory>

template <typename T>
class lock_free_stack {
private:
    struct node {
        std::shared_ptr<T> data;
        node* next;
        node(T const& data_): data(std::shared_ptr<T>(data_)) {}
    };
    std::atomic<node*> head;
public:
    void push(T const& data) {
        node* const new_node = new node(data);
        new_node->next = head.load();
        while (!head.compare_exchange_weak(new_node->next, new_node));
    }
    
    std::shared_ptr<T> pop() {
        node* old_head = head.load();
        while (old_head && // 在解引用前检查是否为空指针
               !head.compare_exchange_weak(old_head, old_head->next));
        return old_head ? old_head->data : std::shared_ptr<T>();
    }
};
