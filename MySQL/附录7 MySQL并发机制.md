
## 1 并发机制

1. 什么是并发，并发与多线程有什么关系？

1. 先从广义上来说，或者从实际场景上来说.
   1. 高并发通常是海量用户同时访问(比如：12306买票、淘宝的双十一抢购)，如果把一个用户看做一个线程的话那么并发可以理解成多线程同时访问，高并发即海量线程同时访问。（ps：我们在这里模拟高并发可以for循环多个线程即可）

2. 从代码或数据的层次上来说。多个线程同时在一条相同的数据上执行多个数据库操作。

## 2 如何避免并发冲突
> 参考文献
> * [锁与并发](https://www.cnblogs.com/yaopengfei/p/8399358.html)
### 积极并发（乐观锁）
积极并发(乐观并发、乐观锁)：无论何时从数据库请求数据，数据都会被读取并保存到应用内存中。数据库级别没有放置任何显式锁。数据操作会按照数据层接收到的先后顺序来执行。

积极并发本质就是允许冲突发生，然后在代码本身采取一种合理的方式去解决这个并发冲突，常见的方式有：

1. 忽略冲突强制更新：数据库会保存最后一次更新操作(以更新为例)，会损失很多用户的更新操作。
2. 部分更新：允许所有的更改，但是不允许更新完整的行，只有特定用户拥有的列更新了。这就意味着，如果两个用户更新相同的记录但却不同的列，那么这两个更新都会成功，而且来自这两个用户的更改都是可见的。（EF默认实现不了这种情况）
3. 询问用户：当一个用户尝试更新一个记录时，但是该记录自从他读取之后已经被别人修改了，这时应用程序就会警告该用户该数据已经被某人更改了，然后询问他是否仍然要重写该数据还是首先检查已经更新的数据。(EF可以实现这种情况，在后面详细介绍)
4. 拒绝修改：当一个用户尝试更新一个记录时，但是该记录自从他读取之后已经被别人修改了，此时告诉该用户不允许更新该数据，因为数据已经被某人更新了。


### 消极并发（悲观锁）

消极并发(悲观并发、悲观锁)：无论何时从数据库请求数据，数据都会被读取，然后该数据上就会加锁，因此没有人能访问该数据。这会降低并发出现问题的机会，缺点是加锁是一个昂贵的操作，会降低整个应用程序的性能。

消极并发的本质就是永远不让冲突发生，通常的处理凡是是只读锁和更新锁。

1. 当把只读锁放到记录上时，应用程序只能读取该记录。如果应用程序要更新该记录，它必须获取到该记录上的更新锁。如果记录上加了只读锁，那么该记录仍然能够被想要只读锁的请求使用。然而，如果需要更新锁，该请求必须等到所有的只读锁释放。同样，如果记录上加了更新锁，那么其他的请求不能再在这个记录上加锁，该请求必须等到已存在的更新锁释放才能加锁。总结，这里我们可以简单理解把并发业务部分用一个锁（如：lock,实质是数据库锁，后面章节单独介绍）锁住，使其同时只允许一个线程访问即可。

2. 加锁会带来很多弊端：
   1. 应用程序必须管理每个操作正在获取的所有锁；
   2. 加锁机制的内存需求会降低应用性能
   3. 多个请求互相等待需要的锁，会增加死锁的可能性。



## 3 并发问题的解决方案（提高并发的方法）

### 并发机制的解决方案

Java访问MySQL并发锁的实现通常使用JDBC（Java Database Connectivity）进行数据库连接和操作。在并发情况下，为了保证数据的一致性和可靠性，MySQL提供了多种锁机制来控制并发访问。

1. 在代码中实现线性操作。如果是单节点，则可以通过读写锁（ReentrantLock）让修改先后发生，读写锁是一种比普通锁更加高效的并发锁，它允许多个线程同时读取数据，但只允许一个线程写入数据。在Java中，可以使用ReentrantLock来实现读写锁。如果是多节点可以通过消息队列放到同一个队列中，然后线性消费。会大大降低并发程度

1. 乐观锁（Optimistic Locking）：乐观锁是一种基于版本号的并发控制机制，通过冲突和重试来保证并发更新的执行。它假设并发操作是“乐观”的，即不会频繁发生冲突，只有在提交更新时才会检查冲突。在MySQL中，可以使用SELECT语句的FOR UPDATE子句来实现乐观锁。

3. 悲观锁（Pessimistic Locking）：悲观锁是一种基于锁的并发控制机制，它假设并发操作是“悲观”的，即一定会发生冲突，因此在访问数据时立即加锁。在Java中，可以使用Connection的commit()和rollback()方法来实现悲观锁。

> 在数据库中，如果不开启事务，一条SQL语句默认就是一个事务，所有的操作要么成功要么全部失败。所以，update a_table set count = count+1 where id =1 这条语句是能够保证并发一致性更新的。

### 代码中的线性化

```java
import java.util.concurrent.locks.ReentrantLock;

public class MySQLReadWriteLock {
    private final ReentrantLock readLock = new ReentrantLock();
    private final ReentrantLock writeLock = new ReentrantLock();
    private final Condition readCondition = readLock.newCondition();
    private final Condition writeCondition = writeLock.newCondition();

    public void readOperation() {
        readLock.lock();
        try {
            // 执行读操作
            // ...
            readCondition.signalAll();
        } finally {
            readLock.unlock();
        }
    }

    public void writeOperation() {
        writeLock.lock();
        try {
            // 执行写操作
            // ...
            writeCondition.signalAll();
        } finally {
            writeLock.unlock();
        }
    }
}
```

### 乐观锁的实现


```java

// 读取数据
public User readUserById(int userId) {
    User user = jdbcTemplate.queryForObject("SELECT * FROM users WHERE id=?", new Object[]{userId}, new UserRowMapper());
    return user;
}

// 更新数据，在外层实现重试
public void updateUser(User user) {
    int rows = jdbcTemplate.update("UPDATE users SET name=?, age=?, version=? WHERE id=? AND version=?", user.getName(), user.getAge(), user.getVersion(), user.getId(), user.getVersion());
    if (rows == 1) {
        user.setName(user.getName());
        user.setAge(user.getAge());
        user.setVersion(user.getVersion() + 1);
    } else {
        throw new OptimisticLockException("Data has been modified by others.");
    }
}
```


### 悲观锁的实现

在查询数据时立即加锁，其他会话在查询到该数据时会阻塞，直到锁被释放。当更新数据时，会检查锁是否被其他会话占用，如果占用则更新失败。

```java
// 读取数据
public User readUserById(int userId) throws OptimisticLockException {
    String sql = "SELECT * FROM users WHERE id=? FOR UPDATE";
    User user = jdbcTemplate.queryForObject(sql, new Object[]{userId}, new UserRowMapper());
    return user;
}

// 更新数据
public void updateUser(User user) throws OptimisticLockException {
    String sql = "UPDATE users SET name=?, age=?,WHERE id=?";
    int rows = jdbcTemplate.update(sql, user.getName(), user.getAge(), user.getVersion(), user.getId(), user.getVersion());
    if (rows == 1) {
        user.setName(user.getName());
        user.setAge(user.getAge());
        user.setVersion(user.getVersion() + 1);
    } else {
        throw new OptimisticLockException("Data has been modified by others.");
    }
}

// 使用事务处理
public User updateUserWithTransaction(int userId) throws SQLException {
    User user = selectUserById(userId);
    updateUser(user);
    return user;
}
```