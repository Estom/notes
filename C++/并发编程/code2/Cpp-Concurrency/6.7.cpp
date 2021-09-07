//
//  6.7.cpp 基于锁的并发数据结构->线程安全队列一一使用细粒度锁和条件变量
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  可上锁和等待的线程安全队列一一内部结构及接口
//  可上锁和等待的线程安全队列一一推入新节点
//  可上锁和等待的线程安全队列一一wait_and_pop()
//  可上锁和等待的线程安全队列一一try_pop()和empty()

#include <memory>
#include <mutex>
#include <condition_variable>

//  可上锁和等待的线程安全队列一一内部结构及接口
template <typename T>
class threadsafe_queue {
private:
    struct node {
        std::shared_ptr<T> data;
        std::unique_ptr<node> next;
    };
    
    std::mutex head_mutex;
    std::unique_ptr<node> head;
    std::mutex tail_mutex;
    node* tail;
    std::condition_variable data_cond;
    
    //  可上锁和等待的线程安全队列一一wait_and_pop()
    node* get_tail() {
        std::lock_guard<std::mutex> tail_lock(tail_mutex);
        return tail;
    }
    
    std::unique_ptr<node> pop_head() {
        std::unique_ptr<node> const old_head = std::move(head);
        head = std::move(old_head->next);
        return old_head;
    }
    
    std::unique_lock<std::mutex> wait_for_data() {
        std::unique_lock<std::mutex> head_lock(head_mutex);
        data_cond.wait(head_lock, [&] {return head != get_tail(); });
        return std::move(head_lock);
    }
    
    std::unique_ptr<node> wait_pop_head() {
        std::unique_lock<std::mutex> head_lock(head_mutex);
        return pop_head();
    }
    
    std::unique_ptr<node> wait_pop_head(T& value) {
        std::unique_lock<std::mutex> head_lock(wait_for_data());
        value = std::move(*head->data);
        return pop_head();
    }
    
    //  可上锁和等待的线程安全队列一一try_pop()和empty()
    std::unique_ptr<node> try_pop_head() {
        std::lock_guard<std::mutex> head_lock(head_mutex);
        if (head.get() == get_tail()) {
            return std::unique_ptr<node>();
        }
        return pop_head();
    }
    
    std::unique_ptr<node> try_pop_head(T& value) {
        std::lock_guard<std::mutex> head_lock(head_mutex);
        if (head.get() == get_tail()) {
            return std::unique_ptr<node>();
        }
        value = std::move(*head->data);
        return pop_head();
    }
    
public:
    threadsafe_queue() : head(new node), tail (head.get()) {}
    threadsafe_queue(const threadsafe_queue& other) = delete;
    threadsafe_queue& operator=(const threadsafe_queue& other) = delete;
    
    // std::shared_ptr<T> try_pop();
    // bool try_pop(T& value);
    // std::shared_ptr<T> wait_and_pop();
    // void wait_and_pop(T& value);
    void push(T new_value);
    // void empty();
    
    //  可上锁和等待的线程安全队列一一wait_and_pop()
    std::shared_ptr<T> wait_and_pop() {
        std::unique_ptr<node> const old_head = wait_pop_head();
        return old_head->data;
    }
    
    void wait_and_pop(T& value) {
        std::unique_ptr<node> const old_head = wait_pop_head(value);
    }
    
    //  可上锁和等待的线程安全队列一一try_pop()和empty()
    std::shared_ptr<T> try_pop() {
        std::unique_ptr<node> const old_head = try_pop_head();
        return old_head ? old_head->data : std::shared_ptr<T>();
    }
    
    bool try_pop(T& value) {
        std::unique_ptr<node> const old_head = try_pop_head(value);
        return old_head;
    }
    
    void empty() {
        std::lock_guard<std::mutex> head_lock(head_mutex);
        return (head == get_tail());
    }
};

//  可上锁和等待的线程安全队列一一推入新节点
template <typename T>
void threadsafe_queue<T>::push(T new_value) {
    std::shared_ptr<T> new_data(std::make_shared<T>(std::move(new_value)));
    std::unique_ptr<node> p(new node);
    {
        std::lock_guard<std::mutex> tail_lock(tail_mutex);
        tail->data = new_value;
        node* const new_tail = p.get();
        tail->next = std::move(p);
        tail = new_tail;
    }
    data_cond.notify_one();
}

