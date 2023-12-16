package org.example.dao;

import com.mysql.cj.jdbc.Driver;
import org.junit.Test;

import java.sql.*;

public class JDBCTest {


    @Test
    public void testJDBCConnnection() throws SQLException {
        DriverManager.registerDriver(new Driver());



        String url = "jdbc:mysql://127.0.0.1/test";
        String username= "root";
        String password = "long1011";
        Connection connection = DriverManager.getConnection(url, username, password);


        String sql2 = "INSERT INTO user (name) values ('testname02')";
        connection.createStatement().executeUpdate(sql2);


        String sql = "select * from user;";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);

        while (resultSet.next()) {
            String name = resultSet.getString("name");
            int id = resultSet.getInt("id");
            System.out.println("name: " + name+" id: " + id);

        }


        resultSet.close();
        statement.close();
        connection.close();


    }
}
