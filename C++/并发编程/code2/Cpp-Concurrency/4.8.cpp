//
//  4.8.cpp 使用期望等待一次性事件->任务与期望
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  std::packaged_task<> 的特化一一局部类定义

#include <future>
#include <vector>

template<>
class std::packaged_task<std::string(std::vector<char>*, int)> {
public:
    template <typename Callable>
    explicit packaged_task(Callable&& f);
    std::future<std::string> get_future();
    void operator()(std::vector<char>*, int);
};
