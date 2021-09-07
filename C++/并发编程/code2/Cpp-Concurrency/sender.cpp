//
//  sender.cpp 消息传递框架与完整的ATM机示例
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/25.
//  Copyright © 2017年 kelele67. All rights reserved.
//  sender类

namespace messaging {
    class sender {
        queue *q; // sender是一个队列指针的包装类
    public:
        // 默认构造函数中sender没有队列
        sender() : q(nullptr) {}
        // 从指向队列的指针进行构造
        explicit sender(queue* q_) : q(q_) {}
        template <typename Message>
        void send(Message const& msg) {
            if (q) {
                q->push(msg); // 将发送信息推送给队列
            }
        }
    };
}

