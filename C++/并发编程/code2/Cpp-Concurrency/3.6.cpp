//
//  3.6.cpp 死锁：问题描述及解决方案
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  交换操作中使用 std::lock() 和 std::lock_guard

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
    X(some_big_object const& sd):some_detail(sd) {}
    
    friend void swap(X& lhs, X& rhs) {
        if (&lhs == &rhs) {
            return;
        }
        
        std::lock(lhs.m, rhs.m);    // 锁住两个互斥量 虽然可以避免死锁，但是没发帮助你获取其中一个锁
        std::lock_guard<std::mutex> lock_a(lhs.m, std::adopt_lock); // std::adopt_lcok表示除了 std::lock_guard的对象上锁以外，还表示现成的锁，而非尝试创建新的锁
        std::lock_guard<std::mutex> lock_b(rhs.m, std::adopt_lock);
        swap(lhs.some_detail, rhs.some_detail);
    }
};

int main() {
    
}
