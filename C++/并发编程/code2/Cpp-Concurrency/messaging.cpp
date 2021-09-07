//
//  messaging.cpp 消息传递框架与完整的ATM机示例
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/25.
//  Copyright © 2017年 kelele67. All rights reserved.
//  简单的消息队列框架

#include <mutex>
#include <condition_variable>
#include <queue>
#include <memory>

namespace messaging {
    // 队列的基础类
    struct message_base {
        virtual ~message_base() {}
    };
    
    template <typename Msg>
    // 每个消息类型都需要特化
    struct wrapped_message: message_base {
        Msg contents;
        explicit wrapped_message(Msg const& contents_) : contents(contents_) {}
    };
    
    // 我们的队列
    class queue {
        std::mutex mut;
        std::condition_variable cond;
        std::queue<std::shared_ptr<message_base> > msgq; // 实际存储指向 message_base类指针的队列
    public:
        template <typename T>
        void push(T const& msg) {
            std::lock_guard<std::mutex> lk(mut);
            msgq.push(std::make_shared<wrapped_message<T> >(msg)); // 包装已传递的信息，存储指针
            cond.notify_all();
        }
        std::shared_ptr<message_base> wait_and_pop() {
            std::unique_lock<std::mutex> lk(mut);
            cond.wait(lk, [&] { return !msgq.empty(); });
            auto res = msgq.front();
            msgq.pop();
            return res;
        }
    };
}
