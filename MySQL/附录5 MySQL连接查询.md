# 5 JOIN连接查询

> 参考文献
> * [MySQL的JOIN用法](https://www.cnblogs.com/hcfinal/p/10231694.html)

![](../image/2021-09-01-15-38-13.png)


* 数据库实例

```sql
 1  CREATE TABLE t_blog(
 2         id INT PRIMARY KEY AUTO_INCREMENT,
 3         title VARCHAR(50),
 4         typeId INT
 5     );
 6     SELECT * FROM t_blog;
 7     +----+-------+--------+
 8     | id | title | typeId |
 9     +----+-------+--------+
10     |  1 | aaa   |      1 |
11     |  2 | bbb   |      2 |
12     |  3 | ccc   |      3 |
13     |  4 | ddd   |      4 |
14     |  5 | eee   |      4 |
15     |  6 | fff   |      3 |
16     |  7 | ggg   |      2 |
17     |  8 | hhh   |   NULL |
18     |  9 | iii   |   NULL |
19     | 10 | jjj   |   NULL |
20     +----+-------+--------+
21     -- 博客的类别
22     CREATE TABLE t_type(
23         id INT PRIMARY KEY AUTO_INCREMENT,
24         name VARCHAR(20)
25     );
26     SELECT * FROM t_type;
27     +----+------------+
28     | id | name       |
29     +----+------------+
30     |  1 | C++        |
31     |  2 | C          |
32     |  3 | Java       |
33     |  4 | C#         |
34     |  5 | Javascript |
35     +----+------------+
```
## 1. 笛卡尔积

要理解各种JOIN首先要理解笛卡尔积。笛卡尔积就是将A表的每一条记录与B表的每一条记录强行拼在一起。所以，如果A表有n条记录，B表有m条记录，笛卡尔积产生的结果就会产生n*m条记录。

## 2. 内连接：INNER JOIN。

内连接INNER JOIN是最常用的连接操作。从数学的角度讲就是求两个表的交集，从笛卡尔积的角度讲就是从笛卡尔积中挑出ON子句条件成立的记录。有INNER JOIN，WHERE（等值连接），STRAIGHT_JOIN,JOIN(省略INNER)四种写法。

```sql
    SELECT * FROM t_blog INNER JOIN t_type ON t_blog.typeId=t_type.id;
    SELECT * FROM t_blog,t_type WHERE t_blog.typeId=t_type.id;
    SELECT * FROM t_blog STRAIGHT_JOIN t_type ON t_blog.typeId=t_type.id; --注意STRIGHT_JOIN有个下划线
    SELECT * FROM t_blog JOIN t_type ON t_blog.typeId=t_type.id;
    +----+-------+--------+----+------+
    | id | title | typeId | id | name |
    +----+-------+--------+----+------+
    |  1 | aaa   |      1 |  1 | C++  |
    |  2 | bbb   |      2 |  2 | C    |
    |  7 | ggg   |      2 |  2 | C    |
    |  3 | ccc   |      3 |  3 | Java |
    |  6 | fff   |      3 |  3 | Java |
    |  4 | ddd   |      4 |  4 | C#   |
    |  5 | eee   |      4 |  4 | C#   |
    +----+-------+--------+----+------+
```

## 3. 左连接：LEFT JOIN
左连接LEFT JOIN的含义就是求两个表的交集外加左表剩下的数据。依旧从笛卡尔积的角度讲，就是先从笛卡尔积中挑出ON子句条件成立的记录，然后加上左表中剩余的记录（见最后三条）。

```
    SELECT * FROM t_blog LEFT JOIN t_type ON t_blog.typeId=t_type.id;
    +----+-------+--------+------+------+
    | id | title | typeId | id   | name |
    +----+-------+--------+------+------+
    |  1 | aaa   |      1 |    1 | C++  |
    |  2 | bbb   |      2 |    2 | C    |
    |  7 | ggg   |      2 |    2 | C    |
    |  3 | ccc   |      3 |    3 | Java |
    |  6 | fff   |      3 |    3 | Java |
    |  4 | ddd   |      4 |    4 | C#   |
    |  5 | eee   |      4 |    4 | C#   |
    |  8 | hhh   |   NULL | NULL | NULL |
    |  9 | iii   |   NULL | NULL | NULL |
    | 10 | jjj   |   NULL | NULL | NULL |
    +----+-------+--------+------+------+
```

## 4. 右连接：RIGHT JOIN
同理右连接RIGHT JOIN就是求两个表的交集外加右表剩下的数据。再次从笛卡尔积的角度描述，右连接就是从笛卡尔积中挑出ON子句条件成立的记录，然后加上右表中剩余的记录（见最后一条）。
```
    SELECT * FROM t_blog RIGHT JOIN t_type ON t_blog.typeId=t_type.id;
    +------+-------+--------+----+------------+
    | id   | title | typeId | id | name       |
    +------+-------+--------+----+------------+
    |    1 | aaa   |      1 |  1 | C++        |
    |    2 | bbb   |      2 |  2 | C          |
    |    3 | ccc   |      3 |  3 | Java       |
    |    4 | ddd   |      4 |  4 | C#         |
    |    5 | eee   |      4 |  4 | C#         |
    |    6 | fff   |      3 |  3 | Java       |
    |    7 | ggg   |      2 |  2 | C          |
    | NULL | NULL  |   NULL |  5 | Javascript |
    +------+-------+--------+----+------------+
```
## 5. 外连接：OUTER JOIN
外连接就是求两个集合的并集。从笛卡尔积的角度讲就是从笛卡尔积中挑出ON子句条件成立的记录，然后加上左表中剩余的记录，最后加上右表中剩余的记录。另外MySQL不支持OUTER JOIN，但是我们可以对左连接和右连接的结果做UNION操作来实现。

```
    SELECT * FROM t_blog LEFT JOIN t_type ON t_blog.typeId=t_type.id
    UNION
    SELECT * FROM t_blog RIGHT JOIN t_type ON t_blog.typeId=t_type.id;
    +------+-------+--------+------+------------+
    | id   | title | typeId | id   | name       |
    +------+-------+--------+------+------------+
    |    1 | aaa   |      1 |    1 | C++        |
    |    2 | bbb   |      2 |    2 | C          |
    |    7 | ggg   |      2 |    2 | C          |
    |    3 | ccc   |      3 |    3 | Java       |
    |    6 | fff   |      3 |    3 | Java       |
    |    4 | ddd   |      4 |    4 | C#         |
    |    5 | eee   |      4 |    4 | C#         |
    |    8 | hhh   |   NULL | NULL | NULL       |
    |    9 | iii   |   NULL | NULL | NULL       |
    |   10 | jjj   |   NULL | NULL | NULL       |
    | NULL | NULL  |   NULL |    5 | Javascript |
    +------+-------+--------+------+------------+
```
## 6. USING子句
MySQL中连接SQL语句中，ON子句的语法格式为：table1.column_name = table2.column_name。当模式设计对联接表的列采用了相同的命名样式时，就可以使用 USING 语法来简化 ON 语法，格式为：USING(column_name)。 
   
所以，USING的功能相当于ON，区别在于USING指定一个属性名用于连接两个表，而ON指定一个条件。另外，SELECT *时，USING会去除USING指定的列，而ON不会。实例如下。


```sql
    SELECT * FROM t_blog INNER JOIN t_type ON t_blog.typeId =t_type.id;
    +----+-------+--------+----+------+
    | id | title | typeId | id | name |
    +----+-------+--------+----+------+
    |  1 | aaa   |      1 |  1 | C++  |
    |  2 | bbb   |      2 |  2 | C    |
    |  7 | ggg   |      2 |  2 | C    |
    |  3 | ccc   |      3 |  3 | Java |
    |  6 | fff   |      3 |  3 | Java |
    |  4 | ddd   |      4 |  4 | C#   |
    |  5 | eee   |      4 |  4 | C#   |
    +----+-------+--------+----+------+


    SELECT * FROM t_blog INNER JOIN t_type USING(typeId);
    ERROR 1054 (42S22): Unknown column 'typeId' in 'from clause'
    SELECT * FROM t_blog INNER JOIN t_type USING(id); -- 应为t_blog的typeId与t_type的id不同名，无法用Using，这里用id代替下。
    +----+-------+--------+------------+
    | id | title | typeId | name       |
    +----+-------+--------+------------+
    |  1 | aaa   |      1 | C++        |
    |  2 | bbb   |      2 | C          |
    |  3 | ccc   |      3 | Java       |
    |  4 | ddd   |      4 | C#         |
    |  5 | eee   |      4 | Javascript |
    +----+-------+--------+------------+

```

## 7. 自然连接：NATURE JOIN

自然连接就是USING子句的简化版，它找出两个表中相同的列作为连接条件进行连接。有左自然连接，右自然连接和普通自然连接之分。在t_blog和t_type示例中，两个表相同的列是id，所以会拿id作为连接条件。 另外千万分清下面三条语句的区别 。
 1. 自然连接:SELECT * FROM t_blog NATURAL JOIN t_type; 
 2. 笛卡尔积:SELECT * FROM t_blog NATURA JOIN t_type; 
 3. 笛卡尔积:SELECT * FROM t_blog NATURE JOIN t_type;

```sql
    SELECT * FROM t_blog NATURAL JOIN t_type;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog,t_type WHERE t_blog.id=t_type.id;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog INNER JOIN t_type ON t_blog.id=t_type.id;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog INNER JOIN t_type USING(id);

    +----+-------+--------+------------+
    | id | title | typeId | name       |
    +----+-------+--------+------------+
    |  1 | aaa   |      1 | C++        |
    |  2 | bbb   |      2 | C          |
    |  3 | ccc   |      3 | Java       |
    |  4 | ddd   |      4 | C#         |
    |  5 | eee   |      4 | Javascript |
    +----+-------+--------+------------+

    SELECT * FROM t_blog NATURAL LEFT JOIN t_type;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog LEFT JOIN t_type ON t_blog.id=t_type.id;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog LEFT JOIN t_type USING(id);

    +----+-------+--------+------------+
    | id | title | typeId | name       |
    +----+-------+--------+------------+
    |  1 | aaa   |      1 | C++        |
    |  2 | bbb   |      2 | C          |
    |  3 | ccc   |      3 | Java       |
    |  4 | ddd   |      4 | C#         |
    |  5 | eee   |      4 | Javascript |
    |  6 | fff   |      3 | NULL       |
    |  7 | ggg   |      2 | NULL       |
    |  8 | hhh   |   NULL | NULL       |
    |  9 | iii   |   NULL | NULL       |
    | 10 | jjj   |   NULL | NULL       |
    +----+-------+--------+------------+

    SELECT * FROM t_blog NATURAL RIGHT JOIN t_type;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog RIGHT JOIN t_type ON t_blog.id=t_type.id;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog RIGHT JOIN t_type USING(id);

    +----+------------+-------+--------+
    | id | name       | title | typeId |
    +----+------------+-------+--------+
    |  1 | C++        | aaa   |      1 |
    |  2 | C          | bbb   |      2 |
    |  3 | Java       | ccc   |      3 |
    |  4 | C#         | ddd   |      4 |
    |  5 | Javascript | eee   |      4 |
    +----+------------+-------+--------+
```
