//
//  4.13.cpp 使用同步操作简化代码->使用“期望”的函数式编程
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  快速排序一一“期望”并行版

#include <list>
#include <future>

template <typename T>
std::list<T> parallel_quick_sort(std::list<T> input) {
    if (input.empty())
        return input;
    
    std::list<T> result;
    result.splice(result.begin(), input, input.begin());
    T const& pivot = *result.begin();
    auto divide_point = std::partition(input.begin(), input.end(), [&] (T const& t) { return t < pivot; });
    std::list<T> lower_part;
    lower_part.splice(lower_part.end(), input, input.begin(), divide_point);
    // 不对小于中间值的部分排序，使用std::async在另一线程对其进行排序
    std::future<std::list<T> > new_lower(std::async(&parallel_quick_sort<T>, std::move(lower_part)));
    // 大于部分如同之前一样，使用递归排序，递归两次，4个线程；三次，8个线程...
    auto new_higher(parallel_quick_sort(std::move(input)));
    result.splice(result.end(), new_higher);
    result.splice(result.begin(), new_higher.get());
    return result;
}
