MySQL中常用的索引结构有：B+树索引和哈希索引两种。目前建表用的B+树索引就是BTREE索引。

在MySQL中，MyISAM和InnoDB两种存储引擎都不支持哈希索引。只有HEAP/MEMORY引擎才能显示支持哈希索引。

创建索引：

CREATE TABLE userInfo(
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(3) NOT NULL COMMENT '用户名',
  `age` int(10) NOT NULL COMMENT '年龄',
  `addr` varchar(40) NOT NULL COMMENT '地址',  
PRIMARY KEY (`id`), 
KEY `ind_user_info_username` (`username`) USING BTREE, --此处普通索引
key 'ind_user_info_username_addr' ('username_addr') USING BTREE, --此处联合索引
unique key(uid) USINGBTREE,  --此处唯一索引
key 'ind_user_info_addr' (addr(12)) USINGBTREE  —-此处 addr列只创建了最左12个字符长度的部分索引
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';
————————————————
版权声明：本文为CSDN博主「yanweihpu」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/yanweihpu/article/details/80254066


## 索引类型：

唯一索引、主键索引、外键索引、普通索引，复合索引

## 索引优化查询：

A、关联查询时，保证关联的字段都建立索引，并且字段类型一致，这样才能两个表都使用索引。如果字段类型不一样，至少一个表不能使用索引。

B、索引列如果使用like条件进行查询，那么 like 'xxx%' 可以使用索引，like '%xxx' 不能使用索引。

C、复合索引，如果创建了一个(username,age,addr)的复合索引，那么相当于创建了(username,age,addr)，(username,age)，(username)三个索引，所以在创建复合索引的时候应该将最常用的限制条件的列放在最左边，依次递减。

D、索引列的值最好不要有null值。列中只要包含null，则不会被包含到索引中，复合索引中只要有一列为null值，则这个复合索引失效的。所以创建索引列不要设置默认值null

E、字符串列加索引最好加短索引，即对前该列的前xx个字符，例如：key 'ind_user_info_addr' (addr(10)) USINGBTREE代表对addr列的前10个字符家索引。

F、如果where条件中使用了一个列的索引，那么后面order by 在用这个列进行排序时，便不会再使用索引。



## 数据库优化

6、数据库优化

关联查询中的inner join 和左连接、右连接、子查询
A、inner join 内连接也叫做等值连接，left/right join 是外连接。能用inner join连接的尽量用inner join连接

B、尽量使用外连接来替换子查询。

C、在使用on和where的时候，先用on，在用where。

D、使用join时，用小的结果驱动大的结果（left join左表结果尽量小，如果有条件，先放左边处理，right join同理反向）。

E、多表联合查询尽量拆分多个简单的sql语句进行查询。

建立索引，加快查询性能
A、where条件用到复合索引中的字段时，最好把该字段放在复合索引的左端，这样才能使用索引提高查询。

B、保证连接的索引是相同类型。即a.age = b.age，a表的和b表的age字段类型保证一样，并且都建立了索引。

C、在使用like一个字段的索引时，like 'xxx%'能用到索引，like '%xxx'不能用到索引。

D、复合索引的使用：如果我们建立了一个（name,age,addr）的复合索引，那么相当于创建了（name,age,addr）、（name,age）、（name）三个索引。这样就把常用的限制条件放到最左边，依次递减。

E、索引列不要包含NULL值的列。所以数据库设计时，尽量不让字段默认为NULL。

F、使用短索引，对于字符串的索引，应指定一个前缀长度，体积高查询速度并且可以节省磁盘空间和I/O操作。

G、排序索引。尽量不要使用包含多个列的排序，如果需要则给这些列加上复合索引。

limit千万级分页优化
A、select * from A order by id limit 1000000,10; 查询更换成select * from A where id between 1000000 and 1000010;

尽量避免select * 的查询
尽量不要使用BY RAND()命令
利用limit 1取得唯一行。使用limit 1可以终止数据库引擎继续扫描整个表或者索引
减少排序order by
少用OR
避免类型转换，也就是转入的参数类型要和字段类型一致
不要在列上进行运算。
尽量不要使用not in 和<> 操作
A、not in 和<>操作都不会使用索引，而是进行全表扫描。

B、把not in 转化为 left join 操作。

使用批量插入操作代替一个一个插入
对于多表查询可以建立视图。
7、数据库原则

（1）不在数据库做运算：cpu计算务必移至业务层

（2）控制单表数据量：单表记录控制在1000w

（3）控制列数量：字段数控制在20以内

（4）平衡范式与冗余：为提高效率牺牲范式设计，冗余数据

（5）拒绝3B：拒绝大sql，大事物，大批量