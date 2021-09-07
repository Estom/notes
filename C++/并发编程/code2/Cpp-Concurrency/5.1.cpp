//
//  5.1.cpp C++中的原子操作和原子类型->std::atomic_flag的相关操作
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用 std::atomic_flag 实现自旋互斥锁
//  最最基本的互斥量，但是已经足够std::mutex_guard 使用了
//  但是 std::atomic_flag 没有非修改查询操作，也不能像普通的布尔标志那样使用
//  所以最好使用std::atomic<bool>
//  虽然他依然不能拷贝构造和拷贝赋值，但是你可以使用一个非原子类型的bool类型构造它

#include <atomic>

class spinlock_mutex {
    std::atomic_flag flag;
public:
    spinlock_mutex(): flag(ATOMIC_FLAG_INIT) {}
    void lock() {
        while (flag.test_and_set(std::memory_order_acquire));
    }
    void unlock() {
        flag.clear(std::memory_order_release);
    }
};
