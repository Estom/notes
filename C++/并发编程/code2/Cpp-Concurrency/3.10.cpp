//
//  3.10.cpp 锁的粒度
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  比较操作符中一次锁住一个互斥量

#include <mutex>

class Y {
private:
    int some_detail;
    mutable std::mutex m;
    int get_detail() const {
        std::lock_guard<std::mutex> lock_a(m); // 被锁保护
        return some_detail;
    }
public:
    Y(int sd) : some_detail(sd) {}
    friend bool operator==(Y const& lhs, Y const& rhs) {
        if (&lhs == &rhs)
            return true;
        int const lhs_value = lhs.get_detail();
        int const rhs_value = rhs.get_detail();
        return lhs_value == rhs_value; // 之后比较
    }
};
