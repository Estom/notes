package cn.aofeng.demo.jdbc;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * JDBC常用方法集。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class JDBCUtils {

    private static Logger _logger = LoggerFactory.getLogger(JDBCUtils.class);
    
    public static void close(ResultSet rs) {
        if (null != rs) {
            try {
                rs.close();
            } catch (SQLException e) {
                _logger.error("close resultset occurs error", e);
            }
        }
    }
    
    public static void close(Statement stmt) {
        if (null != stmt) {
            try {
                stmt.close();
            } catch (SQLException e) {
                _logger.error("close statement occurs error", e);
            }
        }
    }
    
    public static void close(Connection conn) {
        if (null != conn) {
            try {
                conn.close();
            } catch (SQLException e) {
                _logger.error("close connection occurs error", e);
            }
        }
    }

    public static void showResultSetInfo(ResultSet rs) throws SQLException {
        ResultSetMetaData rsMeta = rs.getMetaData();
        int colCount = rsMeta.getColumnCount();
        _logger.info("total columns:{}", colCount);
        for (int i = 1; i <= colCount; i++) {
            _logger.info("column name:{}, label:{}, type:{}, typeName:{}",
                    rsMeta.getColumnName(i), 
                    rsMeta.getColumnLabel(i),
                    rsMeta.getColumnType(i),
                    rsMeta.getColumnTypeName(i));
        }
    }

}
