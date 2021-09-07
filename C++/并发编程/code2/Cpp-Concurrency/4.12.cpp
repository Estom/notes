//
//  4.12.cpp 使用同步操作简化代码->使用“期望”的函数式编程
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  快速排序一一顺序实现版

#include <list>
#include <future>

template <typename T>
std::list<T> sequential_quick_sort(std::list<T> input) {
    if (input.empty())
        return input;
    
    std::list<T> result;
    // 使用splice 将输入的首个元素（轴值）放入结果列表中
    result.splice(result.begin(), input, input.begin());
    // 使用引用，避免过多的拷贝
    T const& pivot = *result.begin();
    // 使用std::partition 将序列中的值分成大于轴值和小于轴值的两部分，同样使用引用
    auto divide_point = std::partition(input.begin(), input.end(), [&] (T const& t) { return t < pivot; });
    std::list<T> lower_part;
    // 把小于的部分移动到表lower_part，其他的继续留在input
    lower_part.splice(lower_part.end(), input, input.begin(), divide_point);
    //递归调用对两部分进行排序
    auto new_lower(sequential_quick_sort(std::move(lower_part)));
    auto new_higher(sequential_quick_sort(std::move(input)));
    //再次使用splice()以正确的顺序拼接
    result.splice(result.end(), new_higher);
    result.splice(result.begin(), new_higher.get());
    return result;
}

