# MySQL事务管理

> 参考文献
> * [Mysql并发控制](https://zhuanlan.zhihu.com/p/133823461)

> 本章主要讲了MySQL的事务管理，即MySQL的并发控制，MySQL在并发过程中如何进行同步，即MySQL保证事物的原子性、隔离性、一致性、持久性的方法。也属于并发机制的一部分。


## 4 多级锁协议

### 封锁粒度

MySQL 各存储引擎使用了三种类型（级别）的锁定机制：表级锁定，行级锁定和页级锁定。

1. 表级锁定（table-level）
   表级别的锁定是 MySQL 各存储引擎中最大颗粒度的锁定机制。该锁定机制最大的特点是实现逻辑非常简单，带来的系统负面影响最小。所以获取锁和释放锁的速度很快。由于表级锁一次会将整个表锁定，所以可以很好的避免困扰我们的死锁问题。
   当然，锁定颗粒度大所带来最大的负面影响就是出现锁定资源争用的概率也会最高，致使并发度大打折扣。
   使用**表级锁定的主要是 MyISAM，MEMORY，CSV**等一些非事务性存储引擎。
2. 行级锁定（row-level）
   行级锁定最大的特点就是锁定对象的颗粒度很小，也是目前各大数据库管理软件所实现的锁定颗粒度最小的。由于锁定颗粒度很小，所以发生锁定资源争用的概率也最小，能够给予应用程序尽可能大的并发处理能力而提高一些需要高并发应用系统的整体性能。
   虽然能够在并发处理能力上面有较大的优势，但是行级锁定也因此带来了不少弊端。由于锁定资源的颗粒度很小，所以每次获取锁和释放锁需要做的事情也更多，带来的消耗自然也就更大了。此外，行级锁定也最容易发生死锁。
   使用**行级锁定的主要是 InnoDB 存储引擎**。
3. 页级锁定（page-level）
   页级锁定是 MySQL 中比较独特的一种锁定级别，在其他数据库管理软件中也并不是太常见。页级锁定的特点是锁定颗粒度介于行级锁定与表级锁之间，所以获取锁定所需要的资源开销，以及所能提供的并发处理能力也同样是介于上面二者之间。另外，页级锁定和行级锁定一样，会发生死锁。
   使用**页级锁定的主要是 BerkeleyDB 存储引擎**。

优缺点：

- 表级锁：开销小，加锁快；不会出现死锁；锁定粒度大，发生锁冲突的概率最高，并发度最低；
- 行级锁：开销大，加锁慢；会出现死锁；锁定粒度最小，发生锁冲突的概率最低，并发度也最高；
- 页面锁：开销和加锁时间界于表锁和行锁之间；会出现死锁；锁定粒度界于表锁和行锁之间，并发度一般。

适用场景：

- 从锁的角度来说，表级锁更适合于以查询为主，只有少量按索引条件更新数据的应用，如 Web 应用；而行级锁则更适合于有大量按索引条件并发更新少量不同数据，同时又有并发查询的应用，如一些在线事务处理（OLTP）系统。

注意事项：

- InnoDB 行锁是通过给索引上的索引项加锁来实现的，只有通过索引条件检索数据，InnoDB 才使用行级锁，否则，InnoDB 将使用表锁
- 由于 MySQL 的行锁是针对索引加的锁，不是针对记录加的锁，所以虽然是访问不同行的记录，但是如果是使用相同的索引键，是会出现锁冲突的。

### 封锁类型

可以说 InnoDB 的锁定模式实际上可以分为四种：共享锁（S），排他锁（X），意向共享锁（IS）和意向排他锁（IX）。意向锁是 InnoDB 自动加的，不需用户干预。

- 读写锁
  - 共享锁（Shared），简写为 S 锁，又称读锁。当一个事务需要给自己需要的某个资源加锁的时候，如果遇到一个共享锁正锁定着自己需要的资源的时候，自己可以再加一个共享锁，不过不能加排他锁。
  - 互斥锁（Exclusive），简写为 X 锁，又称写锁、独占锁。如果遇到自己需要锁定的资源已经被一个排他锁占有之后，则只能等待该锁定释放资源之后自己才能获取锁定资源并添加自己的锁定。
- 意向锁的作用就是当一个事务在需要获取资源锁定的时候，如果遇到自己需要的资源已经被排他锁占用的时候，该事务可以需要锁定行的表上面添加一个合适的意向锁。
  - 如果自己需要一个共享锁，那么就在表上面添加一个意向共享锁。
  - 而如果自己需要的是某行（或者某些行）上面添加一个排他锁的话，则先在表上面添加一个意向排他锁。意向共享锁可以同时并存多个，但是意向排他锁同时只能有一个存在。

### 封锁规则

读写锁有如下规定

- 一个事务对数据对象 A 加了 X 锁，就可以对 A 进行读取和更新。加锁期间其它事务不能对 A 加任何锁。
- 一个事务对数据对象 A 加了 S 锁，可以对 A 进行读取操作，但是不能进行更新操作。加锁期间其它事务能对 A 加 S 锁，但是不能加 X 锁。

意向锁在原来的 X/S 锁之上引入了 IX/IS，**IX/IS 都是表锁**，用来表示一个事务想要在表中的某个数据行上加 X 锁或 S 锁。主要是为了防止遍历整个行，判断是否有行级锁。有以下两个规定：

- 一个事务在获得某个数据行对象的 S 锁之前，必须先获得表的 IS 锁或者更强的锁；
- 一个事务在获得某个数据行对象的 X 锁之前，必须先获得表的 IX 锁。

![](image/2021-09-01-17-37-28.png)

- 任意 IS/IX 锁之间都是兼容的，因为它们只表示想要对表加锁，而不是真正加锁；
- 这里兼容关系针对的是表级锁，而表级的 IX 锁和行级的 X 锁兼容，两个事务可以对两个数据行加 X 锁。（事务 T<sub>1</sub> 想要对数据行 R<sub>1</sub> 加 X 锁，事务 T<sub>2</sub> 想要对同一个表的数据行 R<sub>2</sub> 加 X 锁，两个事务都需要对该表加 IX 锁，但是 IX 锁是兼容的，并且 IX 锁与行级的 X 锁也是兼容的，因此两个事务都能加锁成功，对同一个表中的两个数据行做修改。）

### 封锁协议

**一级封锁协议**

- 事务 T 要修改数据 A 时必须加 X 锁，直到 T 结束才释放锁。

- 可以解决丢失修改的问题，因为不能同时有两个事务对同一个数据进行修改，那么事务的修改就不会被覆盖。
  ![](image/2021-09-01-17-54-00.png)

**二级封锁协议**

- 在一级的基础上，要求读取数据 A 时必须加 S 锁，读取完马上释放 S 锁。

- 可以解决读脏数据问题，因为如果一个事务在对数据 A 进行修改，根据 1 级封锁协议，会加 X 锁，那么就不能再加 S 锁了，也就是不会读入数据。
  ![](image/2021-09-01-17-54-50.png)

**三级封锁协议**

- 在二级的基础上，要求读取数据 A 时必须加 S 锁，直到事务结束了才能释放 S 锁。

- 可以解决不可重复读的问题，因为读 A 时，其它事务不能对 A 加 X 锁，从而避免了在读的期间数据发生改变。

![](image/2021-09-01-17-55-26.png)

**两段锁协议**

- 加锁和解锁分为两个阶段进行。

- 可串行化调度是指，通过并发控制，使得并发执行的事务结果与某个串行执行的事务结果相同。串行执行的事务互不干扰，不会出现并发一致性问题。

![](image/2021-09-01-18-26-00.png)

事务遵循两段锁协议是保证可串行化调度的充分条件。例如以下操作满足两段锁协议，它是可串行化调度。

```html
lock-x(A)...lock-s(B)...lock-s(C)...unlock(A)...unlock(C)...unlock(B)
```

但不是必要条件，例如以下操作不满足两段锁协议，但它还是可串行化调度。

```html
lock-x(A)...unlock(A)...lock-s(B)...unlock(B)...lock-s(C)...unlock(C)
```

**隐式与显示锁定**

- MySQL 的 InnoDB 存储引擎采用两段锁协议，会根据隔离级别在需要的时候自动加锁，并且所有的锁都是在同一时刻被释放，这被称为隐式锁定。

- InnoDB 也可以使用特定的语句进行显示锁定：

```sql
SELECT ... LOCK In SHARE MODE;
SELECT ... FOR UPDATE;
```

## 5 多版本并发控制 MVCC


### 原理

**数据库并发的三种场景**
* 读读之间不存在冲突，无须加锁。
* 写写之间的冲突需要严格隔离，必须加锁。有线程安全问题。
* 读写之间的冲突导致了脏读、不可重复读、幻影读等问题。有线程安全问题。


**MVCC带来的好处**

* 在并发读写数据库时，可以做到在读操作时不用阻塞写操作，写操作也不用阻塞读操作，提高了数据库并发读写的性能
* 同时还可以解决脏读，幻读，不可重复读等事务隔离问题，但不能解决更新丢失问题

### 定义

**多版本并发控制**（Multi-Version Concurrency Control, MVCC）是 是一种并发控制的方法，一般在数据库管理系统中，实现对数据库的并发访问，在编程语言中实现事务内存。

- MySQL 的 InnoDB 存储引擎实现隔离级别的一种具体方式，用于实现提交读和可重复读这两种隔离级别。
- 未提交读隔离级别总是读取最新的数据行，要求很低，无需使用 MVCC。
- 可串行化隔离级别需要对所有读取的行都加锁，单纯使用 MVCC 无法实现。

**当前读**:它读取的是记录的最新版本，读取时还要保证其他并发事务不能修改当前记录，会对读取的记录进行加锁。MVCC 会对数据库进行修改的操作（INSERT、UPDATE、DELETE）需要进行加锁操作，从而读取最新的数据。可以看到 MVCC 并不是完全不用加锁，而只是避免了 SELECT 的读加锁操作。

**快照读**：不加锁的select操作就是快照读，即不加锁的非阻塞读；MVCC 的 SELECT 操作是快照中的数据，不需要进行加锁操作。

**版本号**：MVCC 用来实现版本控制的序号

- 系统版本号 SYS_ID：是一个递增的数字，每开始一个新的事务，系统版本号就会自动递增。
- 事务版本号 TRX_ID ：事务开始时的系统版本号。

**实现手段**
* 隐式字段
* Undo日志
* ReadView

### 隐式字段

InnoDB 的 MVCC,是通过在每行记录后面保存**两个隐藏的列**来实现的,这两个列，分别保存了这个行的创建时间，一个保存的是行的删除时间。
* 创建时间（事务版本）
* 删除时间（事务版本）
* 回滚指针（指向上一个事务版本号）

这里存储的并不是实际的时间值,而是系统版本号(可以理解为事务的 ID)，每开始一个新的事务，系统版本号就会自动递增，事务开始时刻的系统版本号会作为事务的 ID.



### Undo日志

Undolog主要分为两种
* insert undo log。代表事务在insert新记录时产生的undo log, 只在事务回滚时需要，并且在事务提交后可以被立即丢弃
* update undo log。事务在进行update或delete时产生的undo log; 不仅在事务回滚时需要，在快照读时也需要；所以不能随便删除，只有在快速读或事务回滚不涉及该日志时，对应的日志才会被purge线程统一清除

MVCC 的多版本指的是多个版本的快照，快照存储在 Undo 日志中，该日志通过回滚指针 ROLL_PTR 把一个数据行的所有快照连接起来。

例如在 MySQL 创建一个表 t，包含主键 id 和一个字段 x。我们先插入一个数据行，然后对该数据行执行两次更新操作。

```sql
INSERT INTO t(id, x) VALUES(1, "a");
UPDATE t SET x="b" WHERE id=1;
UPDATE t SET x="c" WHERE id=1;
```

因为没有使用 `START TRANSACTION` 将上面的操作当成一个事务来执行，根据 MySQL 的 AUTOCOMMIT 机制，每个操作都会被当成一个事务来执行，所以上面的操作总共涉及到三个事务。快照中除了记录事务版本号 TRX_ID 和操作之外，还记录了一个 bit 的 DEL 字段，用于标记是否被删除。
![](image/2021-09-01-20-40-19.png)

INSERT、UPDATE、DELETE 操作会创建一个日志，并将事务版本号 TRX_ID 写入。DELETE 可以看成是一个特殊的 UPDATE，还会额外将 DEL 字段设置为 1。

### ReadView
在该事务执行的快照读的那一刻，会生成数据库系统当前的一个快照，记录并维护系统当前活跃事务的ID

Read View主要是用来做可见性判断的, 即当我们某个事务执行快照读的时候，对该记录创建一个Read View读视图，把它比作条件用来判断当前事务能够看到哪个版本的数据。

MVCC 维护了一个 ReadView 结构，主要包含了当前系统未提交的事务列表 TRX_IDs {TRX_ID_1, TRX_ID_2, ...}，还有该列表的最小值 TRX_ID_MIN 和 TRX_ID_MAX。
![](image/2021-09-01-20-40-30.png)

在进行 SELECT 操作时，根据数据行快照的 TRX_ID 与 TRX_ID_MIN 和 TRX_ID_MAX 之间的关系，从而判断数据行快照是否可以使用：

- TRX_ID \< TRX_ID_MIN，表示该数据行快照时在当前所有未提交事务之前进行更改的，因此可以使用。

- TRX_ID \> TRX_ID_MAX，表示该数据行快照是在事务启动之后被更改的，因此不可使用。
- TRX_ID_MIN \<= TRX_ID \<= TRX_ID_MAX，需要根据隔离级别再进行判断：
  - 提交读：如果 TRX_ID 在 TRX_IDs 列表中，表示该数据行快照对应的事务还未提交，则该快照不可使用。否则表示已经提交，可以使用。
  - 可重复读：都不可以使用。因为如果可以使用的话，那么其它事务也可以读到这个数据行快照并进行修改，那么当前事务再去读这个数据行得到的值就会发生改变，也就是出现了不可重复读问题。

在数据行快照不可使用的情况下，需要沿着 Undo Log 的回滚指针 ROLL_PTR 找到下一个快照，再进行上面的判断。


**purge**

* 从前面的分析可以看出，为了实现InnoDB的MVCC机制，更新或者删除操作都只是设置一下老记录的deleted_bit，并不真正将过时的记录删除。
* 为了节省磁盘空间，InnoDB有专门的purge线程来清理deleted_bit为true的记录。为了不影响MVCC的正常工作，purge线程自己也维护了一个read view（这个read view相当于系统中最老活跃事务的read view）;如果某个记录的deleted_bit为true，并且DB_TRX_ID相对于purge线程的read view可见，那么这条记录一定是可以被安全清除的。

## 6 间隙锁 Next-Key Locks

Next-Key Locks 是 MySQL 的 InnoDB 存储引擎的一种锁实现。

MVCC 不能解决幻影读问题，Next-Key Locks 就是为了解决这个问题而存在的。在可重复读（REPEATABLE READ）隔离级别下，使用 MVCC + Next-Key Locks 可以解决幻读问题。

### Record Locks

锁定一个记录上的索引，而不是记录本身。

如果表没有设置索引，InnoDB 会自动在主键上创建隐藏的聚簇索引，因此 Record Locks 依然可以使用。

### Gap Locks

锁定索引之间的间隙，但是不包含索引本身。例如当一个事务执行以下语句，其它事务就不能在 t.c 中插入 15。

```sql
SELECT c FROM t WHERE c BETWEEN 10 and 20 FOR UPDATE;
```

### Next-Key Locks

它是 Record Locks 和 Gap Locks 的结合，不仅锁定一个记录上的索引，也锁定索引之间的间隙。它锁定一个前开后闭区间，例如一个索引包含以下值：10, 11, 13, and 20，那么就需要锁定以下区间：

```sql
(-∞, 10]
(10, 11]
(11, 13]
(13, 20]
(20, +∞)
```


## 7 MVCC实例

下面看一下在 REPEATABLE READ 隔离级别下,MVCC 具体是如何操作的。
### 实现方法——Insert(1)

InnoDB 为新插入的每一行保存当前系统版本号作为版本号.

**第一个事务ID为1**

```sql
start transaction;
insert into yang values(NULL,'yang') ;
insert into yang values(NULL,'long');
insert into yang values(NULL,'fei');
commit;
```

<table>
<thead>
<tr><th>id</th><th>name</th><th>创建时间(事务ID)</th><th>删除时间(事务ID)</th></tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>yang</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>2</td>
<td>long</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>3</td>
<td>fei</td>
<td>1</td>
<td>undefined</td>
</tr>
</tbody>
</table>

### 实现方法——Select(2)

InnoDB 会根据以下两个条件检查每行记录，只有满足一下两个条件，才能作为结果返回:

- InnoDB 只会查找版本早于当前事务版本的数据行(也就是,行的系统版本号小于或等于事务的系统版本号)，这样可以确保事务读取的行，要么是在事务开始前已经存在的，要么是事务自身插入或者修改过的.
- 行的删除版本要么未定义,要么大于当前事务版本号,这可以确保事务读取到的行，在事务开始之前未被删除.

**第二个事务,ID 为 2**

```
start transaction;
select * from yang;  //(1)
select * from yang;  //(2)
commit;
```
此时执行(1)中的内容，得到如下的表内容：
<table>
<thead>
<tr><th>id</th><th>name</th><th>创建时间(事务ID)</th><th>删除时间(事务ID)</th></tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>yang</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>2</td>
<td>long</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>3</td>
<td>fei</td>
<td>1</td>
<td>undefined</td>
</tr>
</tbody>
</table>
### 实现方法——Insert(3)

- InnoDB 会为删除的每一行保存当前系统的版本号(事务的 ID)作为删除标识.

- 假设在执行这个事务 ID 为 2 的过程中,刚执行到(1),这时,有另一个事务 ID 为 3 往这个表里插入了一条数据;

**第三个事务 ID 为 3;**

```sql
start transaction;
insert into yang values(NULL,'tian');
commit;
```

这时表中的数据如下

<table>
<thead>
<tr><th>id</th><th>name</th><th>创建时间(事务ID)</th><th>删除时间(事务ID)</th></tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>yang</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>2</td>
<td>long</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>3</td>
<td>fei</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>4</td>
<td>tian</td>
<td>3</td>
<td>undefined</td>
</tr>
</tbody>
</table>

然后接着执行事务 2 中的(2),由于 id=4 的数据的创建时间(事务 ID 为 3),执行当前事务的 ID 为 2,而 InnoDB 只会查找事务 ID 小于等于当前事务 ID 的数据行,所以 id=4 的数据行并不会在执行事务 2 中的(2)被检索出来,在事务 2 中的两条 select 语句检索出来的数据都只会下表:

<table>
<thead>
<tr><th>id</th><th>name</th><th>创建时间(事务ID)</th><th>删除时间(事务ID)</th></tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>yang</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>2</td>
<td>long</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>3</td>
<td>fei</td>
<td>1</td>
<td>undefined</td>
</tr>
</tbody>
</table>

### 实现方法——DELETE(4)

假设在执行这个事务 ID 为 2 的过程中,刚执行到(1),假设事务执行完事务 3 后，接着又执行了事务 4;

**第四个事务，ID为4**

```sql
start   transaction;
delete from yang where id=1;
commit;
```

此时数据表如下：

<table>
<thead>
<tr><th>id</th><th>name</th><th>创建时间(事务ID)</th><th>删除时间(事务ID)</th></tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>yang</td>
<td>1</td>
<td>4</td>
</tr>
<tr>
<td>2</td>
<td>long</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>3</td>
<td>fei</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>4</td>
<td>tian</td>
<td>3</td>
<td>undefined</td>
</tr>
</tbody>
</table>

接着执行事务 ID 为 2 的事务(2),根据 SELECT 检索条件可以知道,它会检索创建时间(创建事务的 ID)小于当前事务 ID 的行和删除时间(删除事务的 ID)大于当前事务的行,而 id=4 的行上面已经说过,而 id=1 的行由于删除时间(删除事务的 ID)大于当前事务的 ID,所以事务 2 的(2)select \* from yang 也会把 id=1 的数据检索出来.所以,事务 2 中的两条 select 语句检索出来的数据都如下:

<table>
<thead>
<tr><th>id</th><th>name</th><th>创建时间(事务ID)</th><th>删除时间(事务ID)</th></tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>yang</td>
<td>1</td>
<td>4</td>
</tr>
<tr>
<td>2</td>
<td>long</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>3</td>
<td>fei</td>
<td>1</td>
<td>undefined</td>
</tr>
</tbody>
</table>

### 实现方法——Update(5)

InnoDB 执行 UPDATE，实际上是新插入了一行记录，并保存其创建时间为当前事务的 ID，同时保存当前事务 ID 到要 UPDATE 的行的删除时间.

假设在执行完事务 2 的(1)后又执行,其它用户执行了事务 3,4,这时，又有一个用户对这张表执行了 UPDATE 操作:
**第 5 个事务，ID为5**

```
start  transaction;
update yang set name='Long' where id=2;
commit;
```

根据 update 的更新原则:会生成新的一行,并在原来要修改的列的删除时间列上添加本事务 ID,得到表如下:

<table>
<thead>
<tr><th>id</th><th>name</th><th>创建时间(事务ID)</th><th>删除时间(事务ID)</th></tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>yang</td>
<td>1</td>
<td>4</td>
</tr>
<tr>
<td>2</td>
<td>long</td>
<td>1</td>
<td>5</td>
</tr>
<tr>
<td>3</td>
<td>fei</td>
<td>1</td>
<td>undefined</td>
</tr>
<tr>
<td>4</td>
<td>tian</td>
<td>3</td>
<td>undefined</td>
</tr>
<tr>
<td>2</td>
<td>Long</td>
<td>5</td>
<td>undefined</td>
</tr>
</tbody>
</table>

继续执行事务 2 的(2),根据 select 语句的检索条件,得到下表:

<table>
<thead>
<tr><th>id</th><th>name</th><th>创建时间(事务ID)</th><th>删除时间(事务ID)</th></tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>yang</td>
<td>1</td>
<td>4</td>
</tr>
<tr>
<td>2</td>
<td>long</td>
<td>1</td>
<td>5</td>
</tr>
<tr>
<td>3</td>
<td>fei</td>
<td>1</td>
<td>undefined</td>
</tr>
</tbody>
</table>

还是和事务 2 中(1)select 得到相同的结果.
