# 性能调优
> 参考文献
> * [https://www.jb51.net/article/70111.htm](https://www.jb51.net/article/70111.htm)
> * [https://www.cnblogs.com/jiekzou/p/5371085.html](https://www.cnblogs.com/jiekzou/p/5371085.html)

## 0 基础方法

1. 数据库设计优化：
   1. 选择合适的存储引擎
   2. 设计合理的表结构(符合3NF)
   3. 添加适当索引(index) 普通索引、主键索引、唯一索引、全文索引、组合索引、覆盖索引。
2. 查询语句优化：
   1. 遵守查询规范。
   2. 分析日志：通过show status命令了解各种SQL的执行频率。定位执行效率较低的SQL语句（重点select，记录慢查询）
   3. explain分析低效率的SQL语句
3. 查询过程优化
   1. 从内存中读取数据
   2. 减少磁盘写入操作(更大的写缓存)
   3. 提高磁盘读取速度(硬件设备改善)


## 1.1 存储引擎
* 支持全文索引：MyISAM
* 支持外键：Innodb
* 支持缓存：Innodb
* 支持事务：Innodb
* 支持并发：MyISAM 只支持表级锁，而 InnoDB 还支持行级锁。
* 支持备份：InnoDB 支持在线热备份。
* 崩溃恢复：MyISAM 崩溃后发生损坏的概率比 InnoDB 高很多，而且恢复的速度也更慢。
* 其它特性：MyISAM 支持压缩表和空间数据索引。

## 1.2 表结构

符合3BNF/EBNF范式
* 属性不可分
* 非主属性依赖完全的主属性
* 非主属性不依赖其他的非主属性
* 消除多值依赖（多对多关系）
## 1.3 添加索引
索引类型选择：
1. **前缀索引**。对于 BLOB、TEXT 和 VARCHAR 类型的列，必须使用前缀索引，只索引开始的部分字符。前缀长度的选取需要根据索引选择性来确定。字符串列加索引最好加短索引，即对前该列的前xx个字符，例如：key 'ind_user_info_addr' (addr(10)) USINGBTREE代表对addr列的前10个字符家索引。
2. **复合索引**。在需要使用多个列作为条件进行查询时，使用多列索引比使用多个单列索引性能更好。如果创建了一个(username,age,addr)的复合索引，那么相当于创建了(username,age,addr)，(username,age)，(username)三个索引，所以在创建复合索引的时候应该将最常用的限制条件的列放在最左边，依次递减。

索引使用规范：
1. 不能再索引字段上计算。会导致索引无效，成为全表扫描。
2. 将非”索引”数据分离，比如将大篇文章分离存储，不影响其他自动查询。
3. **覆盖索引**。能够直接通过索引查询到所需要的字段，不需要通过回表查询，找到数据。
4. **关联查询**。保证关联的字段都建立索引，并且字段类型一致，这样才能两个表都使用索引。如果字段类型不一样，至少一个表不能使用索引。保证连接的索引是相同类型。即a.age = b.age，a表的和b表的age字段类型保证一样，并且都建立了索引。
5.  **最左匹配原则**：索引列如果使用like条件进行查询，那么 like 'xxx%' 可以使用索引，like '%xxx' 不能使用索引。
6. 索引列的值最好不要有null值。列中只要包含null，则不会被包含到索引中，复合索引中只要有一列为null值，则这个复合索引失效的。所以创建索引列不要设置默认值null
7. 如果where条件中使用了一个列的索引，那么后面order by 在用这个列进行排序时，便不会再使用索引。where条件用到复合索引中的字段时，最好把该字段放在复合索引的左端，这样才能使用索引提高查询。
8. 排序索引。尽量不要使用包含多个列的排序，如果需要则给这些列加上复合索引。



## 2.1 查询规范

1. **减少请求的数据量**。单条查询最后增加 LIMIT，停止全表扫描。
   - 只返回必要的列：最好不要使用 SELECT * 语句。
   - 只返回必要的行：使用 LIMIT 语句来限制返回的数据。
3. 不用 MYSQL 内置的函数，因为内置函数不会建立查询缓存。
4. inner join 内连接也叫做等值连接，left/right join 是外连接。能用inner join连接的尽量用inner join连接
5. 尽量使用外连接来替换子查询。在使用on和where的时候，先用on，在用where。使用join时，用小的结果驱动大的结果（left join左表结果尽量小，如果有条件，先放左边处理，right join同理反向）。多表联合查询尽量拆分多个简单的sql语句进行查询。
6. 尽量不要使用BY RAND()命令。减少排序order by。少用OR。尽量不要使用not in 和<> 操作
7. 避免类型转换，也就是转入的参数类型要和字段类型一致。
8. 不要在列上进行运算。
9.  使用批量插入操作代替一个一个插入
10. 对于多表查询可以建立视图。



## 2.2 分析日志
修改mysql的慢查询.
```
show variables like 'long_query_time' ; //可以显示当前慢查询时间
set long_query_time=1 ;//可以修改慢查询时间
```
记录所有查询，这在用 ORM 系统或者生成查询语句的系统很有用。
```
log=/var/log/mysql.log
```
注意不要在生产环境用，否则会占满你的磁盘空间。

记录执行时间超过 1 秒的查询：
```
long_query_time=1
log-slow-queries=/var/log/mysql/log-slow-queries.log
```

## 2.3 explain分析查询

### 分析方法
```
Explain select * from emp where ename=“wsrcla”
```
会产生如下信息：

* select_type:表示查询的类型。
* table:输出结果集的表
* type:表示表的连接类型
* possible_keys:表示查询时，可能使用的索引
* key:表示实际使用的索引
* key_len:索引字段的长度
* rows:扫描出的行数(估算的行数)
* Extra:执行情况的描述和说明

### 重构查询方式

#### 1. 切分大查询

一个大查询如果一次性执行的话，可能一次锁住很多数据、占满整个事务日志、耗尽系统资源、阻塞很多小的但重要的查询。

```sql
DELETE FROM messages WHERE create < DATE_SUB(NOW(), INTERVAL 3 MONTH);
```

```sql
rows_affected = 0
do {
    rows_affected = do_query(
    "DELETE FROM messages WHERE create  < DATE_SUB(NOW(), INTERVAL 3 MONTH) LIMIT 10000")
} while rows_affected > 0
```

#### 2. 分解大连接查询

将一个大连接查询分解成对每一个表进行一次单表查询，然后在应用程序中进行关联，这样做的好处有：

- 让缓存更高效。对于连接查询，如果其中一个表发生变化，那么整个查询缓存就无法使用。而分解后的多个查询，即使其中一个表发生变化，对其它表的查询缓存依然可以使用。
- 分解成多个单表查询，这些单表查询的缓存结果更可能被其它查询使用到，从而减少冗余记录的查询。
- 减少锁竞争；
- 在应用层进行连接，可以更容易对数据库进行拆分，从而更容易做到高性能和可伸缩。
- 查询本身效率也可能会有所提升。例如下面的例子中，使用 IN() 代替连接查询，可以让 MySQL 按照 ID 顺序进行查询，这可能比随机的连接要更高效。

```sql
SELECT * FROM tag
JOIN tag_post ON tag_post.tag_id=tag.id
JOIN post ON tag_post.post_id=post.id
WHERE tag.tag='mysql';
```

```sql
SELECT * FROM tag WHERE tag='mysql';
SELECT * FROM tag_post WHERE tag_id=1234;
SELECT * FROM post WHERE post.id IN (123,456,567,9098,8904);
```



## 3.1 内存读取

### 增大缓存
* 将更新操作先记录在change buffer，减少读磁盘，语句的执行速度会得到明显的提升。而且，数据读入内存是需要占用buffer pool的，所以这种方式还能够避免占用内存，提高内存利用率
* innodb_buffer_pool_size。将数据完全保存在 innodb_buffer_pool中。可以完全从内存中读取数据，最大限度减少磁盘操作。

### 数据预热

默认情况，只有某条数据被读取一次，才会缓存在 innodb_buffer_pool。数据库启动后，需要进行数据预热，将磁盘上的所有数据缓存到内存中。数据预热可以提高读取速度。

```sql
SELECT DISTINCT
  CONCAT('SELECT ',ndxcollist,' FROM ',db,'.',tb,
  ' ORDER BY ',ndxcollist,';') SelectQueryToLoadCache
  FROM
  (
    SELECT
      engine,table_schema db,table_name tb,
      index_name,GROUP_CONCAT(column_name ORDER BY seq_in_index) ndxcollist
    FROM
    (
      SELECT
        B.engine,A.table_schema,A.table_name,
        A.index_name,A.column_name,A.seq_in_index
      FROM
        information_schema.statistics A INNER JOIN
        (
          SELECT engine,table_schema,table_name
          FROM information_schema.tables WHERE
          engine='InnoDB'
        ) B USING (table_schema,table_name)
      WHERE B.table_schema NOT IN ('information_schema','mysql')
      ORDER BY table_schema,table_name,index_name,seq_in_index
    ) A
    GROUP BY table_schema,table_name,index_name
  ) AA
ORDER BY db,tb;
```



## 3.2 减少磁盘读写

### 使用足够大的写入缓存innodb_log_file_size

* 如果用 1G 的 innodb_log_file_size ，假如服务器当机，需要 10 分钟来恢复。
* 推荐 innodb_log_file_size 设置为 0.25 * innodb_buffer_pool_size

### innodb_flush_log_at_trx_commit

这个选项和写磁盘操作密切相关：
```sql
innodb_flush_log_at_trx_commit = 1 则每次修改写入磁盘
innodb_flush_log_at_trx_commit = 0/2 每秒写入磁盘
```
如果你的应用不涉及很高的安全性 (金融系统)，或者基础架构足够安全，或者事务都很小，都可以用 0 或者 2 来降低磁盘操作。


## 3.3 提高磁盘读取速度



## 4 其他原则

1. 不在数据库做运算：cpu计算务必移至业务层
1. 控制单表数据量：单表记录控制在1000w
1. 控制列数量：字段数控制在20以内
1. 平衡范式与冗余：为提高效率牺牲范式设计，冗余数据
1. 拒绝3B：拒绝大sql，大事物，大批量