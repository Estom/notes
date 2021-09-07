//
//  6.2.cpp 基于锁的并发数据结构->线程安全队列一一使用锁和条件变量
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  对4.5中线程安全队列的进一步分析

#include <mutex>
#include <condition_variable>
#include <queue>
#include <memory>

template <typename T>
class threadsafe_queue {
private:
    mutable std::mutex mut;
    std::queue<T> data_queue;
    std::condition_variable data_cond;
public:
    threadsafe_queue() {}
    threadsafe_queue(threadsafe_queue const& other) {
        std::lock_guard<std::mutex> lk(other.mut);
        data_queue = other.data_queue;
    }
    
    void push(T new_value) {
        std::lock_guard<std::mutex> lk(mut);
        data_queue.push(new_value);
        data_cond.notify_one();
    }
    
    void wait_and_pop(T& value) {
        std::unique_lock<std::mutex> lk(mut);
        data_cond.wait(lk, [this] { return !data_queue.empty(); } );
        value = data_queue.front();
        data_queue.pop();
    }
    
    /* 如果在构造新的 std::shared_ptr<>对象时抛出异常，那么其他线程都会永久休眠 */
    /* 1. 除非我们调用 data_cond.notify_all() 但是又会浪费很多资源让线程重新进入睡眠 */
    /* 2. 当有异常抛出时，让wait_and_pop() 调用 data_cond.notify_one() 从而让另一个线程去尝试索引存储的值 */
    /* 3. 将 std::shared_ptr<>的初始化转移到push()中，并且存储 std::shared_ptr<>实例，而非直接使用数据的值 */
    std::shared_ptr<T> wait_and_pop() {
        std::unique_lock<std::mutex> lk(mut);
        data_cond.wait(lk, [this] { return !data_queue.empty(); } );
        std::shared_ptr<T> res(std::make_shared<T>(data_queue.front()));
        data_queue.pop();
        return res;
    }
    
    bool try_pop(T& value) {
        std::lock_guard<std::mutex> lk(mut);
        if (data_queue.empty())
            return false;
        value = data_queue.front();
        data_queue.pop();
    }
    
    std::shared_ptr<T> try_pop() {
        std::unique_lock<std::mutex> lk(mut);
        if (data_queue.empty())
            return std::shared_ptr<T>();
        std::shared_ptr<T> res(std::make_shared<T>(data_queue.front()));
        data_queue.pop();
        return res;
    }
    
    bool empty() const {
        std::lock_guard<std::mutex> lk(mut);
        return data_queue.empty();
    }
};

int main() {
}
