//
//  6.10.cpp 基于锁设计更加复杂的数据结构->编写一个使用锁的线程安全链表
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  如果提供迭代器的支持
//  STL类的迭代器需要持有容器内部属于的引用，当容器可被其他线程修改时，有时这个引用还是有效的
//  实际上，这里就需要迭代器持有锁->对指定的结构中的部分进行上锁，
//  然而，在STL类迭代器的生命周期类，让其完全脱离容器的控制是很糟糕的->
//  所以我们提供迭代函数->将for_each作为容器本身的一部分
//  实现功能：
//  1. 向列表添加一个元素
//  2. 当某个条件满足时，就从链表里面删除某个元素
//  3. 当某个条件满足时，从链表中查找某个元素
//  4. 当某个条件满足时，更新链表中的某个元素
//  5. 将当前容器中链表中的每个元素，复制到另一个容器中
//  待实现：在指定位置插入元素
//  使用细粒度锁->每个节点都拥有一个互斥量：对持有的节点群进行上锁，并且在移动到下一个节点时，对当前节点释放
//  线程安全链表一一支持迭代器

#include <memory>
#include <mutex>

template <typename T>
class threadsafe_list {
    struct node {
        std::mutex m;
        std::shared_ptr<T> data;
        std::unique_ptr<node> next;
        
        // next指向NULL
        node(): next() {}
        // 在堆上分配内存
        node(T const& value): data(std::make_shared<T>(value)) {}
    };
    
    node head;
    
public:
    threadsafe_list() {}
    ~threadsafe_list() {
        remove_if([](T const&) { return true; });
    }
    
    threadsafe_list(threadsafe_list const& other) = delete;
    threadsafe_list& operator=(threadsafe_list const& other) = delete;
    
    void push_front(T const& value) {
        std::unique_ptr<node> new_node(new node(value)); // 构造第一个新节点
        std::lock_guard<std::mutex> lk(head.m);
        new_node->next = std::move(head.next); //插入节点到链表头部
        head.next = std::move(new_node); //让头节点的next指向这个节点
    }
    
    template <typename Function>
    // 对链表中每个元素执行Function->函数指针
    void for_each(Function f) {
        node* current = &head;
        std::unique_lock<std::mutex> lk(head.m); // 锁住head节点的互斥量
        while (node* const next = current->next.get()) { //安全的get()获取下一个节点，直到指针为空时
            std::unique_lock<std::mutex> next_lk(next->m); // 对指向的节点上锁
            lk.unlock(); // 释放上一个锁住的节点
            f(*next->data); // 调用指定函数
            current = next; // 更新当前节点
            lk = std::move(next_lk); // 将所有权从next_lk移动到lk
        }
    }
    
    template <typename Predicate>
    std::shared_ptr<T> find_first_if(Predicate p) {
        node* current = &head;
        std::unique_lock<std::mutex> lk(head.m);
        while (node* const next = current->next.get()) {
            std::unique_lock<std::mutex> next_lk(next->m);
            lk.unlock();
            if (p(*next->data)) {
                return next->data; // 找到就返回，也可以用for_each()实现
            }
            current = next;
            lk = std::move(next_lk);
        }
        return std::shared_ptr<T>();
    }
    
    template <typename Predicate>
    void remove_if(Predicate p) {
        node* current = &head;
        std::unique_lock<std::mutex> lk(head.m);
        while (node* const next = current->next.get()) {
            std::unique_lock<std::mutex> next_lk(next->m);
            if (p(*next->data)) {
                std::unique_ptr<node> old_next = std::move(current->next);
                current->next = std::move(next->next);
                next_lk.unlock();
            } // 当std::unique_ptr<node>的移动超出链表范围，这个节点将被删除
            else {
                lk.unlock();
                current = next;
                lk = std::move(next_lk);
            }
        }
    }
};
