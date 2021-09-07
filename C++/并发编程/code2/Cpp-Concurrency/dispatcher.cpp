//
//  dispatcher.cpp 消息传递框架与完整的ATM机示例
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/25.
//  Copyright © 2017年 kelele67. All rights reserved.
//  dispatcher类

#include <queue>
#include <memory>
namespace messaging {
    // 用于关闭队列的消息
    class dispatcher {
        queue* q;
        bool chained;
        
        dispatcher(dispatcher const&) = delete; // dispatcher实例不能被拷贝
        dispatcher& operator=(dispatcher const&) = delete;
        
        template<typename Dispatcher, typename Msg, typename Func> // 允许TemlateDispatcher实例访问内部成员
        friend class TemplateDispatcher;
        
        void wait_and_dispatch() {
            // 等待调度消息
            for ( ; ; ) {
                auto msg = q->wait_and_pop();
                dispatch(msg);
            }
        }
        
        // dispatch()会检查close_queue消息，然后抛出
        bool dispatch(std::shared_ptr<message_base> const& msg) {
            if (dynamic_cast<wrapped_message<close_queue>*>(msg.get())) {
                throw close_queue();
            }
            return false;
        }
    public:
        // 实例可以移动
        dispatcher(dispatcher&& other) : q(other.q), chained(other.chained) {
            other.chained = true; // 源不能等待消息
        }
        
        explicit dispatcher(queue* q_) : q(q_), chained(false) {}
        
        template <typename Message, typename Func>
        TemplateDispatcher<dispatcher, Message, Func>
        handle(Func&& f) { // 使用TemplateDispatcher处理指定类型的消息
            return TemplateDispatcher<dispatcher, Message, Func> (q, this, std::forward<Func>(f));
        }
        
        ~dispatcher() noexcept(false) { // 析构函数可能会抛出异常
            if (!chained) {
                wait_and_dispatch();
            }
        }
    };
}
