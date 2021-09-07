//
//  2.8.cpp 运行时决定线程数量
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//  原生并行版的 std::accumulate

#include <thread>
#include <numeric>
#include <algorithm>
#include <functional>
#include <vector>
#include <iostream>

template<typename Iterator, typename T>
struct accumulate_block {
    void operator()(Iterator first, Iterator last, T& result) {
        result = std::accumulate(first, last, result);
    }
};

template<typename Iterator, typename T>
T parallel_accumulate(Iterator first, Iterator last, T init) {
    unsigned long const length = std::distance(first, last);
    // 如果输入为空
    if (!length) {
        return init;
    }
    
    unsigned long const min_per_thread = 25;
    // 需要用范围内元素的总数量除以线程（块）中最小任务数来确定 启动线程的最大数量
    unsigned long const max_threads = (length + min_per_thread - 1) / min_per_thread;
    unsigned long const hardware_threads = std::thread::hardware_concurrency();
    // 计算得到的最大值和硬件支持的线程数中 取最小值
    // 在这里我们选择了 '2'
    unsigned long const num_threads = std::min(hardware_threads != 0 ? hardware_threads:2, max_threads);
    // 每个线程中处理的元素数量，是范围元素的总量除以线程的个数得到的
    unsigned long const block_size = length / num_threads;
    
    std::vector<T> results(num_threads);
    // 创建线程容器，比之前的少1，因为已经有了一个主线程
    std::vector<std::thread> threads(num_threads - 1);
    
    Iterator block_start = first;
    // 简单的循环来启动线程
    for (unsigned long i = 0; i < (num_threads - 1); ++i) {
        Iterator block_end = block_start;
        // block_end迭代器指向当前块的末尾
        std::advance(block_end, block_size);
        // 并启动一个新线程为当前块累加结果
        threads[i] = std::thread(accumulate_block<Iterator, T>(), block_start,
                                 block_end, std::ref(results[i]));
        // 当迭代器指向当前块的末尾时，启动下一个块
        block_start = block_end;
    }
    // 启动了所有块后，下面的线程会处理最终块的结果
    accumulate_block<Iterator, T>()(block_start, last, results[num_threads-1]);
    
    // 当累加最终块的结果后，等待for_each 创建线程的完成
    std::for_each(threads.begin(), threads.end(), std::mem_fn(&std::thread::join));
    
    // 再使用 std::accumulate 将所有结果进行累加
    return std::accumulate(results.begin(), results.end(), init);
}
