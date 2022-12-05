Apache DbUtils 使用教程
===
用JDBC编程时，需要关注和处理的内容非常多，而且很容易造成连接资源没有释放导致泄漏的问题。一个普通的查询操作其处理过程如下：

1. 创建Connection。
1. 创建Statement。
1. 执行SQL生成ResultSet，历遍ResultSet中的所有行记录提取列数据并转换成所需的对象。
1. 关闭ResultSet。
1. 关闭Statement。
1. 关闭Connection。

`Apache DbUtils`对JDBC操作进行了轻量地封装，解决了两个问题：

1. 自动创建和释放连接资源，不再有泄漏问题。
2. 自动将Result转换成对象。填入不同的`ResultSetHandler`，可将ResultSet转换成不同的对象。

使得代码更加简洁和健壮，让你将精力更多地投入到业务处理中。

预备
---
* MySQL数据库
* commons-dbutils-1.5.jar
* mysql-connector-java-5.1.22-bin.jar

创建表和初始化数据
---
1、表结构。
```sql
CREATE TABLE `student` (
  `userId` int(11) NOT NULL,
  `userName` varchar(30) NOT NULL,
  `gender` char(1) NOT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;
```

2、初始化数据。

| userId | userName | gender | age |
| :--- | :--- | :--- | :--- |
| 1 |  张三 | M | 20 |
| 2 | 李四 | M | 21 |
| 3 | 王五 | M | 22 |
| 4 | 小明 | M | 6 |
| 5 | 小丽 | F | 9 |

编写查询代码
---
###1、将查询结果转换成POJO对象列表。

1）定义一个与表student相对应的对象Student（[源代码下载](https://raw.githubusercontent.com/aofeng/JavaDemo/master/src/cn/aofeng/demo/dbutils/Student.java)）。

2）使用`BeanListHandler`将查询结果转换成POJO对象列表。
```java
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
```
执行queryBeanList方法，控制台输出如下信息：
```
Student [userId=1, userName=张三, gender=M, age=20]
Student [userId=2, userName=李四, gender=M, age=21]
Student [userId=3, userName=王五, gender=M, age=22]
Student [userId=4, userName=小明, gender=M, age=6]
Student [userId=5, userName=小丽, gender=F, age=9]
```

###2、将查询结果转换成一个POJO象。

1）定义一个与表student相对应的对象Student（[源代码下载](https://raw.githubusercontent.com/aofeng/JavaDemo/master/src/cn/aofeng/demo/dbutils/Student.java)）。

2）使用`BeanHandler`将查询结果转换成一个POJO对象。
```java
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
```
执行queryBean方法，控制台输出如下信息：
```
Student [userId=1, userName=张三, gender=M, age=20]
```

###3、将查询结果转换成Map对象列表。

1）使用`MapListHandler`将ResultSet转换成Map对象列表。
```java
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
```
执行queryMapList方法，控制台输出如下信息：
```
{age=20, userId=1, gender=M, userName=张三}
{age=21, userId=2, gender=M, userName=李四}
{age=22, userId=3, gender=M, userName=王五}
{age=6, userId=4, gender=M, userName=小明}
{age=9, userId=5, gender=F, userName=小丽}
```

###4、将查询结果转换成一个Map对象。

1）使用`MapHandler`将ResultSet转换成一个Map对象。
```java
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
```
执行queryMap方法，控制台输出如下信息：
```
{age=22, userId=3, gender=M, userName=王五}
```

###5、自定义ResultSetHandler。

`Apache DbUtils`自带的各种`ResultSetHandler`已经可以满足绝大部分的查询需求，如果有一些特殊的要求满足不了，可以自己实现一个。
```java
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
```
执行queryCustomHandler方法，控制台输出如下信息：
```
Student [userId=1, userName=张三, gender=M, age=20]
Student [userId=2, userName=李四, gender=M, age=21]
Student [userId=3, userName=王五, gender=M, age=22]
Student [userId=4, userName=小明, gender=M, age=6]
Student [userId=5, userName=小丽, gender=F, age=9]
```

附录
---
* [DEMO完整源代码](https://github.com/aofeng/JavaDemo/edit/master/src/cn/aofeng/demo/dbutils)

参考资料
---
* [commons-dbutils example](http://commons.apache.org/proper/commons-dbutils/examples.html)
