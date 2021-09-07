//
//  3.9.cpp std::unique_lock 灵活的锁
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  交换操作中使用 std::lock() 和 std::unique_lock

#include <mutex>

class some_big_object {
    
};

void swap(some_big_object& lhs, some_big_object& rhs) {
    
}

class X {
private:
    some_big_object some_detail;
    mutable std::mutex m;
public:
    X(some_big_object const& sd): some_detail(sd) {}
    
    friend void swap(X& lhs, X&rhs) {
        if (&lhs == &rhs)
            return;
        std::unique_lock<std::mutex> lock_a(lhs.m, std::defer_lock); // defer_lock 留下未上锁的互斥量
        std::unique_lock<std::mutex> lock_b(rhs.m, std::defer_lock);
        std::lock(lock_a, lock_b);  // 互斥量在这里上锁
        swap(lhs.some_detail, rhs.some_detail);
    }
};

int main() {
    
}
