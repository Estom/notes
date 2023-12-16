package org.example.dao;

import java.lang.reflect.Field;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BaseDAO {

    public int executeUpdate(String sql, Object... args) throws SQLException {
        Connection conn = JDBCUtils.getConnection();

        PreparedStatement ps = conn.prepareStatement(sql);

        for (int i = 0; i < args.length; i++) {
            ps.setString(i, args[i-1].toString());
        }

        int rows = ps.executeUpdate();
        ps.close();
        if (!conn.getAutoCommit()) {
            conn.close();
        }
        return rows;
    }

    public <T> List<T> executeQuery(Class<T> clazz,String sql, Object... args) throws SQLException, InstantiationException, IllegalAccessException, NoSuchFieldException {
        Connection conn = JDBCUtils.getConnection();

        PreparedStatement ps = conn.prepareStatement(sql);

        for (int i = 0; i < args.length; i++) {
            ps.setString(i, args[i-1].toString());
        }

        ResultSet resultSet = ps.executeQuery();

        //对返回值进行解析
        ResultSetMetaData resultMeta = resultSet.getMetaData();
        int count = resultMeta.getColumnCount();

        List<T> rows = new ArrayList<T>();
        while(resultSet.next()){
            T t = clazz.newInstance();
            for (int i = 1; i < count; i++) {
                Object object = resultSet.getObject(i);
                String columnName = resultMeta.getColumnName(i);
                Field field = clazz.getDeclaredField(columnName);
                field.setAccessible(true);
                field.set(t,object);
            }
            rows.add(t);
        }



        ps.close();
        if (!conn.getAutoCommit()) {
            conn.close();
        }
        return rows;
    }
}
