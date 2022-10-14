/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.example.shangguigu09.service;

import com.example.shangguigu09.entity.User;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * @author yinkanglong
 * @version : UserService, v 0.1 2022-10-13 19:02 yinkanglong Exp $
 */
public interface UserService {
    //id查询用户
    Mono<User> getUserById(int id);

    //查询所有的用户
    Flux<User> getAllUser();

    //添加用户
    Mono<Void> savaUserInfo(Mono<User> user);
}
