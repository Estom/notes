//
//  4.16.cpp 使用同步操作简化代码->使用消息传递的同步操作
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  简单ATM实现中的 getting_pin 状态函数
//  ->处理三个不同类型的消息
//  总之就是展示在并发编程中用函数式编程很方便，因为每一个线程都完全被独立对待

void atm::getting_pin() {
    incoming.wait()
    .handle<digit_pressed> ([&](digit_pressed const& msg) {
        unsigned const pin_length = 4;
        pin += msg.digit;
        if (pin.length() == pin_length) {
            bank.send(verify_pin(account, pin, incoming));
            state = &atm::verfying_pin;
        }
    })
    .handle<clear_last_pressed> ([&](clear_last_pressed const& msg) {
        if (!pin.empty()) {
            pin.resize(pin.length() - 1);
        }
    })
    .handle<cancel_pressed> ([&](cancel_pressed const& msg) {
        state = &atm::done_processing;
    });
}
