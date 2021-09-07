//
//  templateDispatcher.cpp 消息传递框架与完整的ATM机示例
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/25.
//  Copyright © 2017年 kelele67. All rights reserved.
//  TemplateDipatcher类模板

#include <queue>
#include <memory>

namespace messaging {
    template<typename PreviousDispatcher, typename Msg, typename Func>
    class TemplateDipatcher {
        queue* q;
        PreviousDispatcher* prev;
        Func f;
        bool chained;
        TemplateDipatcher(TemplateDipatcher const&) = delete;
        TemplateDipatcher& operator=(TemplateDipatcher const&) = delete;
        
        template<typename Dispatcher, typename OtherMsg, typename OtherFunc>
        friend class TemplateDipatcher;
        
        void wait_and_dispatch() {
            for (; ;) {
                auto msg = q->wait_and_pop();
                if(dispatch(msg)) {
                    break;
                }
            }
        }
        
        bool dispatch(std::shared_ptr<message_base> const& msg) {
            if (wrapped_message<Msg>* wrapper = dynamic_cast<wrapped_message<Msg>*>(msg.get())) {
                f(wrapped->contents);
                return true;
            }
            else {
                return prev->dispatch(msg);
            }
        }
    public:
        TemplateDipatcher(TemplateDipatcher&& other) : q(other.q), prev(other.prev), f(std::move(other.f)), chained(other.chained) {
            other.chained = true;
        }
        TemplateDipatcher(queue* q_, PreviousDispatcher* prev_, Func&& f_) : q(q_), prev(prev_), f(std::forward<Func>(F_)), chained(false) {
            prev->chained = true;
        }
        
        template<typename OtherMsg, typename OtherFunc>
        TemplateDipatcher<TemplateDipatcher, OtherMsg, OtherFunc>
        handle(OtherFunc&& of) {
            return TemplateDipatcher<TemplateDipatcher, OtherMsg, OtherFunc>(of));
        }
        
        ~TemplateDipatcher() noexcept(false) {
            if (!chained) {
                wait_and_dispatch();
            }
        }
    };
}
