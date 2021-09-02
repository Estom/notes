### 一. mysql

go-sql-driver : <https://github.com/go-sql-driver/mysql/wiki/Examples> 

#### 1.1 下载

```
go get -u github.com/go-sql-driver/mysql
```

但是手动下载时, golang导入时很不好用, 基本上是导入不了, 一直爆红

如果用golang开发, 不如是用快捷键下载

### 二. 编码

#### 2.1 实体的封装结构体

```go
// 实体的结构体
type user struct {
	id   int
	name string
}
```



#### 2.2  初始化连接

```go
// 初始化连接
func initDB() (err error) {
	db, err = sql.Open("mysql", "root:root@tcp(127.0.0.1:3306)/test")
	if err != nil {
		panic(err)
	}
	// todo 不要在这里关闭它, 函数一结束,defer就执行了
	// defer db.Close()
	err = db.Ping()
	if err != nil {
		return err
	}
	return nil
}
```



#### 2.3 设置最大连接数, 最大空闲数

通过如下两个函数, 设置数据库连接池的最大连接数和连接池中的最大空闲数

```go
// 默认n是0, 表示没有设置最大上限 , 如果n<0 , 表示不设置最大连接
func (db *DB) SetMaxOpenConns(n int)

// 如果最大空闲数比最大连接数还大, 那么最大空闲数 会被设置成 最大连接数
// 如果n<0 , 表示不设置
func (db *DB) SetMaxIdleConns(n int)
```



#### 2.4 单行查询

```go
func queryRow(sqlstr string) {
	var u user
    // 通过Scan , 将查询出的结果映射到
	err := db.QueryRow(sqlstr).Scan(&u.id, &u.name)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	fmt.Printf("user.id:%v  user:name:%v\n", u.id, u.name)
}

```



#### 2.5 多行查询

```go
func queryRows() {
	sqlStr := "select * from user where id >?"
	rows,err:=db.Query(sqlStr,0)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	// 关闭rows 保持的数据库连接
	defer rows.Close()
	// 这里有点像迭代器模式
	for rows.Next(){
		var u user
		err= rows.Scan(&u.id,&u.name)
		if err != nil {
			fmt.Printf("error: %v\n", err)
			return
		}
		fmt.Printf("id: %v name:%v",u.id,u.name)
	}
}
```





#### 2.6 插入数据

```go
func insertData(){
	// strSql:="insert into user values(?,?)"
	// result,err:=db.Exec(strSql,nil,"tom")

	//strSql1:="insert into user(id,name) values(?,?)"
	//result,err:=db.Exec(strSql1,nil,"tom")

	strSql2:="insert into user(name) values(?)"
	result,err:=db.Exec(strSql2,"tom")
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	// 获取插入数据的id
	id,err:=result.LastInsertId()
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	fmt.Println("last insert id : ",id)

	// 响应行数
	rows,err:=result.RowsAffected()
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	fmt.Println("row affected : ",rows)
}
```



####  2.7 更新

```go
func updateUser (){
	sqlStr := "update user set user.name = ? where id =?"
	result,err:=db.Exec(sqlStr,"jerry",5)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	id,err:=result.LastInsertId()
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	fmt.Println("last insert id : ",id)

	affectRow,err:=result.RowsAffected()
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	fmt.Println("row affected : ",affectRow)

}

```



#### 2.8 刪除

```go
func deleteUserById(targetId int) {
	sqlStr := "delete from user where id = ?"
	result,err:=db.Exec(sqlStr,targetId)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}

	id, err := result.LastInsertId()
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	fmt.Println("last insert id : ", id)

	affectRow, err := result.RowsAffected()
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	fmt.Println("row affected : ", affectRow)
}

```



### 三. Sql预处理

#### 3.1 什么是sql预处理?

* 普通sql执行过程
  * 从客户端对sql中的占位符进行替换,得到完整的sql
  * 客户端将完整的sql , 发送到 MysqlServer
  * MysqlServer执行sql , 返回给客户端结果
* 预处理过程
  * Sql被分成两部分 , 命令部分, 预处理部分
  * 先把命令部分发送给Mysql服务端, Mysql服务端进行Sql的预处理
  * 把数据部分发送给Mysql服务端, 让MysqlServer用起替换命令部分的占位符
  * MysqlServer 执行sql , 返回给客户端结果





#### 3.2 为什么要预处理?

* 优化Mysql服务器重复执行sql的流程, 一次编译, 下次就不用重新编译sql了, 节省编译成本

* 避免sql注入问题

  ```go
  // sql注入示例
  func sqlInjectDemo(name string) {
      // 像这样自己拼接sql, 很容易造成sql注入
  	sqlStr := fmt.Sprintf("select id, name, age from user where name='%s'", name)
  	fmt.Printf("SQL:%s\n", sqlStr)
  
  	var users []user
  	err := db.Select(&users, sqlStr)
  	if err != nil {
  		fmt.Printf("exec failed, err:%v\n", err)
  		return
  	}
  	for _, u := range users {
  		fmt.Printf("user:%#v\n", u)
  	}
  }
  
  sqlInjectDemo("xxx' or 1=1#")
  sqlInjectDemo("xxx' union select * from user #")
  sqlInjectDemo("xxx' and (select count(*) from user) <10 #")
  ```

#### 3.3 Go的Sql预处理

```go
func (db *DB) Prepare(query string) (*Stmt, error)
```

```go
func prepareQuery(){
	sqlStr:= "select * from user where id > ?"
    
    // ********************************
	stat,err:=db.Prepare(sqlStr)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
    // ********************************
	defer stat.Close()
    // *************多行, Query , 单行QueryRow()*******************
	rows,err:=stat.Query(0)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var u user
		err:=rows.Scan(&u.id,&u.name)
		if err != nil {
			fmt.Printf("error: %v\n", err)
			return
		}
		fmt.Printf("id:%v name:%v",u.id,u.name)
	}
}
```



### 四. 事务

Go语言中使用如下三个方法实现Mysql中的事务操作

```go
// 开启事务, 方法返回一个事物
func (db *DB) Begin() (*Tx, error)

// 由事务执行sql
sqlStr1 := "Update user set age=30 where id=?"
_, err = tx.Exec(sqlStr1, 2)

// 由tx发起提交事务的操作
func (tx *Tx) Commit() error

// 在err不为空, 或者是其他的情况下, 由tx发起回滚
func (tx *Tx) Rollback() error
```



### 五. sqlx

第三方库`sqlx`能够简化操作，提高开发效率。 

#### 5.1 安装

```go
go get github.com/jmoiron/sqlx
```

推荐将这个依赖收到写入import块中, 然后通过goland的快捷键导入



#### 5.2 连接数据库

```go

var db *sqlx.DB

func initDb() (er error) {
	db, er = sqlx.Connect("mysql", "root:root@tcp(127.0.0.1:3306)/test")
	if er != nil {
		fmt.Printf("error: %v\n", er)
		return er
	}
	db.SetMaxOpenConns(200)
	db.SetMaxIdleConns(100)
	return nil
}
```



#### 5.3 踩坑

报错: `scannable dest type struct with >1 columns (2) in result`

其实原因看看下面的代码就大概能猜出来

```go

type User struct {
	id   int `db:"id"`
	name string `db:"name"`
}

func GetUserById(id int) {
	sqlStr := "select id, name from user where id =?"
	var u User
    // 问题就出在这里 , sqlx底层通过v := reflect.ValueOf(dest) ... 为user赋值的
    // 所以上面的我们的结构体首字母需要大写才行, 不然怎么反射的了呢?
	err:=db.Get(&u, sqlStr, id)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
	fmt.Println(u.id , ":", u.name)
}
```



#### 5.4 查找

```go
	// 单行
	sqlStr := "select id, name from user where id =?"
	err:=db.Get(&u, sqlStr, id)

	// 多行
	sqlStr := "select id, name, age from user where id > ?"
	var users []user
	err := db.Select(&users, sqlStr, 0)
```



#### 5.5 删除,更新,修改

删除,更新,修改和原生的sql 用法基本一直



#### 5.6 事务

sqlx相对原生的sql提供了 db.Beginx() , db.MustExec() , 用来简化错误处理的过程

示例:

```go
func transactionDemo() {
	tx, err := db.Beginx()
	if err != nil {
		fmt.Printf("error: %v\n", err)
		tx.Rollback()
		return
	}

	sql1 := ""
	tx.MustExec(sql1, 1)
	sql2 := ""
	tx.MustExec(sql2, 1)

	err = tx.Commit()
	if err != nil {
		tx.Rollback()
		fmt.Println("commit error:",err)
		return
	}
	fmt.Println("success")
}
```



### 六. sql中的占位符

| 数据库     | 占位符语法   |
| ---------- | ------------ |
| MySQL      | `?`          |
| PostgreSQL | `$1`, `$2`等 |
| SQLite     | `?` 和`$1`   |
| Oracle     | `:name`      |

 









```
defer rows.Close() ???? 不确定
	// 循环读取结果集中的数据
	for rows.Next() {
```