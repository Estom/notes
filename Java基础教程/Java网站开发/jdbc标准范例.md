JDBC操作数据库的基本步骤：

1）加载（注册）数据库驱动（到JVM）。

2）建立（获取）数据库连接。

3）创建（获取）数据库操作对象。

4）定义操作的SQL语句。

5）执行数据库操作。

6）获取并操作结果集。

7）关闭对象，回收数据库资源（关闭结果集--\>关闭数据库操作对象--\>关闭连接）。

**[java]** [view plain](http://blog.csdn.net/hpu_a/article/details/51354867)
[copy](http://blog.csdn.net/hpu_a/article/details/51354867)

1.  **package** com.yangshengjie.jdbc;

2.  **import** java.sql.Connection;

3.  **import** java.sql.DriverManager;

4.  **import** java.sql.ResultSet;

5.  **import** java.sql.SQLException;

6.  **import** java.sql.Statement;

7.  

8.  **public** **class** JDBCTest {

9.  /\*\*

10. \* 使用JDBC连接并操作mysql数据库

11. \*/

12. **public** **static** **void** main(String[] args) {

13. // 数据库驱动类名的字符串

14. String driver = "com.mysql.jdbc.Driver";

15. // 数据库连接串

16. String url = "jdbc:mysql://127.0.0.1:3306/jdbctest";

17. // 用户名

18. String username = "root";

19. // 密码

20. String password = "mysqladmin";

21. Connection conn = **null**;

22. Statement stmt = **null**;

23. ResultSet rs = **null**;

24. **try** {

25. // 1、加载数据库驱动（
    成功加载后，会将Driver类的实例注册到DriverManager类中）

26. Class.forName(driver );

27. // 2、获取数据库连接

28. conn = DriverManager.getConnection(url, username, password);

29. // 3、获取数据库操作对象

30. stmt = conn.createStatement();

31. // 4、定义操作的SQL语句

32. String sql = "select \* from user where id = 100";

33. // 5、执行数据库操作

34. rs = stmt.executeQuery(sql);

35. // 6、获取并操作结果集

36. **while** (rs.next()) {

37. System.out.println(rs.getInt("id"));

38. System.out.println(rs.getString("name"));

39. }

40. } **catch** (Exception e) {

41. e.printStackTrace();

42. } **finally** {

43. // 7、关闭对象，回收数据库资源

44. **if** (rs != **null**) { //关闭结果集对象

45. **try** {

46. rs.close();

47. } **catch** (SQLException e) {

48. e.printStackTrace();

49. }

50. }

51. **if** (stmt != **null**) { // 关闭数据库操作对象

52. **try** {

53. stmt.close();

54. } **catch** (SQLException e) {

55. e.printStackTrace();

56. }

57. }

58. **if** (conn != **null**) { // 关闭数据库连接对象

59. **try** {

60. **if** (!conn.isClosed()) {

61. conn.close();

62. }

63. } **catch** (SQLException e) {

64. e.printStackTrace();

65. }

66. }

67. }

68. }

69. }
