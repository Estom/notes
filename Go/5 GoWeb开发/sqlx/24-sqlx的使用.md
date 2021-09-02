原文链接：[sqlx库使用指南](https://www.liwenzhou.com/posts/Go/sqlx/)

视频链接：[p138](https://www.bilibili.com/video/BV17Q4y1P7n9?p=138)

在项目中我们通常可能会使用 `database/sql` 连接 MySQL 数据库。本文借助**使用 sqlx 实现批量插入数据**的例子，介绍了 sqlx 中可能被你忽视了的 `sqlx.In` 和 `DB.NamedExec` 方法。

## 24.1 sqlx 介绍

在项目中我们通常可能会使用 `database/sql` 连接 MySQL 数据库。`sqlx`可以认为是 Go 语言内置`database/sql` 的超集，它在优秀的内置 `database/sql` 基础上提供了一组扩展。这些扩展中除了大家常用来查询的 `Get(dest interface{}, ...) error` 和 `Select(dest interface{}, ...) error` 外还有很多其他强大的功能。

## 24.2 安装 sqlx

```
go get github.com/jmoiron/sqlx
```

## 24.3 基本使用

### 24.3.1 连接数据库

```go
var db *sqlx.DB

func initDB() (err error) {
	dsn := "user:password@tcp(127.0.0.1:3306)/sql_test?charset=utf8mb4&parseTime=True"
	// 也可以使用MustConnect连接不成功就panic
	db, err = sqlx.Connect("mysql", dsn)
	if err != nil {
		fmt.Printf("connect DB failed, err:%v\n", err)
		return
	}
	db.SetMaxOpenConns(20)
	db.SetMaxIdleConns(10)
	return
}
```

### 24.3.2 查询

#### 24.3.2.1 查询单行数据示例代码如下：

```go
// 查询单条数据示例
func queryRowDemo() {
	sqlStr := "select id, name, age from user where id=?"
	var u user
	err := db.Get(&u, sqlStr, 1)
	if err != nil {
		fmt.Printf("get failed, err:%v\n", err)
		return
	}
	fmt.Printf("id:%d name:%s age:%d\n", u.ID, u.Name, u.Age)
}
```

#### 24.3.2.2 查询多行数据示例代码如下：

```go
// 查询多条数据示例
func queryMultiRowDemo() {
	sqlStr := "select id, name, age from user where id > ?"
	var users []user
	err := db.Select(&users, sqlStr, 0)
	if err != nil {
		fmt.Printf("query failed, err:%v\n", err)
		return
	}
	fmt.Printf("users:%#v\n", users)
}
```

### 24.3.3 插入、更新和删除

sqlx 中的 exec 方法与原生 sql 中的 exec 使用基本一致：

```go
// 插入数据
func insertRowDemo() {
	sqlStr := "insert into user(name, age) values (?,?)"
	ret, err := db.Exec(sqlStr, "沙河小王子", 19)
	if err != nil {
		fmt.Printf("insert failed, err:%v\n", err)
		return
	}
	theID, err := ret.LastInsertId() // 新插入数据的id
	if err != nil {
		fmt.Printf("get lastinsert ID failed, err:%v\n", err)
		return
	}
	fmt.Printf("insert success, the id is %d.\n", theID)
}

// 更新数据
func updateRowDemo() {
	sqlStr := "update user set age=? where id = ?"
	ret, err := db.Exec(sqlStr, 39, 6)
	if err != nil {
		fmt.Printf("update failed, err:%v\n", err)
		return
	}
	n, err := ret.RowsAffected() // 操作影响的行数
	if err != nil {
		fmt.Printf("get RowsAffected failed, err:%v\n", err)
		return
	}
	fmt.Printf("update success, affected rows:%d\n", n)
}

// 删除数据
func deleteRowDemo() {
	sqlStr := "delete from user where id = ?"
	ret, err := db.Exec(sqlStr, 6)
	if err != nil {
		fmt.Printf("delete failed, err:%v\n", err)
		return
	}
	n, err := ret.RowsAffected() // 操作影响的行数
	if err != nil {
		fmt.Printf("get RowsAffected failed, err:%v\n", err)
		return
	}
	fmt.Printf("delete success, affected rows:%d\n", n)
}
```

### 24.3.4 NamedExec

`DB.NamedExec` 方法用来绑定 `SQL` 语句与结构体或 `map` 中的同名字段。

```go
func insertUserDemo()(err error){
	sqlStr := "INSERT INTO user (name,age) VALUES (:name,:age)"
	_, err = db.NamedExec(sqlStr,
		map[string]interface{}{
			"name": "七米",
			"age": 28,
		})
	return
}
```

### 24.3.5 NamedQuery

与 `DB.NamedExec` 同理，这里是支持查询。

```go
func namedQuery(){
	sqlStr := "SELECT * FROM user WHERE name=:name"
	// 使用map做命名查询
	rows, err := db.NamedQuery(sqlStr, map[string]interface{}{"name": "七米"})
	if err != nil {
		fmt.Printf("db.NamedQuery failed, err:%v\n", err)
		return
	}
	defer rows.Close()
	for rows.Next(){
		var u user
		err := rows.StructScan(&u)
		if err != nil {
			fmt.Printf("scan failed, err:%v\n", err)
			continue
		}
		fmt.Printf("user:%#v\n", u)
	}

	u := user{
		Name: "七米",
	}
	// 使用结构体命名查询，根据结构体字段的 db tag进行映射
	rows, err = db.NamedQuery(sqlStr, u)
	if err != nil {
		fmt.Printf("db.NamedQuery failed, err:%v\n", err)
		return
	}
	defer rows.Close()
	for rows.Next(){
		var u user
		err := rows.StructScan(&u)
		if err != nil {
			fmt.Printf("scan failed, err:%v\n", err)
			continue
		}
		fmt.Printf("user:%#v\n", u)
	}
}
```

### 24.3.6 事务操作

对于事务操作，我们可以使用 `sqlx` 中提供的 `db.Beginx()` 和 `tx.Exec()` 方法。示例代码如下：

```go
func transactionDemo2()(err error) {
	tx, err := db.Beginx() // 开启事务
	if err != nil {
		fmt.Printf("begin trans failed, err:%v\n", err)
		return err
	}
	defer func() {
		if p := recover(); p != nil {
			tx.Rollback()
			panic(p) // re-throw panic after Rollback
		} else if err != nil {
			fmt.Println("rollback")
			tx.Rollback() // err is non-nil; don't change it
		} else {
			err = tx.Commit() // err is nil; if Commit returns error update err
			fmt.Println("commit")
		}
	}()

	sqlStr1 := "Update user set age=20 where id=?"

	rs, err := tx.Exec(sqlStr1, 1)
	if err!= nil{
		return err
	}
	n, err := rs.RowsAffected()
	if err != nil {
		return err
	}
	if n != 1 {
		return errors.New("exec sqlStr1 failed")
	}
	sqlStr2 := "Update user set age=50 where i=?"
	rs, err = tx.Exec(sqlStr2, 5)
	if err!=nil{
		return err
	}
	n, err = rs.RowsAffected()
	if err != nil {
		return err
	}
	if n != 1 {
		return errors.New("exec sqlStr1 failed")
	}
	return err
}
```

## 24.4 sqlx.In

`sqlx.In` 是 sqlx 提供的一个非常方便的函数。

### 24.4.1 `sqlx.In` 的批量插入示例

#### 24.4.1.1 表结构

为了方便演示插入数据操作，这里创建一个 user 表，表结构如下：

```go
CREATE TABLE `user` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) DEFAULT '',
    `age` INT(11) DEFAULT '0',
    PRIMARY KEY(`id`)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
```

#### 24.4.1.2 结构体

定义一个 user 结构体，字段通过 tag 与数据库中 user 表的列一致。

```go
type User struct {
	Name string `db:"name"`
	Age  int    `db:"age"`
}
```

#### 24.4.1.3 bindvars（绑定变量）

查询占位符 `?` 在内部称为 `bindvars（查询占位符）`,它非常重要。你应该始终使用它们向数据库发送值，因为它们可以防止 `SQL` 注入攻击。`database/sql` 不尝试对查询文本进行任何验证；它与编码的参数一起按原样发送到服务器。除非驱动程序实现一个特殊的接口，否则在执行之前，查询是在服务器上准备的。因此`bindvars`  是特定于数据库的:

* MySQL 中使用 `?` 
* PostgreSQL 使用枚举的 `$1`、`$2` 等 bindvar 语法
* SQLite 中 `?` 和 `$1` 的语法都支持
* Oracle 中使用 `:name` 的语法

`bindvars` 的一个常见误解是，它们用来在 sql 语句中插入值。它们其实仅用于参数化，不允许更改 SQL 语句的结构。例如，使用 bindvars 尝试参数化列或表名将不起作用：

```go
// ？不能用来插入表名（做SQL语句中表名的占位符）
db.Query("SELECT * FROM ?", "mytable")
 
// ？也不能用来插入列名（做SQL语句中列名的占位符）
db.Query("SELECT ?, ? FROM people", "name", "location")
```

#### 24.4.1.4 自己拼接语句实现批量插入

比较笨，但是很好理解。就是有多少个 User 就拼接多少个 `(?, ?)`。

```go
// BatchInsertUsers 自行构造批量插入的语句
func BatchInsertUsers(users []*User) error {
	// 存放 (?, ?) 的slice
	valueStrings := make([]string, 0, len(users))
	// 存放values的slice
	valueArgs := make([]interface{}, 0, len(users) * 2)
	// 遍历users准备相关数据
	for _, u := range users {
		// 此处占位符要与插入值的个数对应
		valueStrings = append(valueStrings, "(?, ?)")
		valueArgs = append(valueArgs, u.Name)
		valueArgs = append(valueArgs, u.Age)
	}
	// 自行拼接要执行的具体语句
	stmt := fmt.Sprintf("INSERT INTO user (name, age) VALUES %s",
		strings.Join(valueStrings, ","))
	_, err := DB.Exec(stmt, valueArgs...)
	return err
}
```

#### 24.4.1.5 使用 sqlx.In 实现批量插入

前提是需要我们的结构体实现 `driver.Valuer` 接口：

```go
func (u User) Value() (driver.Value, error) {
	return []interface{}{u.Name, u.Age}, nil
}
```

使用 `sqlx.In` 实现批量插入代码如下：

```go
// BatchInsertUsers2 使用sqlx.In帮我们拼接语句和参数, 注意传入的参数是[]interface{}
func BatchInsertUsers2(users []interface{}) error {
	query, args, _ := sqlx.In(
		"INSERT INTO user (name, age) VALUES (?), (?), (?)",
		users..., // 如果arg实现了 driver.Valuer, sqlx.In 会通过调用 Value()来展开它
	)
	fmt.Println(query) // 查看生成的querystring
	fmt.Println(args)  // 查看生成的args
	_, err := DB.Exec(query, args...)
	return err
}
```

#### 24.4.1.6 使用 NamedExec 实现批量插入

注意 ：该功能目前有人已经推了 [`#285 PR`](https://github.com/jmoiron/sqlx/pull/285)，但是作者还没有发 release，所以想要使用下面的方法实现批量插入需要暂时使用 master 分支的代码：

在项目目录下执行以下命令下载并使用 master 分支代码：

```go
go get github.com/jmoiron/sqlx@master
```

使用 NamedExec 实现批量插入的代码如下：

```go
// BatchInsertUsers3 使用NamedExec实现批量插入
func BatchInsertUsers3(users []*User) error {
	_, err := DB.NamedExec("INSERT INTO user (name, age) VALUES (:name, :age)", users)
	return err
}
```

把上面三种方法综合起来试一下：

```go
func main() {
	err := initDB()
	if err != nil {
		panic(err)
	}
	defer DB.Close()
	u1 := User{Name: "七米", Age: 18}
	u2 := User{Name: "q1mi", Age: 28}
	u3 := User{Name: "小王子", Age: 38}

	// 方法1
	users := []*User{&u1, &u2, &u3}
	err = BatchInsertUsers(users)
	if err != nil {
		fmt.Printf("BatchInsertUsers failed, err:%v\n", err)
	}

	// 方法2
	users2 := []interface{}{u1, u2, u3}
	err = BatchInsertUsers2(users2)
	if err != nil {
		fmt.Printf("BatchInsertUsers2 failed, err:%v\n", err)
	}

	// 方法3
	users3 := []*User{&u1, &u2, &u3}
	err = BatchInsertUsers3(users3)
	if err != nil {
		fmt.Printf("BatchInsertUsers3 failed, err:%v\n", err)
	}
}
```
### 24.4.2 sqlx.In 的查询示例

关于 `sqlx.In` 这里再补充一个用法，在 sqlx 查询语句中实现 In 查询和 `FIND_IN_SET` 函数。即实现:
`SELECT * FROM user WHERE id in (3, 2, 1);` 
和
`SELECT * FROM user WHERE id in (3, 2, 1) ORDER BY FIND_IN_SET(id, '3,2,1');`。

#### 24.4.2.1 in查询

查询 id 在给定 id 集合中的数据。

```go
// QueryByIDs 根据给定ID查询
func QueryByIDs(ids []int)(users []User, err error){
	// 动态填充id
	query, args, err := sqlx.In("SELECT name, age FROM user WHERE id IN (?)", ids)
	if err != nil {
		return
	}
	// sqlx.In 返回带 `?` bindvar的查询语句, 我们使用Rebind()重新绑定它
	query = DB.Rebind(query)

	err = DB.Select(&users, query, args...)
	return
}
```

#### 24.4.2.2 in 查询和 `FIND_IN_SET` 函数

查询 id 在给定 id 集合的数据并维持给定 id 集合的顺序。

```go
// QueryAndOrderByIDs 按照指定id查询并维护顺序
func QueryAndOrderByIDs(ids []int)(users []User, err error){
	// 动态填充id
	strIDs := make([]string, 0, len(ids))
	for _, id := range ids {
		strIDs = append(strIDs, fmt.Sprintf("%d", id))
	}
	query, args, err := sqlx.In("SELECT name, age FROM user WHERE id IN (?) ORDER BY FIND_IN_SET(id, ?)", ids, strings.Join(strIDs, ","))
	if err != nil {
		return
	}

	// sqlx.In 返回带 `?` bindvar的查询语句, 我们使用Rebind()重新绑定它
	query = DB.Rebind(query)

	err = DB.Select(&users, query, args...)
	return
}
```

当然，在这个例子里面你也可以先使用 IN 查询，然后通过代码按给定的 ids 对查询结果进行排序。

参考链接：

[Illustrated guide to SQLX](http://jmoiron.github.io/sqlx/)