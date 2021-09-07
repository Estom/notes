//
//  4.15.cpp 使用同步操作简化代码->使用消息传递的同步操作
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  ATM逻辑类的简单实现

#include <string>

struct card_inserted {
    std::string account;
};

class atm {
    messaging::receiver incoming;
    messaging::sender bank;
    messaging::sender inerface_hardware;
    void (atm::*state);
    std::string account;
    std::string pin;
    // 发送一条信息到接口
    void waiting_for_card() {
        // 让终端显示“等待卡片”的信息
        inerface_hardware.send(display_enter_card());
        // 传入一条消息进行处理
        incoming.wait().handle<card_inserted> ([&](card_inserted const& msg) { // 用lambda处理消息
            account = msg.account; //  将用户的账号信息缓存到一个成员变量中
            pin = ""; // 并且清除pin信息
            inerface_hardware.send(display_enter_pin()); // 再发送一条消息到硬件接口，让显示界面提示用户输入PIN
            state = &atm::getting_pin; // 然后将线程状态改成->获取pin
        });
    }
    void getting_pin();
public:
    void run() {
        // 初始化atm状态
        state = &atm::waiting_for_card;
        try {
            for (; ;) {
                // 反复执行当前状态的成员函数
                (this->*state)();
            }
        }
        catch(messaging::close_queue const&) {
            
        }
    }
};
