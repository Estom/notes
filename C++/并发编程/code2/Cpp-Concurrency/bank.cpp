//
//  bank.cpp 消息传递框架与完整的ATM机示例
//  Cpp-Concurrency
//
//  Created by 刘启 on 2017/7/27.
//  Copyright © 2017年 kelele67. All rights reserved.
//  银行状态机

class bank_machine {
    messaging::receiver incoming;
    unsigned balance;
public:
    bank_machine() : balance(199) {}
    void done() {
        get_sender().send(messaging::close_queue());
    }
    void run() {
        try {
            for( ; ; ) {
                incoming.wait()
                    .handle<verify_pin>(
                                        [&](verify_pin const& msg) {
                                            if (msg.pin == "1937") {
                                                msg.atm_queue.send(pin_verified());
                                            }
                                            else{
                                                msg.atm_queue.send(pin_incorrect());
                                            }
                                        })
                    .handle<withdraw>(
                                      [&](withdraw const& msg) {
                                          if (balance >= msg.amount) {
                                              msg.atm_queue.send(withdraw_ok());
                                              balance -= msg.amount;
                                          }
                                          else {
                                              msg.atm_queue.send(withdraw_denied());
                                          }
                                      })
                    .handle<get_balance>(
                                         [&](get_balance const& msg) {
                                             msg.atm_queue.send(::balance(balance));
                                         })
                    .handle<withdrawal_processed>(
                                                  [&](withdrawal_processed const& msg) {
                                                      
                                                  })
                    .handle<cancel_withdrawal>(
                                               [&](cancel_withdrawal const& msg) {
                                                   
                                               });
            }
        }
        catch(messaging::close_queue const&) {
            
        }
    }
    messaging::sender get
};
