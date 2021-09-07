//
//  2.4.cpp 后台运行线程
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/17.
//  Copyright © 2017年 kelele67. All rights reserved.
//  使用分离线程去处理其他文档
//  每个窗口拥有自己的线程，并且没有必要等待其他线程

#include <thread>
#include <string>

void open_document_and_display_gui(std::string const& filename) {
    
}

bool done_editing() {
    return true;
}

enum command_type {
    open_new_document
};

struct user_command {
    command_type type;
    
    user_command(): type(open_new_document) {}
};

user_command get_user_input() {
    return user_command();
}

std::string get_filename_from_user() {
    return "foo.doc";
}

void process_user_input(user_command const& cmd) {

}

void edit_document(std::string const& filename) {
    open_document_and_display_gui(filename);
    while (!done_editing()) {
        user_command cmd = get_user_input();
        if (cmd.type == open_new_document) {
            std::string const new_name = get_filename_from_user();
            // 不仅可以向thread构造函数传递函数名，还可以传递函数参数（实参）->
            std::thread t(edit_document, new_name); // -> 启动新线程
            t.detach(); // 分离线程
        }
        else {
            process_user_input(cmd);
        }
    }
}

int main() {
    edit_document("bar.doc");
}
