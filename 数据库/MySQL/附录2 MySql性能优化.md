# 10个MySQL性能调优的方法
> 参考文献
> * [https://www.jb51.net/article/70111.htm](https://www.jb51.net/article/70111.htm)
> * [https://www.cnblogs.com/jiekzou/p/5371085.html](https://www.cnblogs.com/jiekzou/p/5371085.html)

## 0 基础方法

1. 数据库设计优化：
   1. 选择合适的存储引擎
   2. 设计合理的表结构(符合3NF)
   3. 添加适当索引(index) [四种: 普通索引、主键索引、唯一索引unique、全文索引]
2. 查询语句优化：
   1. 通过show status命令了解各种SQL的执行频率。
   2. 定位执行效率较低的SQL语句-（重点select，记录慢查询）
   3. 通过explain分析低效率的SQL
3. 查询过程优化
   1. 从内存中读取数据
   2. 减少磁盘写入操作(更大的写缓存)
   3. 提高磁盘读取速度
## 1 选择合适的存储引擎: InnoDB

* 除非你的数据表使用来做只读或者全文检索 (相信现在提到全文检索，没人会用 MYSQL 了)，你应该默认选择 InnoDB 。

* 你自己在测试的时候可能会发现 MyISAM 比 InnoDB 速度快，这是因为： MyISAM 只缓存索引，而 InnoDB 缓存数据和索引，MyISAM 不支持事务。但是 如果你使用 innodb_flush_log_at_trx_commit = 2 可以获得接近的读取性能 (相差百倍) 。

### 1.1 如何将现有的 MyISAM 数据库转换为 InnoDB:

```
mysql -u [USER_NAME] -p -e "SHOW TABLES IN [DATABASE_NAME];" | tail -n +2 | xargs -I '{}' echo "ALTER TABLE {} ENGINE=InnoDB;" > alter_table.sql

perl -p -i -e 's/(search_[a-z_]+ ENGINE=)InnoDB//1MyISAM/g' alter_table.sql

mysql -u [USER_NAME] -p [DATABASE_NAME] < alter_table.sql

mysql -u [USER_NAME] -p -e "SHOW TABLES IN [DATABASE_NAME];" | tail -n +2 | xargs -I '{}' echo "ALTER TABLE {} ENGINE=InnoDB;" > alter_table.sql

perl -p -i -e 's/(search_[a-z_]+ ENGINE=)InnoDB//1MyISAM/g' alter_table.sql

mysql -u [USER_NAME] -p [DATABASE_NAME] < alter_table.sql
```
### 1.2 为每个表分别创建 InnoDB FILE：

```
innodb_file_per_table=1
```
这样可以保证 ibdata1 文件不会过大，失去控制。尤其是在执行 mysqlcheck -o –all-databases 的时候。

 

## 2. 保证从内存中读取数据，讲数据保存在内存中

### 2.1 足够大的 innodb_buffer_pool_size

推荐将数据完全保存在 innodb_buffer_pool_size ，即按存储量规划 innodb_buffer_pool_size 的容量。这样你可以完全从内存中读取数据，最大限度减少磁盘操作。

第一步：如何确定 innodb_buffer_pool_size 足够大，数据是从内存读取而不是硬盘？

查询buffer size
```
mysql> SHOW GLOBAL STATUS LIKE 'innodb_buffer_pool_pages_%';
+----------------------------------+--------+
| Variable_name          | Value |
+----------------------------------+--------+
| Innodb_buffer_pool_pages_data  | 129037 |
| Innodb_buffer_pool_pages_dirty  | 362  |
| Innodb_buffer_pool_pages_flushed | 9998  |
| Innodb_buffer_pool_pages_free  | 0   | !!!!!!!!
| Innodb_buffer_pool_pages_misc  | 2035  |
| Innodb_buffer_pool_pages_total  | 131072 |
+----------------------------------+--------+
6 rows in set (0.00 sec)

innodb_additional_mem_pool_size = 1/200 of buffer_pool
innodb_max_dirty_pages_pct 80%
```
发现 Innodb_buffer_pool_pages_free 为 0，则说明 buffer pool 已经被用光，需要增大 innodb_buffer_pool_size

或者用iostat -d -x -k 1 命令，查看硬盘的操作。

第二步：服务器上是否有足够内存用来规划。执行 echo 1 > /proc/sys/vm/drop_caches 清除操作系统的文件缓存，可以看到真正的内存使用量。

### 2.2 数据预热

默认情况，只有某条数据被读取一次，才会缓存在 innodb_buffer_pool。所以，数据库刚刚启动，需要进行数据预热，将磁盘上的所有数据缓存到内存中。数据预热可以提高读取速度。

对于 InnoDB 数据库，可以用以下方法，进行数据预热:

1. 将以下脚本保存为 MakeSelectQueriesToLoad.sql

```
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
2. 执行
```
mysql -uroot -AN < /root/MakeSelectQueriesToLoad.sql > /root/SelectQueriesToLoad.sql
```
3. 每次重启数据库，或者整库备份前需要预热的时候执行：
```
mysql -uroot < /root/SelectQueriesToLoad.sql > /dev/null 2>&1
```

### 2.3 不要让数据存到 SWAP 中

如果是专用 MYSQL 服务器，可以禁用 SWAP，如果是共享服务器，确定 innodb_buffer_pool_size 足够大。或者使用固定的内存空间做缓存，使用 memlock 指令。

 

## 3 定期优化重建数据库

mysqlcheck -o –all-databases 会让 ibdata1 不断增大，真正的优化只有重建数据表结构：
```
CREATE TABLE mydb.mytablenew LIKE mydb.mytable;
INSERT INTO mydb.mytablenew SELECT * FROM mydb.mytable;
ALTER TABLE mydb.mytable RENAME mydb.mytablezap;
ALTER TABLE mydb.mytablenew RENAME mydb.mytable;
DROP TABLE mydb.mytablezap;
```

## 4 减少磁盘写入操作

### 4.1 使用足够大的写入缓存 innodb_log_file_size

但是需要注意如果用 1G 的 innodb_log_file_size ，假如服务器当机，需要 10 分钟来恢复。

推荐 innodb_log_file_size 设置为 0.25 * innodb_buffer_pool_size

### 4.2 innodb_flush_log_at_trx_commit

这个选项和写磁盘操作密切相关：

innodb_flush_log_at_trx_commit = 1 则每次修改写入磁盘
innodb_flush_log_at_trx_commit = 0/2 每秒写入磁盘

如果你的应用不涉及很高的安全性 (金融系统)，或者基础架构足够安全，或者 事务都很小，都可以用 0 或者 2 来降低磁盘操作。

### 4.3 避免双写入缓冲
```
innodb_flush_method=O_DIRECT
``` 

## 5 提高磁盘读写速度

RAID0 尤其是在使用 EC2 这种虚拟磁盘 (EBS) 的时候，使用软 RAID0 非常重要。

 

## 6 充分使用索引

### 6.1 查看现有表结构和索引
```
SHOW CREATE TABLE db1.tb1/G
```
### 6.2 添加必要的索引

索引是提高查询速度的唯一方法，比如搜索引擎用的倒排索引是一样的原理。

索引的添加需要根据查询来确定，比如通过慢查询日志或者查询日志,或者通过 EXPLAIN 命令分析查询。

```
ADD UNIQUE INDEX
ADD INDEX
```

### 6.3 实例：优化用户验证表：
添加索引

```
ALTER TABLE users ADD UNIQUE INDEX username_ndx (username);
ALTER TABLE users ADD UNIQUE INDEX username_password_ndx (username,password);
```
每次重启服务器进行数据预热
```
echo “select username,password from users;” > /var/lib/mysql/upcache.sql
```
添加启动脚本到 my.cnf
```
[mysqld]
init-file=/var/lib/mysql/upcache.sql
```
### 6.4 实例：使用自动加索引的框架或者自动拆分表结构的框架
比如，Rails 这样的框架，会自动添加索引，Drupal 这样的框架会自动拆分表结构。会在你开发的初期指明正确的方向。所以，经验不太丰富的人一开始就追求从 0 开始构建，实际是不好的做法。

## 7 分析查询日志和慢查询日志
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

### explain查询语句

Explain select * from emp where ename=“wsrcla”
会产生如下信息：
select_type:表示查询的类型。
table:输出结果集的表
type:表示表的连接类型
possible_keys:表示查询时，可能使用的索引
key:表示实际使用的索引
key_len:索引字段的长度
rows:扫描出的行数(估算的行数)
Extra:执行情况的描述和说明

## 8 激进的方法，使用内存磁盘

现在基础设施的可靠性已经非常高了，比如 EC2 几乎不用担心服务器硬件当机。而且内存实在是便宜，很容易买到几十G内存的服务器，可以用内存磁盘，定期备份到磁盘。

将 MYSQL 目录迁移到 4G 的内存磁盘
```
mkdir -p /mnt/ramdisk
sudo mount -t tmpfs -o size=4000M tmpfs /mnt/ramdisk/
mv /var/lib/mysql /mnt/ramdisk/mysql
ln -s /tmp/ramdisk/mysql /var/lib/mysql
chown mysql:mysql mysql
```
## 9 用 NOSQL 的方式使用 MYSQL

B-TREE 仍然是最高效的索引之一，所有 MYSQL 仍然不会过时。

用 HandlerSocket 跳过 MYSQL 的 SQL 解析层，MYSQL 就真正变成了 NOSQL。

## 10 其他

1. 单条查询最后增加 LIMIT 1，停止全表扫描。
2. 将非”索引”数据分离，比如将大篇文章分离存储，不影响其他自动查询。
3. 不用 MYSQL 内置的函数，因为内置函数不会建立查询缓存。
4. PHP 的建立连接速度非常快，所有可以不用连接池，否则可能会造成超过连接数。当然不用连接池 PHP 程序也可能将
5. 连接数占满比如用了 @ignore_user_abort(TRUE);
6. 使用 IP 而不是域名做数据库路径，避免 DNS 解析问题




”建立合理索引”(什么样的索引合理?) “
分表分库”(用什么策略分表分库?)
“主从分离”(用什么中间件?)