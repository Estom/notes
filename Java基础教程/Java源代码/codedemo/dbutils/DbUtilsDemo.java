package cn.aofeng.demo.dbutils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.apache.log4j.Logger;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

/**
 * Apache DbUtils使用示例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class DbUtilsDemo {

    private static Logger _logger = Logger.getLogger(DbUtilsDemo.class);
    
    /**
     * 创建JDBC连接池。
     * 
     * @param pros 数据库连接信息，里面包含4个键值对。
     * <pre>
     * jdbcDriver => JDBC驱动类名称
     * url => 数据库JDBC连接地址
     * user => 连接数据库的用户名
     * password => 连接数据库的密码
     * <pre>
     * @return 连接池对象
     */
    private DataSource createDataSource(Properties pros) {
        MysqlDataSource ds = new MysqlDataSource();
        ds.setURL(pros.getProperty("url"));
        ds.setUser(pros.getProperty("user"));
        ds.setPassword(pros.getProperty("password"));
        
        return ds;
    }
    
    /**
     * 将查询结果集转换成Bean列表返回。
     * 
     * @param ds JDBC连接池
     */
    public void queryBeanList(DataSource ds) {
        String sql = "select userId, userName, gender, age from student";
        
        QueryRunner run = new QueryRunner(ds);
        ResultSetHandler<List<Student>> handler = new BeanListHandler<Student>(Student.class);
        List<Student> result = null;
        try {
            result = run.query(sql, handler);
        } catch (SQLException e) {
            _logger.error("获取JDBC连接出错或执行SQL出错", e);
        }
        
        if (null == result) {
            return;
        }
        for (Student student : result) {
            System.out.println(student);
        }
    }
    
    /**
     * 将查询结果转换成Bean返回。
     * 
     * @param ds JDBC连接池
     */
    public void queryBean(DataSource ds, int userId) {
        String sql = "select userId, userName, gender, age from student where userId=?";
        
        QueryRunner run = new QueryRunner(ds);
        ResultSetHandler<Student> handler = new BeanHandler<Student>(Student.class);
        Student result = null;
        try {
            result = run.query(sql, handler, userId);
        } catch (SQLException e) {
            _logger.error("获取JDBC连接出错或执行SQL出错", e);
        }
        
        System.out.println(result);
    }
    
    /**
     * 将查询结果集转换成键值对列表返回。
     * 
     * @param ds JDBC连接池
     */
    public void queryMapList(DataSource ds) {
        String sql = "select userId, userName, gender, age from student";
        
        QueryRunner run = new QueryRunner(ds);
        ResultSetHandler<List<Map<String, Object>>> handler = new MapListHandler();
        List<Map<String, Object>> result = null;
        try {
            result = run.query(sql, handler);
        } catch (SQLException e) {
            _logger.error("获取JDBC连接出错或执行SQL出错", e);
        }
        
        if (null == result) {
            return;
        }
        for (Map<String, Object> map : result) {
            System.out.println(map);
        }
    }
    
    /**
     * 将查询结果集转换成键值对列表返回。
     * 
     * @param ds JDBC连接池
     * @param userId 用户编号
     */
    public void queryMap(DataSource ds, int userId) {
        String sql = "select userId, userName, gender, age from student where userId=?";
        
        QueryRunner run = new QueryRunner(ds);
        ResultSetHandler<Map<String, Object>> handler = new MapHandler();
        Map<String, Object> result = null;
        try {
            result = run.query(sql, handler, userId);
        } catch (SQLException e) {
            _logger.error("获取JDBC连接出错或执行SQL出错", e);
        }
        
        System.out.println(result);
    }
    
    /**
     * 将查询结果集转换成键值对列表返回。
     * 
     * @param ds JDBC连接池
     */
    public void queryCustomHandler(DataSource ds) {
        String sql = "select userId, userName, gender, age from student";
        
        // 新实现一个ResultSetHandler
        ResultSetHandler<List<Student>> handler = new ResultSetHandler<List<Student>>() {
            @Override
            public List<Student> handle(ResultSet resultset)
                    throws SQLException {
                List<Student> result = new ArrayList<Student>();
                while (resultset.next()) {
                    Student student = new Student();
                    student.setUserId(resultset.getInt("userId"));
                    student.setUserName(resultset.getString("userName"));
                    student.setGender(resultset.getString("gender"));
                    student.setAge(resultset.getInt("age"));
                    result.add(student);
                }
                
                return result;
            }
            
        };
        
        QueryRunner run = new QueryRunner(ds);
        List<Student> result = null;
        try {
            result = run.query(sql, handler);
        } catch (SQLException e) {
            _logger.error("获取JDBC连接出错或执行SQL出错", e);
        }
        
        if (null == result) {
            return;
        }
        for (Student student : result) {
            System.out.println(student);
        }
    }
    
    public static void main(String[] args) {
        Properties pros = new Properties();
        pros.put("jdbcDriver", "com.mysql.jdbc.Driver");
        pros.put("url", "jdbc:mysql://192.168.56.102:19816/test?useUnicode=true&characterEncoding=UTF8");
        pros.put("user", "uzone");
        pros.put("password", "uzone");
        
        DbUtilsDemo demo = new DbUtilsDemo();
        DataSource ds = demo.createDataSource(pros);
        demo.queryBeanList(ds);
        demo.queryBean(ds, 1);
        demo.queryBean(ds, 9);
        demo.queryMapList(ds);
        demo.queryMap(ds, 3);
        demo.queryMap(ds, 9);
        demo.queryCustomHandler(ds);
    }

}
