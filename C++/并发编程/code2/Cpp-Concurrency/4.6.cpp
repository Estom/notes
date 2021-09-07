//
//  4.6.cpp 使用期望等待一次性事件->带返回值的后台任务
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用 std::future 从异步任务中获取返回值

#include <future>
#include <iostream>

int find_the_answer_to_ltuae() {
    return 42;
}

void do_other_stuff() {
    
}

int main() {
    std::future<int> the_answer = std::async(find_the_answer_to_ltuae);
    do_other_stuff();
    std::cout << "The answer is " << the_answer.get() << std::endl;
}
