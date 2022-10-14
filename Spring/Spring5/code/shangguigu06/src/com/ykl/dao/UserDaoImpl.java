/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.dao;

import com.mysql.cj.result.Row;
import com.ykl.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.Arrays;
import java.util.List;

/**
 * @author yinkanglong
 * @version : UserDoImpl, v 0.1 2022-10-09 12:04 yinkanglong Exp $
 */
@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public int addUser(User user) {
        String sql = "insert into user values(?,?,?)";
        Object[] args = {user.getUserId(),user.getUsername(),user.getUserStatus()};

        int update = jdbcTemplate.update(sql,args);
        System.out.println(update);
        return update;
    }

    @Override
    public void updateUser(User user) {
        String sql = "update user set username=?,userstatus=? where userid=?";
        Object[] args = {user.getUsername(),user.getUserStatus(),user.getUserId()};

        int update = jdbcTemplate.update(sql,args);
        System.out.println(update);
        return ;
    }

    @Override
    public void delete(String id) {
        String sql = "delete from user where userid=?";
        Object[] args = {id,};

        int update = jdbcTemplate.update(sql,args);
        System.out.println(update);
        return ;
    }


    /**
     * 查询返回整数
     * @return
     */
    @Override
    public int selectCount(){
        String sql = "select count(*) from user";
        Integer count = jdbcTemplate.queryForObject(sql,Integer.class);
        return count;
    }

    /**
     * 查询返回单个记录
     * @param id
     * @return
     */
    @Override
    public User findUserInfo(String id){
        String sql = "select * from user where userid=?";
        User user = jdbcTemplate.queryForObject(sql,new BeanPropertyRowMapper<User>(User.class),id);
        return user;
    }

    @Override
    public List<User> findAll() {
        String sql = "select * from user";
        List<User> users = jdbcTemplate.query(sql, new BeanPropertyRowMapper<User>(User.class));
        return users;
    }

    @Override
    public void batchAdd(List<Object[]> batchArgs) {
        String sql = "insert into user values(?,?,?)";
        int [] ints = jdbcTemplate.batchUpdate(sql,batchArgs);
        System.out.println(Arrays.toString(ints));
    }


}
