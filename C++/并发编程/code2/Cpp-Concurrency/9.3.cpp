//
//  9.3.cpp 高级线程管理->线程池
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/24.
//  Copyright © 2017年 kelele67. All rights reserved.
//  parallel_accumulate 使用一个可等待任务的线程池

#include <vector>
#include <future>

template <typename Iterator, typename T>
T parallel_accumulate(Iterator first, Iterator last, T init) {
    unsigned long const length = std::distance(first, last);
    
    if (!length) {
        return init;
    }
    
    unsigned long const block_size = 25;
    unsigned long const num_blocks = (length + block_size - 1) / block_size;
    
    std::vector<std::future<T> > futures(num_blocks-1);
    thread_pool pool;
    
    Iterator block_start = first;
    for (unsigned long i = 0; i < (num_threads - 1); ++i) {
        Iterator block_end = block_start;
        std::advance(block_end, block_size);
        futures[1] = pool.submit(accumulate_block<Iterator, T>());
        block_start = block_end;
    }
    T last_result = accumulate_block()(block_start, last);
    T result = init;
    for (unsigned long i = 0; i < (num_blocks-1); ++i) {
        result += futures[i].get;
    }
    result += last_result;
    return result;
}
