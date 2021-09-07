//
//  7.6.cpp 无锁数据结构的例子->检测使用风险指针（不可回收）的节点
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/20.
//  Copyright © 2017年 kelele67. All rights reserved.
//  get_hazard_pointer_for_current_thread() 函数的简单实现

#include <atomic>
#include <thread>

unsigned const max_hazard_pointers = 100;
struct hazard_pointer {
    std::atomic<std::thread::id> id;
    std::atomic<void*> pointer;
};
hazard_pointer hazard_pointers[max_hazard_pointers];
class hp_owner {
    hazard_pointer* hp;
public:
    hp_owner(hp_owner const&) = delete;
    hp_owner& operator=(hp_owner const&) = delete;
    hp_owner(): hp(nullptr) {
        for(unsigned i = 0; i < max_hazard_pointers; i++) {
            std::thread::id old_id;
            // compare_exchange_strong 检查某个记录是否有所有者
            if (hazard_pointers[i].id.compare_exchange_strong(old_id, std::this_thread::get_id())) {
                hp = &hazard_pointers[i];
                break;
            }
        }
        // 当遍历了列表也没有找到物所有权的记录，说明有很多线程在使用风险指针，抛出异常
        if (!hp) {
            throw std::runtime_error("No hazard pointers available");
        }
    }
    std::atomic<void*>& get_pointer() {
        return hp->pointer;
    }
    ~hp_owner() {
        hp->pointer.store(nullptr);
        hp->id.store(std::thread::id());
    }
};

std::atomic<void*>& get_hazard_pointer_for_current_thread() {
    thread_local static hp_owner hazard; // 一个hp_owner类型的thread_local(本线程所有) 变量->储存当前线程的风险指针
    return hazard.get_pointer(); // 返回这个变量所持有的风险指针
}

// 对风险指针表进行搜索，就可以找到相应记录
bool outstanding_hazard_pointers_for(void* p) {
    for (unsigned i = 0; i < max_hazard_pointers; ++i) {
        if (hazard_pointers[i].pointer.load() == p) {
            return true;
        }
    }
    return false;
}
