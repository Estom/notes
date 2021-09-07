//
//  4.7.cpp 使用期望等待一次性事件->带返回值的后台任务
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用 std::async 向函数传递参数

#include <string>
#include <future>

struct X {
    void foo(int, std::string const&);
    std::string bar(std::string const&);
};

X x;
auto f1 = std::async(&X::foo, &x, 42, "hello"); // 调用 p->foo(42, "hello"), p 是指向 x 的指针
auto f2 = std::async(&X::bar, x, "goodbye"); // 调用tmpx.bar("goodbye"), tmpx 是 x 的拷贝副本

struct Y {
    double operator()(double);
};

Y y;
auto f3 = std::async(Y(), 3.141); // 调用tmpy(3.141), tmpy通过移动 Y 的移动构造函数得到
auto f4 = std::async(std::ref(y), 2.718); // 调用y(2.718)

X baz(X&);
auto f6 = std::async(baz, std::ref(x)); // 调用baz(x)

class move_only {
public:
    move_only();
    move_only(move_only&&);
    move_only(move_only const&) = delete;
    move_only& operator=(move_only&&);
    move_only& operator=(move_only const&) = delete;
    void operator()();
};

auto f5 = std::async(move_only()); // 调用tmp(), tmp是通过 std::move(move_only()) 构造得到
auto f7 = std::async(std::launch::async, Y(), 1.2); // 在新线程上执行
auto f8 = std::async(std::launch::deferred, baz, std::ref(x)); // 在wait() 或 get()调用时执行
auto f9 = std::async(std::launch::deferred | std::launch::async, baz, std::ref(x)); // 实现选择执行方式

auto f10 = std::async(baz, std::ref(x));
// f8.wait(); // 调用延迟函数
