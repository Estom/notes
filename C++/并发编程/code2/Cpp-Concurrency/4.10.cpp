//
//  4.10.cpp 使用期望等待一次性事件->使用std::promises
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/18.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用“承诺”解决单线程多连接问题

#include <future>

void process_connections(connection_set& connections) {
    while (!done(connections)) {
        for(connection_iterator connection = connections.begin();
            connection != connections.end();
            ++connection) {
            if (connection->has_incoming_data()) {
                data_packet data = connection->iscoming();
                std::promise<payload_type>& p = connection->get_promise(data.id);
                p.set_value(data.payload);
            }
            if (connection->has_outgoing_data()) {
                outgoing_packet data = connection->top_of_outgoing_queue();
                connection->send(data.payload);
                data.promise.set_value(true);
            }
        }
    }
}
