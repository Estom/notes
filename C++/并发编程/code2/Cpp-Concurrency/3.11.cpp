//
//  3.11.cpp 保护很少更新的数据结构
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  一个写者，多个读者的互斥量
//  使用 boost::shared_mutex 对数据结构进行保护->简单的DNS缓存

#include <map>
#include <string>
#include <mutex>
#include <boost/thread/shared_mutex.hpp>

class dns_entry {
    
};

class dns_cache {
    std::map<std::string, dns_entry> entries;
    mutable boost::shared_mutex entry_mutex;
public:
    dns_entry find_entry(std::string const& domain) const {
        boost::shared_lock<boost::shared_mutex> lk(entry_mutex); // 保护共享和只读权限
        std::map<std::string, dns_entry>::const_iterator const it =entries.find(domain);
        return (it == entries.end()) ? dns_entry() : it->second;
    }
    void update_or_add_entry(std::string const& domain, dns_entry const& dns_details) {
        std::lock_guard<boost::shared_mutex> lk(entry_mutex); //  表格需要更新时独占
        entries[domain] = dns_details;
    }
};
