package org.example.dao;

import com.alibaba.druid.pool.DruidDataSourceFactory;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class JDBCUtils {
    static DataSource datasource = null;

    private static ThreadLocal<Connection> tl = new ThreadLocal<>();

    static {
        Properties properties = new Properties();

        InputStream in = JDBCUtils.class.getClassLoader().getResourceAsStream("druid.properties");
        try{
            properties.load(in);
        }catch(IOException e){
            throw new RuntimeException(e);
        }

        try {
            datasource = DruidDataSourceFactory.createDataSource(properties);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public static Connection getConnection() throws SQLException {
        Connection connection = tl.get();
        if(connection == null){
            connection = datasource.getConnection();
            tl.set(connection);
        }
        return connection;
    }

    public static void freeConnection() throws SQLException {

        Connection connection = tl.get();
        if(connection != null){
            tl.remove();
            connection.setAutoCommit(false);
            connection.close();
        }

    }


}
