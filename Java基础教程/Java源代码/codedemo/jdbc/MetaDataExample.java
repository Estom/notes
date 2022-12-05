package cn.aofeng.demo.jdbc;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cn.aofeng.demo.tree.PrettyTree;
import cn.aofeng.demo.tree.PrettyTree.Node;

/**
 * JDBC元数据使用示例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class MetaDataExample {

    private static Logger _logger = LoggerFactory.getLogger(MetaDataExample.class);

    /**
     * @param args
     */
    public static void main(String[] args) {
        String url = "jdbc:mysql://192.168.56.102:19816/ucgc_sdk?useUnicode=true&characterEncoding=UTF8";
        Properties info = new Properties();
        info.put("user", "uzone");
        info.put("password", "uzone");

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, info);
            DatabaseMetaData dbMeta = conn.getMetaData();
            showCatalogs(dbMeta);
        } catch (SQLException e) {
            _logger.error("get connection occurs error", e);
        } finally {
            JDBCUtils.close(conn);
        }
    }

    private static void showCatalogs(DatabaseMetaData dbMeta) throws SQLException {
        ResultSet catalogsRs = null;
        try {
            catalogsRs = dbMeta.getCatalogs();
//             JDBCUtils.showResultSetInfo(catalogsRs);
            while (catalogsRs.next()) {
                String catalog = catalogsRs.getString("TABLE_CAT");
                showTables(dbMeta, catalog);
            }
        } finally {
            JDBCUtils.close(catalogsRs);
        }
    }

    /**
     * 采用树状结构输出Catalog和所有归属于它的表的名称。
     */
    private static void showTables(DatabaseMetaData dbMeta, String catalog) throws SQLException {
        ResultSet tablesRs = null;
        Node root = new Node(catalog);
        try {
            tablesRs = dbMeta.getTables(catalog, null, null, null);
//             JDBCUtils.showResultSetInfo(tablesRs);
            while (tablesRs.next()) {
                root.add(new Node(tablesRs.getString("TABLE_NAME")));
            }
        } finally {
            JDBCUtils.close(tablesRs);
        }
        
        StringBuilder buffer = new StringBuilder(256);
        PrettyTree pt = new PrettyTree();
        pt.renderRoot(root, buffer);
        System.out.print(buffer);
    }

}
