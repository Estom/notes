JDBC 操作数据库的基本步骤：
1）加载（注册）数据库驱动（到 JVM）。
2）建立（获取）数据库连接。
3）创建（获取）数据库操作对象。
4）定义操作的 SQL 语句。
5）执行数据库操作。
6）获取并操作结果集。
7）关闭对象，回收数据库资源（关闭结果集--\>关闭数据库操作对象--\>关闭连接）。
**[java]** [view plain](http://blog.csdn.net/hpu_a/article/details/51354867)
[copy](http://blog.csdn.net/hpu_a/article/details/51354867)

```java
**package** com.yangshengjie.jdbc;
**import** java.sql.Connection;
**import** java.sql.DriverManager;
**import** java.sql.ResultSet;
**import** java.sql.SQLException;
**import** java.sql.Statement;

**public** **class** JDBCTest {
/\*\*
\* 使用JDBC连接并操作mysql数据库
\*/
**public** **static** **void** main(String[] args) {
// 数据库驱动类名的字符串
String driver = "com.mysql.jdbc.Driver";
// 数据库连接串
String url = "jdbc:mysql://127.0.0.1:3306/jdbctest";
// 用户名
String username = "root";
// 密码
String password = "mysqladmin";
Connection conn = **null**;
Statement stmt = **null**;
ResultSet rs = **null**;
**try** {
// 1、加载数据库驱动（
成功加载后，会将Driver类的实例注册到DriverManager类中）
Class.forName(driver );
// 2、获取数据库连接
conn = DriverManager.getConnection(url, username, password);
// 3、获取数据库操作对象
stmt = conn.createStatement();
// 4、定义操作的SQL语句
String sql = "select \* from user where id = 100";
// 5、执行数据库操作
rs = stmt.executeQuery(sql);
// 6、获取并操作结果集
**while** (rs.next()) {
System.out.println(rs.getInt("id"));
System.out.println(rs.getString("name"));
}
} **catch** (Exception e) {
e.printStackTrace();
} **finally** {
// 7、关闭对象，回收数据库资源
**if** (rs != **null**) { //关闭结果集对象
**try** {
rs.close();
} **catch** (SQLException e) {
e.printStackTrace();
}
}
**if** (stmt != **null**) { // 关闭数据库操作对象
**try** {
stmt.close();
} **catch** (SQLException e) {
e.printStackTrace();
}
}
**if** (conn != **null**) { // 关闭数据库连接对象
**try** {
**if** (!conn.isClosed()) {
conn.close();
}
} **catch** (SQLException e) {
e.printStackTrace();
}
}
}
}
}
```
