//
//  1.1.cpp 你好，并发世界
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//  

#include <iostream>
#include <thread>

void hello() {
    std::cout << "Hello Concurrent World\n";
}

int main() {
    std::thread t(hello);
    t.join();
}
