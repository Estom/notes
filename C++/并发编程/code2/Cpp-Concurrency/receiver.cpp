//
//  receiver.cpp 消息传递框架与完整的ATM机示例
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/25.
//  Copyright © 2017年 kelele67. All rights reserved.
//  receiver类

namespace messaging {
    class receiver {
        queue q; // 接受者拥有对应队列
    public:
        operator sender() { // 允许将类中队列隐式转化为一个sender队列
            return sender(&q);
        }
        dispatcher wait() { // 等待对队列进行调度
            return dispatcher(&q);
        }
    };
}

