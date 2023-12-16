package com.ykl.proxy.service;

public class UserServiceImpl implements UserService {
    @Override
    public void select() {
        System.out.println("selecting");
    }

    @Override
    public void update() {
        System.out.println("updating");
    }
}
