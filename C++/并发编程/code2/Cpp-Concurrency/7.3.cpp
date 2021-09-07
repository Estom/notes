//
//  7.3.cpp 无锁数据结构的例子->停止内存泄漏：使用无锁数据结构管理内存
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  没有线程通过pop()访问节点时，就对节点进行回收

#include <atomic>
#include <memory>

template <typename T>
class lock_free_stack {
private:
    std::atomic<unsigned> threads_in_pop; // 原子变量
    void try_reclaim(node* old_head);
public:
    std::shared_ptr<T> pop() {
        ++threads_in_pop; // 计数值+1
        node* old_head = head.load();
        while (old_head && !head.compare_exchange_weak(old_head, old_head->next));
        std::shared_ptr<T> res;
        if (old_head) {
            res.swap(old_head->data); // 删除的节点上的数据，数据不用时，会自动删除
        }
        try_reclaim(old_head); // 从节点中直接提取数据，而非拷贝指针，当这个函数调用时，说明节点被删除，同时技术值-1
        return res;
    }
};
