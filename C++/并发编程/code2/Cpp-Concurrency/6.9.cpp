//
//  6.9.cpp 基于锁设计更加复杂的数据结构->编写一个使用锁的线程安全查询表
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/19.
//  Copyright © 2017年 kelele67. All rights reserved.
//  获取整个 threadsafe_look_up_table 作为一个 std::map<>(快照)

std::map<Key, Value> threadsafe_look_up_table::get_map() const {
    std::vector<std::unique_lock<boost::shared_mutex> > locks;
    for (unsigned i = 0; i < buckets.size(); ++i) {
        locks.push_back(std::unique_lock<boost::shared_mutex>(buckets[i].mutex));
    }
    std::map<Key, Value> res;
    for (unsigned i = 0; i < buckets.size(); ++i) {
        for (bucket_iterator it = buckets[i].data.begin(); it != buckets[i].data.end(); ++it) {
            res.insert(*it);
        }
    }
    return res;
}
