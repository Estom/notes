## 1 基本概念

### JDBC

java数据库链接，java database connectivity。java语言用来规范客户访问数据库的应用程序接口。提供了查询、更新数据库的方法。java.sql与javax.sql主要包括以下类：

* DriverManager:负责加载不同的驱动程序Driver，返回相应的数据库连接Connection。
* Driver：对应数据库的驱动程序。
* Connection：数据库连接，负责与数据库进行通信。可以产生SQL的statement.
* Statement:用来执行SQL查询和更新。
* CallableStatement：用以调用数据库中的存储过程。
* SQLException：代表数据库联机额的建立和关闭和SQL语句中发生的例情况。

### 数据源

1. 封装关于数据库访问的各种参数，实现统一管理。
2. 通过数据库的连接池管理，节省开销并提高效率。

> 简单理解，就是在用户程序与数据库之间，建立新的缓冲地带，用来对用户的请求进行优化，对数据库的访问进行整合。

常见的数据源：DBCP、C3P0、Druid、HikariCP。


## 2 HikariCP默认数据源配置

### 通用配置

以spring.datasource.*的形式存在，包括数据库连接地址、用户名、密码。
```
spring.datasource.url=jdbc:mysql://localhost:3306/test
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

### 数据源连接配置

以spring.datasource.<数据源名称>.*的形式存在，
```
spring.datasource.hikari.minimum-idle=10//最小空闲连接
spring.datasource.hikari.maximum-pool-size=20//最大连接数
spring.datasource.hikari.idle-timeout=500000//控线连接超时时间
spring.datasource.hikari.max-lifetime=540000//最大存活时间
spring.datasource.hikari.connection-timeout=60000//连接超时时间
spring.datasource.hikari.connection-test-query=SELECT 1//用于测试连接是否可用的查询语句
```

