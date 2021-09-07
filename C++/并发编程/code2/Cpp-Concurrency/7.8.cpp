//
//  7.8.cpp 无锁数据结构的例子->检测使用引用计数的节点
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  想要删除节点还能被其他读者线程访问->内置引用计数的指针 std::shared_ptr<>，但是不能保证无锁
//  无锁栈一一使用无锁 std::shared_ptr<> 的实现

#include <atomic>
#include <memory>

template <typename T>
class lock_free_stack {
private:
    struct node {
        std::shared_ptr<T> data;
        std::shared_ptr<node> next;
        node(T const& data_) : data(std::make_shared<T>(data_)) {}
    };
    std::shared_ptr<node> head;
public:
    void push(T const& data) {
        std::shared_ptr<node> const new_node = std::make_shared<node>(data);
        new_node->next = head.load();
        while (!std::atomic_compare_exchange_weak(&head, &new_node->next, new_node));
    }
    
    std::shared_ptr<T> pop() {
        std::shared_ptr<node> old_head = std::atomic_load(&head);
        while (old_head && !std::atomic_compare_exchange_weak(&head, &old_head, old_head->next));
        return old_head ? old_head->data : std::shared_ptr<T>();
    }
};
