* [原文地址：GORM入门指南](https://www.liwenzhou.com/posts/Go/gorm/)
* [原文地址：GORM CRUD指南](https://www.liwenzhou.com/posts/Go/gorm_crud/)
* [《GORM 中文文档》](https://gorm.io/zh_CN/docs/)
* [《MySql 中文文档》](https://www.mysqlzh.com/)


> 下列示例中的 gorm 是导师 Fork 的，GORM 的原始路径是：[https://github.com/go-gorm/gorm](https://github.com/go-gorm/gorm)

## .1 GORM 介绍

gorm 是一个使用 Go 语言编写的 ORM 框架。它文档齐全，对开发者友好，支持主流数据库。

[对象关系映射（英语：Object Relational Mapping，简称ORM，或O/RM，或O/R mapping](https://baike.baidu.com/item/%E5%AF%B9%E8%B1%A1%E5%85%B3%E7%B3%BB%E6%98%A0%E5%B0%84/311152?fromtitle=ORM&fromid=3583252&fr=aladdin)），是一种程序设计技术，用于实现面向对象编程语言里不同类型系统的数据之间的转换。从效果上说，它其实是创建了一个可在编程语言里使用的“虚拟对象数据库”。

* [Github 地址](https://github.com/jinzhu/gorm)
* [GORM 中文文档](https://gorm.io/zh_CN/docs/)


## .2 安装

```
go get -u github.com/jinzhu/gorm
```

## .3 连接数据库

连接不同的数据库都需要导入对应数据库驱动程序，GORM 已经贴心的为我们包装了一些驱动程序，只需要按如下方式导入需要的数据库驱动即可：

```go
import _ "github.com/jinzhu/gorm/dialects/mysql"
// import _ "github.com/jinzhu/gorm/dialects/postgres"
// import _ "github.com/jinzhu/gorm/dialects/sqlite"
// import _ "github.com/jinzhu/gorm/dialects/mssql"
```

### .3.1  连接MySQL

```go
import (
  "github.com/jinzhu/gorm"
  _ "github.com/jinzhu/gorm/dialects/mysql"
)

func main() {
  db, err := gorm.Open("mysql", "user:password@(localhost)/dbname?charset=utf8mb4&parseTime=True&loc=Local")
  defer db.Close()
}
```

### .3.2 连接PostgreSQL

基本代码同上，注意引入对应 postgres 驱动并正确指定 gorm.Open() 参数。

```go
import (
  "github.com/jinzhu/gorm"
  _ "github.com/jinzhu/gorm/dialects/postgres"
)

func main() {
  db, err := gorm.Open("postgres", "host=myhost port=myport user=gorm dbname=gorm password=mypassword")
  defer db.Close()
}
```

### .3.3  连接Sqlite3

基本代码同上，注意引入对应 sqlite 驱动并正确指定 gorm.Open() 参数。

```go
import (
  "github.com/jinzhu/gorm"
  _ "github.com/jinzhu/gorm/dialects/sqlite"
)

func main() {
  db, err := gorm.Open("sqlite3", "/tmp/gorm.db")
  defer db.Close()
}
```

### .3.4 连接SQL Server

基本代码同上，注意引入对应 mssql 驱动并正确指定 gorm.Open() 参数。

```go
import (
  "github.com/jinzhu/gorm"
  _ "github.com/jinzhu/gorm/dialects/mssql"
)

func main() {
  db, err := gorm.Open("mssql", "sqlserver://username:password@localhost:1433?database=dbname")
  defer db.Close()
}
```

## .4 GORM基本示例

> 注意:
> 
> * 本文以MySQL数据库为例，讲解GORM各项功能的主要使用方法。
>* 往下阅读本文前，你需要有一个能够成功连接上的MySQL数据库实例。


### .4.1 Docker 快速创建 MySQL 实例

很多同学如果不会安装 MySQL 或者懒得安装 MySQL，可以使用一下命令快速运行一个 MySQL8.0.19 实例，当然前提是你要有 docker 环境…

在本地的 `13306` 端口运行一个名为 `mysql8019`，root 用户名密码为 `root1234` 的 MySQL 容器环境:

```go
docker run --name mysql8019 -p 13306:3306 -e MYSQL_ROOT_PASSWORD=root1234 -d mysql:8.0.19
```

在另外启动一个 MySQL Client 连接上面的 MySQL 环境，密码为上一步指定的密码 `root1234` :

```go
docker run -it --network host --rm mysql mysql -h127.0.0.1 -P13306 --default-character-set=utf8mb4 -uroot -p
```

### .4.2 创建数据库

在使用 GORM 前手动创建数据库 db1：

```sql
CREATE DATABASE db1;
```

### .4.3 GORM 操作 MySQL

使用 GORM 连接上面的 `db1` 进行创建、查询、更新、删除操作。

```go
package main

import (
	"fmt"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
)

// UserInfo 用户信息
type UserInfo struct {
	ID uint
	Name string
	Gender string
	Hobby string
}


func main() {
	db, err := gorm.Open("mysql", "root:root1234@(127.0.0.1:13306)/db1?charset=utf8mb4&parseTime=True&loc=Local")
	if err!= nil{
		panic(err)
	}
	defer db.Close()

	// 自动迁移
	db.AutoMigrate(&UserInfo{})

	u1 := UserInfo{1, "七米", "男", "篮球"}
	u2 := UserInfo{2, "沙河娜扎", "女", "足球"}
	// 创建记录
	db.Create(&u1)
	db.Create(&u2)
	// 查询
	var u = new(UserInfo)
	db.First(u)
	fmt.Printf("%#v\n", u)

	var uu UserInfo
	db.Find(&uu, "hobby=?", "足球")
	fmt.Printf("%#v\n", uu)

	// 更新
	db.Model(&u).Update("hobby", "双色球")
	// 删除
	db.Delete(&u)
}
```

## .5 GORM Model定义

在使用 ORM 工具时，通常我们需要在代码中定义模型（Models）与数据库中的数据表进行映射，在 GORM 中模型（Models）通常是正常定义的**结构体、基本的 go 类型或它们的指针**。 同时也支持 `sql.Scanner` 及`driver.Valuer` 接口（interfaces）。

### .4.1 gorm.Model

为了方便模型定义，GORM 内置了一个 `gorm.Model` 结构体。`gorm.Model` 是一个包含了 `ID`, `CreatedAt`, `UpdatedAt`, `DeletedAt` 四个字段的 Golang 结构体。

```go
// gorm.Model 定义
type Model struct {
  ID        uint `gorm:"primary_key"`
  CreatedAt time.Time
  UpdatedAt time.Time
  DeletedAt *time.Time
}
```

你可以将它嵌入到你自己的模型中：

```go
// 将 `ID`, `CreatedAt`, `UpdatedAt`, `DeletedAt`字段注入到`User`模型中
type User struct {
  gorm.Model
  Name string
}
```

当然你也可以完全自己定义模型：

```go
// 不使用gorm.Model，自行定义模型
type User struct {
  ID   int
  Name string
}
```

### .4.2 模型定义示例

```go
type User struct {
  gorm.Model
  Name         string
  Age          sql.NullInt64
  Birthday     *time.Time
  Email        string  `gorm:"type:varchar(100);unique_index"`
  Role         string  `gorm:"size:255"` // 设置字段大小为255
  MemberNumber *string `gorm:"unique;not null"` // 设置会员号（member number）唯一并且不为空
  Num          int     `gorm:"AUTO_INCREMENT"` // 设置 num 为自增类型
  Address      string  `gorm:"index:addr"` // 给address字段创建名为addr的索引
  IgnoreMe     int     `gorm:"-"` // 忽略本字段
}
```

### .4.3 结构体标记（tags）

使用结构体声明模型时，标记（tags）是可选项。gorm 支持的标记如下


* 结构体标记（Struct tags）如下：

标记（Tag）|	描述
---|---
Column	 | 指定列名
Type	 | 指定列数据类型
Size 	| 指定列大小, 默认值255
`PRIMARY_KEY`	| 将列指定为主键
UNIQUE	 | 将列指定为唯一
DEFAULT	| 指定列默认值
PRECISION	| 指定列精度
NOT NULL	| 将列指定为非 NULL
`AUTO_INCREMENT`	| 指定列是否为自增类型
INDEX	| 创建具有或不带名称的索引, 如果多个索引同名则创建复合索引
`UNIQUE_INDEX`	| 和 INDEX 类似，只不过创建的是唯一索引
EMBEDDED	| 将结构设置为嵌入
`EMBEDDED_PREFIX`	| 设置嵌入结构的前缀
`-`	| 忽略此字段


* 关联相关标记（tags）

标记（Tag）|	描述
---|---
MANY2MANY	|指定连接表
FOREIGNKEY	|设置外键
`ASSOCIATION_FOREIGNKEY`	| 设置关联外键
POLYMORPHIC	| 指定多态类型
`POLYMORPHIC_VALUE`	| 指定多态值
`JOINTABLE_FOREIGNKEY`	| 指定连接表的外键
`ASSOCIATION_JOINTABLE_FOREIGNKEY`	| 指定连接表的关联外键
`SAVE_ASSOCIATIONS`	| 是否自动完成 save 的相关操作
`ASSOCIATION_AUTOUPDATE`	| 是否自动完成 update 的相关操作
`ASSOCIATION_AUTOCREATE`	| 是否自动完成 create 的相关操作
`ASSOCIATION_SAVE_REFERENCE`	| 是否自动完成引用的 save 的相关操作
`PRELOAD`	| 是否自动完成预加载的相关操作

## .5 主键、表名、列名的约定

### .5.1 主键（Primary Key）

GORM 默认会使用名为 ID 的字段作为表的主键。

```go
type User struct {
  ID   string // 名为`ID`的字段会默认作为表的主键
  Name string
}

// 使用`AnimalID`作为主键
type Animal struct {
  AnimalID int64 `gorm:"primary_key"`
  Name     string
  Age      int64
}
```

### .5.2 表名（Table Name）

表名默认就是结构体名称的复数，例如：

```go
type User struct {} // 默认表名是 `users`

// 将 User 的表名设置为 `profiles`
func (User) TableName() string {
  return "profiles"
}

func (u User) TableName() string {
  if u.Role == "admin" {
    return "admin_users"
  } else {
    return "users"
  }
}

// 禁用默认表名的复数形式，如果置为 true，则 `User` 的默认表名是 `user`
db.SingularTable(true)
```

也可以通过 `Table()` 指定表名：

```go
// 使用 User 结构体创建名为`deleted_users`的表
db.Table("deleted_users").CreateTable(&User{})

var deleted_users []User
db.Table("deleted_users").Find(&deleted_users)
//// SELECT * FROM deleted_users;

db.Table("deleted_users").Where("name = ?", "jinzhu").Delete()
//// DELETE FROM deleted_users WHERE name = 'jinzhu';
```

GORM还支持更改默认表名称规则：

```go
gorm.DefaultTableNameHandler = func (db *gorm.DB, defaultTableName string) string  {
  return "prefix_" + defaultTableName;
}
```

### .5.3 列名（Column Name）

列名由字段名称通过下划线分割来生成

```go
type User struct {
  ID        uint      // column name is `id`
  Name      string    // column name is `name`
  Birthday  time.Time // column name is `birthday`
  CreatedAt time.Time // column name is `created_at`
}
```

可以使用结构体 tag 指定列名：

```go
type Animal struct {
  AnimalId    int64     `gorm:"column:beast_id"`         // set column name to `beast_id`
  Birthday    time.Time `gorm:"column:day_of_the_beast"` // set column name to `day_of_the_beast`
  Age         int64     `gorm:"column:age_of_the_beast"` // set column name to `age_of_the_beast`
}
```

### .5.4 时间戳跟踪

#### .5.4.1 CreatedAt

如果模型有 `CreatedAt `字段，该字段的值将会是初次创建记录的时间。

```go
db.Create(&user) // `CreatedAt`将会是当前时间

// 可以使用`Update`方法来改变`CreateAt`的值
db.Model(&user).Update("CreatedAt", time.Now())
```

#### .5.4.2 UpdatedAt

如果模型有 `UpdatedAt` 字段，该字段的值将会是每次更新记录的时间。

```go
db.Save(&user) // `UpdatedAt`将会是当前时间

db.Model(&user).Update("name", "jinzhu") // `UpdatedAt`将会是当前时间
```

#### .5.4.3  DeletedAt

**如果模型有 `DeletedAt` 字段，调用 `Delete` 删除该记录时，将会设置 `DeletedAt` 字段为当前时间，而不是直接将记录从数据库中删除。**

## .6 CRUD

> CRUD 即 Create、Refer、Update、Delete

`CRUD` 通常指数据库的增删改查操作，本文详细介绍了如何使用 GORM 实现创建、查询、更新和删除操作。

本文中的 db 变量为 `*gorm.DB` 对象，例如：

```go
import (
  "github.com/jinzhu/gorm"
  _ "github.com/jinzhu/gorm/dialects/mysql"
)

func main() {
  db, err := gorm.Open("mysql", "user:password@/dbname?charset=utf8&parseTime=True&loc=Local")
  defer db.Close()
  
  // db.Xx
}
```

### .6.1 创建

#### .6.1.1 创建/添加记录

首先定义模型：

```go
type User struct {
	ID           int64
	Name         string
	Age          int64
}
```

使用使用 `NewRecord()` 查询主键是否存在，主键为空使用 `Create()` 创建记录：

```go
user := User{Name: "q1mi", Age: 18}

db.NewRecord(user) // 主键为空返回`true`
db.Create(&user)   // 创建user
db.NewRecord(user) // 创建`user`后返回`false`
```

#### .6.1.2  默认值

可以通过 `defalut`  tag 定义字段的默认值，比如：

```go
type User struct {
  ID   int64
  Name string `gorm:"default:'小王子'"`
  Age  int64
}
```

>注意：通过tag定义字段的默认值，在创建记录时候生成的 SQL 语句会排除没有值或值为 零值 的字段。 在将记录插入到数据库后，Gorm 会从数据库加载那些字段的默认值。


CnPeng ：简单来说就是，在将数据存储到数据库时，如果某个字段没有赋值（或者所赋的值是其零值），也没有设置 `defalut` 标签 ，则不会执行该字段的存储操作；如果没有赋值，但是设置了 `default` ，会将该字段及其  `default` 值存进数据库。

举个例子：

```go
var user = User{Name: "", Age: 99}
db.Create(&user)
```

上面代码实际执行的 SQL 语句是 `INSERT INTO users("age") values('99');`，排除了零值字段 Name，而在数据库中这一条数据会使用设置的默认值 `小王子` 作为 Name 字段的值。

**注意**：所有字段的零值, 比如 `0`, `""`,`false` 或者其它零值，都不会保存到数据库内，但会使用他们的默认值 (通过 `default` 标签指定的值)。 如果你想避免这种情况（也即是说我们希望能够存储零值），可以考虑使用指针或实现 `Scanner/Valuer` 接口，比如：

* 使用指针方式实现零值存入数据库

```go
// 使用指针
type User struct {
  ID   int64
  Name *string `gorm:"default:'小王子'"`
  Age  int64
}
user := User{Name: new(string), Age: 18))}
db.Create(&user)  // 此时数据库中该条记录name字段的值就是''
```

* 使用Scanner/Valuer接口方式实现零值存入数据库

```go
// 使用 Scanner/Valuer
type User struct {
	ID int64
	Name sql.NullString `gorm:"default:'小王子'"` // sql.NullString 实现了Scanner/Valuer接口
	Age  int64
}
user := User{Name: sql.NullString{"", true}, Age:18}
db.Create(&user)  // 此时数据库中该条记录name字段的值就是''
```

#### .6.1.3 扩展创建选项

例如 PostgreSQL 数据库中可以使用下面的方式实现合并插入, 有则更新, 无则插入。

```go
// 为Instert语句添加扩展SQL选项
db.Set("gorm:insert_option", "ON CONFLICT").Create(&product)
// INSERT INTO products (name, code) VALUES ("name", "code") ON CONFLICT;
```

### .6.2 查询

#### .6.2.1 一般查询

```go
// 根据主键查询第一条记录
db.First(&user)
//// SELECT * FROM users ORDER BY id LIMIT 1;

// 随机获取一条记录
db.Take(&user)
//// SELECT * FROM users LIMIT 1;

// 根据主键查询最后一条记录
db.Last(&user)
//// SELECT * FROM users ORDER BY id DESC LIMIT 1;

// 查询所有的记录
db.Find(&users)
//// SELECT * FROM users;

// 查询指定的某条记录(仅当主键为整型时可用)
db.First(&user, 10)
//// SELECT * FROM users WHERE id = 10;
```

#### .6.2.2 Where 条件

##### .6.2.2.1 普通SQL查询

```go
// Get first matched record
db.Where("name = ?", "jinzhu").First(&user)
//// SELECT * FROM users WHERE name = 'jinzhu' limit 1;

// Get all matched records
db.Where("name = ?", "jinzhu").Find(&users)
//// SELECT * FROM users WHERE name = 'jinzhu';

// <>
db.Where("name <> ?", "jinzhu").Find(&users)
//// SELECT * FROM users WHERE name <> 'jinzhu';

// IN
db.Where("name IN (?)", []string{"jinzhu", "jinzhu 2"}).Find(&users)
//// SELECT * FROM users WHERE name in ('jinzhu','jinzhu 2');

// LIKE
db.Where("name LIKE ?", "%jin%").Find(&users)
//// SELECT * FROM users WHERE name LIKE '%jin%';

// AND
db.Where("name = ? AND age >= ?", "jinzhu", "22").Find(&users)
//// SELECT * FROM users WHERE name = 'jinzhu' AND age >= 22;

// Time
db.Where("updated_at > ?", lastWeek).Find(&users)
//// SELECT * FROM users WHERE updated_at > '2000-01-01 00:00:00';

// BETWEEN
db.Where("created_at BETWEEN ? AND ?", lastWeek, today).Find(&users)
//// SELECT * FROM users WHERE created_at BETWEEN '2000-01-01 00:00:00' AND '2000-01-08 00:00:00';
```

##### .6.2.2.2 Struct & Map查询

```go
// Struct
db.Where(&User{Name: "jinzhu", Age: 20}).First(&user)
//// SELECT * FROM users WHERE name = "jinzhu" AND age = 20 LIMIT 1;

// Map
db.Where(map[string]interface{}{"name": "jinzhu", "age": 20}).Find(&users)
//// SELECT * FROM users WHERE name = "jinzhu" AND age = 20;

// 主键的切片
db.Where([]int64{20, 21, 22}).Find(&users)
//// SELECT * FROM users WHERE id IN (20, 21, 22);
```

提示：当通过结构体进行查询时，GORM 只对非零值字段进行查询，也就是说如果字段值为 `0`，`''`，`false`或者其他零值时，该字段将不会作为查询条件，例如：

```go
db.Where(&User{Name: "jinzhu", Age: 0}).Find(&users)
//// SELECT * FROM users WHERE name = "jinzhu";
```

我们以使用指针或实现 `Scanner/Valuer` 接口来避免这个问题（也就是说，将零值字段也作为查询条件）.

```go
// 使用指针
type User struct {
  gorm.Model
  Name string
  Age  *int
}

// 使用 Scanner/Valuer
type User struct {
  gorm.Model
  Name string
  Age  sql.NullInt64  // sql.NullInt64 实现了 Scanner/Valuer 接口
}
```

#### .6.2.3 Not 条件

作用与 Where 类似的情形如下：

```go
db.Not("name", "jinzhu").First(&user)
//// SELECT * FROM users WHERE name <> "jinzhu" LIMIT 1;

// Not In
db.Not("name", []string{"jinzhu", "jinzhu 2"}).Find(&users)
//// SELECT * FROM users WHERE name NOT IN ("jinzhu", "jinzhu 2");

// Not In slice of primary keys
db.Not([]int64{1,2,3}).First(&user)
//// SELECT * FROM users WHERE id NOT IN (1,2,3);

db.Not([]int64{}).First(&user)
//// SELECT * FROM users;

// Plain SQL
db.Not("name = ?", "jinzhu").First(&user)
//// SELECT * FROM users WHERE NOT(name = "jinzhu");

// Struct
db.Not(User{Name: "jinzhu"}).First(&user)
//// SELECT * FROM users WHERE name <> "jinzhu";
```

#### .6.2.4 Or 条件

```go
db.Where("role = ?", "admin").Or("role = ?", "super_admin").Find(&users)
//// SELECT * FROM users WHERE role = 'admin' OR role = 'super_admin';

// Struct
db.Where("name = 'jinzhu'").Or(User{Name: "jinzhu 2"}).Find(&users)
//// SELECT * FROM users WHERE name = 'jinzhu' OR name = 'jinzhu 2';

// Map
db.Where("name = 'jinzhu'").Or(map[string]interface{}{"name": "jinzhu 2"}).Find(&users)
//// SELECT * FROM users WHERE name = 'jinzhu' OR name = 'jinzhu 2';
```

#### .6.2.5 内联条件

作用与 Where 查询类似，**当内联条件与多个立即执行方法一起使用时, 内联条件不会传递给后面的立即执行方法。**

```go
// 根据主键获取记录 (只适用于整形主键)
db.First(&user, 23)
//// SELECT * FROM users WHERE id = 23 LIMIT 1;
// 根据主键获取记录, 如果它是一个非整形主键
db.First(&user, "id = ?", "string_primary_key")
//// SELECT * FROM users WHERE id = 'string_primary_key' LIMIT 1;

// Plain SQL
db.Find(&user, "name = ?", "jinzhu")
//// SELECT * FROM users WHERE name = "jinzhu";

db.Find(&users, "name <> ? AND age > ?", "jinzhu", 20)
//// SELECT * FROM users WHERE name <> "jinzhu" AND age > 20;

// Struct
db.Find(&users, User{Age: 20})
//// SELECT * FROM users WHERE age = 20;

// Map
db.Find(&users, map[string]interface{}{"age": 20})
//// SELECT * FROM users WHERE age = 20;
```

#### .6.2.6 额外查询选项

```go
// 为查询 SQL 添加额外的 SQL 操作
db.Set("gorm:query_option", "FOR UPDATE").First(&user, 10)
//// SELECT * FROM users WHERE id = 10 FOR UPDATE;
```

> `for update` 就是一个行级锁。借助 `for update` 子句，我们可以在应用程序的层面手工实现**数据加锁保护**操作（防止多线程的情况下出现问题）如：`select * from 表名 for update`，就可以把查询出来的数据进行加锁控制，别人就无法查询更新了。如果是你自己锁的, 通过 `rollback` 或者 `commit` 都能解锁; 如果是别人锁的，解锁会麻烦一些。

#### .6.2.7 FirstOrInit

获取匹配的第一条记录，**否则根据给定的条件初始化一个新的对象** (仅支持 struct 和 map 条件)

```go
// 未找到
db.FirstOrInit(&user, User{Name: "non_existing"})
//// user -> User{Name: "non_existing"}

// 找到
db.Where(User{Name: "Jinzhu"}).FirstOrInit(&user)
//// user -> User{Id: 111, Name: "Jinzhu", Age: 20}
db.FirstOrInit(&user, map[string]interface{}{"name": "jinzhu"})
//// user -> User{Id: 111, Name: "Jinzhu", Age: 20}
```

##### .6.2.7.1 Attrs

如果记录未找到，将使用参数初始化 struct.

```go
// 未找到
db.Where(User{Name: "non_existing"}).Attrs(User{Age: 20}).FirstOrInit(&user)
//// SELECT * FROM USERS WHERE name = 'non_existing';
//// user -> User{Name: "non_existing", Age: 20}

db.Where(User{Name: "non_existing"}).Attrs("age", 20).FirstOrInit(&user)
//// SELECT * FROM USERS WHERE name = 'non_existing';
//// user -> User{Name: "non_existing", Age: 20}

// 找到
db.Where(User{Name: "Jinzhu"}).Attrs(User{Age: 30}).FirstOrInit(&user)
//// SELECT * FROM USERS WHERE name = jinzhu';
//// user -> User{Id: 111, Name: "Jinzhu", Age: 20}
```

##### .6.2.7.2 Assign

不管记录是否找到，都将参数赋值给 struct.

```go
// 未找到
db.Where(User{Name: "non_existing"}).Assign(User{Age: 20}).FirstOrInit(&user)
//// user -> User{Name: "non_existing", Age: 20}

// 找到
db.Where(User{Name: "Jinzhu"}).Assign(User{Age: 30}).FirstOrInit(&user)
//// SELECT * FROM USERS WHERE name = jinzhu';
//// user -> User{Id: 111, Name: "Jinzhu", Age: 30}
```

#### .6.2.8 FirstOrCreate

获取匹配的第一条记录, 否则根据给定的条件创建一个新的记录 (仅支持 struct 和 map 条件)

```go
// 未找到
db.FirstOrCreate(&user, User{Name: "non_existing"})
//// INSERT INTO "users" (name) VALUES ("non_existing");
//// user -> User{Id: 112, Name: "non_existing"}

// 找到
db.Where(User{Name: "Jinzhu"}).FirstOrCreate(&user)
//// user -> User{Id: 111, Name: "Jinzhu"}
```

##### .6.2.8.1 Attrs

如果记录未找到，将使用参数创建 struct 和记录.

```go
 // 未找到
db.Where(User{Name: "non_existing"}).Attrs(User{Age: 20}).FirstOrCreate(&user)
//// SELECT * FROM users WHERE name = 'non_existing';
//// INSERT INTO "users" (name, age) VALUES ("non_existing", 20);
//// user -> User{Id: 112, Name: "non_existing", Age: 20}

// 找到
db.Where(User{Name: "jinzhu"}).Attrs(User{Age: 30}).FirstOrCreate(&user)
//// SELECT * FROM users WHERE name = 'jinzhu';
//// user -> User{Id: 111, Name: "jinzhu", Age: 20}
```

##### .6.2.8.2 Assign

不管记录是否找到，都将参数赋值给 struct 并保存至数据库.

```go
// 未找到
db.Where(User{Name: "non_existing"}).Assign(User{Age: 20}).FirstOrCreate(&user)
//// SELECT * FROM users WHERE name = 'non_existing';
//// INSERT INTO "users" (name, age) VALUES ("non_existing", 20);
//// user -> User{Id: 112, Name: "non_existing", Age: 20}

// 找到
db.Where(User{Name: "jinzhu"}).Assign(User{Age: 30}).FirstOrCreate(&user)
//// SELECT * FROM users WHERE name = 'jinzhu';
//// UPDATE users SET age=30 WHERE id = 111;
//// user -> User{Id: 111, Name: "jinzhu", Age: 30}
```

#### .6.2.9 高级查询

##### .6.2.9.1 子查询

基于 `*gorm.expr` 的子查询

```go
db.Where("amount > ?", db.Table("orders").Select("AVG(amount)").Where("state = ?", "paid").SubQuery()).Find(&orders)
// SELECT * FROM "orders"  WHERE "orders"."deleted_at" IS NULL AND (amount > (SELECT AVG(amount) FROM "orders"  WHERE (state = 'paid')));
```

##### .6.2.9.2 选择字段

Select，指定你想从数据库中检索出的字段，默认会选择全部字段。

```go
db.Select("name, age").Find(&users)
//// SELECT name, age FROM users;

db.Select([]string{"name", "age"}).Find(&users)
//// SELECT name, age FROM users;

// 返回其参数中第一个非空表达式
db.Table("users").Select("COALESCE(age,?)", 42).Rows()
//// SELECT COALESCE(age,'42') FROM users;
```

##### .6.2.9.3 排序

Order，指定从数据库中检索出记录的顺序。设置第二个参数 `reorder` 为 true ，可以覆盖前面定义的排序条件。

```sql
db.Order("age desc, name").Find(&users)
//// SELECT * FROM users ORDER BY age desc, name;

// 多字段排序
db.Order("age desc").Order("name").Find(&users)
//// SELECT * FROM users ORDER BY age desc, name;

// 覆盖排序
db.Order("age desc").Find(&users1).Order("age", true).Find(&users2)
//// SELECT * FROM users ORDER BY age desc; (users1)
//// SELECT * FROM users ORDER BY age; (users2)
```

##### .6.2.9.4 数量

Limit，指定从数据库检索出的最大记录数。

```sql
db.Limit(3).Find(&users)
//// SELECT * FROM users LIMIT 3;

// -1 取消 Limit 条件
db.Limit(10).Find(&users1).Limit(-1).Find(&users2)
//// SELECT * FROM users LIMIT 10; (users1)
//// SELECT * FROM users; (users2)
```

##### .6.2.9.5 偏移

Offset，指定开始返回记录前要跳过的记录数。

```sql
db.Offset(3).Find(&users)
//// SELECT * FROM users OFFSET 3;

// -1 取消 Offset 条件
db.Offset(10).Find(&users1).Offset(-1).Find(&users2)
//// SELECT * FROM users OFFSET 10; (users1)
//// SELECT * FROM users; (users2)
```

##### .6.2.9.6 总数

Count，该 model 能获取的记录总数。

```sql
db.Where("name = ?", "jinzhu").Or("name = ?", "jinzhu 2").Find(&users).Count(&count)
//// SELECT * from USERS WHERE name = 'jinzhu' OR name = 'jinzhu 2'; (users)
//// SELECT count(*) FROM users WHERE name = 'jinzhu' OR name = 'jinzhu 2'; (count)

db.Model(&User{}).Where("name = ?", "jinzhu").Count(&count)
//// SELECT count(*) FROM users WHERE name = 'jinzhu'; (count)

db.Table("deleted_users").Count(&count)
//// SELECT count(*) FROM deleted_users;

db.Table("deleted_users").Select("count(distinct(name))").Count(&count)
//// SELECT count( distinct(name) ) FROM deleted_users; (count)
```

**注意: Count 必须是链式查询的最后一个操作 ，因为它会覆盖前面的 SELECT；但如果里面使用了 count 时不会覆盖**

##### .6.2.9.7 Group & Having

```sql
rows, err := db.Table("orders").Select("date(created_at) as date, sum(amount) as total").Group("date(created_at)").Rows()
for rows.Next() {
  ...
}

// 使用Scan将多条结果扫描进事先准备好的结构体切片中
type Result struct {
	Date time.Time
	Total int
}
var rets []Result
db.Table("users").Select("date(created_at) as date, sum(age) as total").Group("date(created_at)").Scan(&rets)

rows, err := db.Table("orders").Select("date(created_at) as date, sum(amount) as total").Group("date(created_at)").Having("sum(amount) > ?", 100).Rows()
for rows.Next() {
  ...
}

type Result struct {
  Date  time.Time
  Total int64
}
db.Table("orders").Select("date(created_at) as date, sum(amount) as total").Group("date(created_at)").Having("sum(amount) > ?", 100).Scan(&results)
```

##### .6.2.9.8 连接

Joins，指定连接条件

```sql
rows, err := db.Table("users").Select("users.name, emails.email").Joins("left join emails on emails.user_id = users.id").Rows()
for rows.Next() {
  ...
}

db.Table("users").Select("users.name, emails.email").Joins("left join emails on emails.user_id = users.id").Scan(&results)

// 多连接及参数
db.Joins("JOIN emails ON emails.user_id = users.id AND emails.email = ?", "jinzhu@example.org").Joins("JOIN credit_cards ON credit_cards.user_id = users.id").Where("credit_cards.number = ?", "411111111111").Find(&user)
```

#### .6.2.10 Pluck

> pluck : [plʌk] v. 采摘；扯；n. 胆识，勇气；（供食用的）内脏；快而猛的拉

Pluck，查询 model 中的一个列作为切片，如果您想要查询多个列，您应该使用 Scan

```sql
var ages []int64
db.Find(&users).Pluck("age", &ages)

var names []string
db.Model(&User{}).Pluck("name", &names)

db.Table("deleted_users").Pluck("name", &names)

// 想查询多个字段？ 这样做：
db.Select("name, age").Find(&users)
```

#### .6.2.11 扫描

Scan，扫描结果至一个 struct.

```sql
type Result struct {
  Name string
  Age  int
}

var result Result
db.Table("users").Select("name, age").Where("name = ?", "Antonio").Scan(&result)

var results []Result
db.Table("users").Select("name, age").Where("id > ?", 0).Scan(&results)

// 原生 SQL
db.Raw("SELECT name, age FROM users WHERE name = ?", "Antonio").Scan(&result)
```

### .6.3 链式操作相关

#### .6.3.1 链式操作

Method Chaining，Gorm 实现了链式操作接口，所以你可以把代码写成这样：

```sql
// 创建一个查询
tx := db.Where("name = ?", "jinzhu")

// 添加更多条件
if someCondition {
  tx = tx.Where("age = ?", 20)
} else {
  tx = tx.Where("age = ?", 30)
}

if yetAnotherCondition {
  tx = tx.Where("active = ?", 1)
}
```

**在调用立即执行方法前不会生成 Query 语句**，借助这个特性你可以创建一个函数来处理一些通用逻辑。

#### .6.3.2 立即执行方法

Immediate methods ，**立即执行方法** 是指那些会立即生成 SQL 语句并发送到数据库的方法, 他们**一般是 CRUD 方法**，比如：`Create`, `First`, `Find`, `Take`, `Save`, `UpdateXXX`, `Delete`, `Scan`, `Row`, `Rows`…


这有一个基于上面链式方法代码的立即执行方法的例子：

```sql
tx.Find(&user)
```

生成的 SQL 语句如下：

```sql
SELECT * FROM users where name = 'jinzhu' AND age = 30 AND active = 1;
```

#### .6.3.3 范围

Scopes，Scope 是建立在链式操作的基础之上的。

基于它，你可以抽取一些通用逻辑，写出更多可重用的函数库。

```sql
func AmountGreaterThan1000(db *gorm.DB) *gorm.DB {
  return db.Where("amount > ?", 1000)
}

func PaidWithCreditCard(db *gorm.DB) *gorm.DB {
  return db.Where("pay_mode_sign = ?", "C")
}

func PaidWithCod(db *gorm.DB) *gorm.DB {
  return db.Where("pay_mode_sign = ?", "C")
}

func OrderStatus(status []string) func (db *gorm.DB) *gorm.DB {
  return func (db *gorm.DB) *gorm.DB {
    return db.Scopes(AmountGreaterThan1000).Where("status IN (?)", status)
  }
}

db.Scopes(AmountGreaterThan1000, PaidWithCreditCard).Find(&orders)
// 查找所有金额大于 1000 的信用卡订单

db.Scopes(AmountGreaterThan1000, PaidWithCod).Find(&orders)
// 查找所有金额大于 1000 的 COD 订单

db.Scopes(AmountGreaterThan1000, OrderStatus([]string{"paid", "shipped"})).Find(&orders)
// 查找所有金额大于 1000 且已付款或者已发货的订单
```

#### .6.3.4 多个立即执行方法

Multiple Immediate Methods，在 GORM 中使用多个立即执行方法时，**后一个立即执行方法会复用前一个立即执行方法的条件 (不包括内联条件)** 。

```sql
db.Where("name LIKE ?", "jinzhu%").Find(&users, "id IN (?)", []int{1, 2, 3}).Count(&count)
```

生成的 Sql

```sql
SELECT * FROM users WHERE name LIKE 'jinzhu%' AND id IN (1, 2, 3)

SELECT count(*) FROM users WHERE name LIKE 'jinzhu%'
```

### .6.4 更新

#### .6.4.1 更新所有字段

`Save()` **默认会更新该对象的所有字段**，即使你没有赋值。

```sql
db.First(&user)

user.Name = "七米"
user.Age = 99
db.Save(&user)

////  UPDATE `users` SET `created_at` = '2020-02-16 12:52:20', `updated_at` = '2020-02-16 12:54:55', `deleted_at` = NULL, `name` = '七米', `age` = 99, `active` = true  WHERE `users`.`deleted_at` IS NULL AND `users`.`id` = 1
```

#### .6.4.2 更新修改字段

如果你只希望更新指定字段，可以使用 `Update` 或者 `Updates` 

> 警告：**当使用 struct 更新时，GORM 只会更新那些非零值的字段**

```sql
// 更新单个属性，如果它有变化
db.Model(&user).Update("name", "hello")
//// UPDATE users SET name='hello', updated_at='2013-11-17 21:34:10' WHERE id=111;

// 根据给定的条件更新单个属性
db.Model(&user).Where("active = ?", true).Update("name", "hello")
//// UPDATE users SET name='hello', updated_at='2013-11-17 21:34:10' WHERE id=111 AND active=true;

// 使用 map 更新多个属性，只会更新其中有变化的属性
db.Model(&user).Updates(map[string]interface{}{"name": "hello", "age": 18, "active": false})
//// UPDATE users SET name='hello', age=18, active=false, updated_at='2013-11-17 21:34:10' WHERE id=111;

// 使用 struct 更新多个属性，只会更新其中有变化且为非零值的字段
db.Model(&user).Updates(User{Name: "hello", Age: 18})
//// UPDATE users SET name='hello', age=18, updated_at = '2013-11-17 21:34:10' WHERE id = 111;

// 警告：当使用 struct 更新时，GORM 只会更新那些非零值的字段
// 对于下面的操作，不会发生任何更新，"", 0, false 都是其类型的零值
db.Model(&user).Updates(User{Name: "", Age: 0, Active: false})
```

#### .6.4.3 更新/忽略选定字段

如果你想更新或忽略某些字段，你可以使用 Select，Omit

> Omit [əˈmɪt] vt. 省略；遗漏；删除；疏忽

```sql
db.Model(&user).Select("name").Updates(map[string]interface{}{"name": "hello", "age": 18, "active": false})
//// UPDATE users SET name='hello', updated_at='2013-11-17 21:34:10' WHERE id=111;

db.Model(&user).Omit("name").Updates(map[string]interface{}{"name": "hello", "age": 18, "active": false})
//// UPDATE users SET age=18, active=false, updated_at='2013-11-17 21:34:10' WHERE id=111;
```

#### .6.4.4 无 Hooks 更新

上面的更新操作会自动运行 model 的 `BeforeUpdate`, `AfterUpdate` 方法，更新 `UpdatedAt` 时间戳, 在更新时保存其 `Associations`, 如果你不想调用这些方法，你可以使用 `UpdateColumn`， `UpdateColumns`

```sql
// 更新单个属性，类似于 `Update`
db.Model(&user).UpdateColumn("name", "hello")
//// UPDATE users SET name='hello' WHERE id = 111;

// 更新多个属性，类似于 `Updates`
db.Model(&user).UpdateColumns(User{Name: "hello", Age: 18})
//// UPDATE users SET name='hello', age=18 WHERE id = 111;
```

#### .6.4.5 批量更新

**批量更新时 Hooks（钩子函数）不会运行。**

```sql
db.Table("users").Where("id IN (?)", []int{10, 11}).Updates(map[string]interface{}{"name": "hello", "age": 18})
//// UPDATE users SET name='hello', age=18 WHERE id IN (10, 11);

// 使用 struct 更新时，只会更新非零值字段，若想更新所有字段，请使用map[string]interface{}
db.Model(User{}).Updates(User{Name: "hello", Age: 18})
//// UPDATE users SET name='hello', age=18;

// 使用 `RowsAffected` 获取更新记录总数
db.Model(User{}).Updates(User{Name: "hello", Age: 18}).RowsAffected
```

#### .6.4.6 使用 SQL 表达式更新

先查询表中的第一条数据保存至 user 变量。

```sql
var user User
db.First(&user)
db.Model(&user).Update("age", gorm.Expr("age * ? + ?", 2, 100))
//// UPDATE `users` SET `age` = age * 2 + 100, `updated_at` = '2020-02-16 13:10:20'  WHERE `users`.`id` = 1;

db.Model(&user).Updates(map[string]interface{}{"age": gorm.Expr("age * ? + ?", 2, 100)})
//// UPDATE "users" SET "age" = age * '2' + '100', "updated_at" = '2020-02-16 13:05:51' WHERE `users`.`id` = 1;

db.Model(&user).UpdateColumn("age", gorm.Expr("age - ?", 1))
//// UPDATE "users" SET "age" = age - 1 WHERE "id" = '1';

db.Model(&user).Where("age > 10").UpdateColumn("age", gorm.Expr("age - ?", 1))
//// UPDATE "users" SET "age" = age - 1 WHERE "id" = '1' AND quantity > 10;
```

#### .6.4.7 修改 Hooks 中的值

如果你想修改 `BeforeUpdate`, `BeforeSave` 等 Hooks 中更新的值，你可以使用 `scope.SetColumn`, 例如：

```sql
func (user *User) BeforeSave(scope *gorm.Scope) (err error) {
  if pw, err := bcrypt.GenerateFromPassword(user.Password, 0); err == nil {
    scope.SetColumn("EncryptedPassword", pw)
  }
}
```

#### .6.4.8 其它更新选项

```sql
// 为 update SQL 添加其它的 SQL
db.Model(&user).Set("gorm:update_option", "OPTION (OPTIMIZE FOR UNKNOWN)").Update("name", "hello")
//// UPDATE users SET name='hello', updated_at = '2013-11-17 21:34:10' WHERE id=111 OPTION (OPTIMIZE FOR UNKNOWN);
```

### .6.5 删除

#### .6.5.1 删除记录

警告: **删除记录时，请确保主键字段有值，GORM 会通过主键去删除记录，如果主键为空，GORM 会删除该 model 的所有记录。**

```sql
// 删除现有记录
db.Delete(&email)
//// DELETE from emails where id=10;

// 为删除 SQL 添加额外的 SQL 操作
db.Set("gorm:delete_option", "OPTION (OPTIMIZE FOR UNKNOWN)").Delete(&email)
//// DELETE from emails where id=10 OPTION (OPTIMIZE FOR UNKNOWN);
```

#### .6.5.2 批量删除

删除全部匹配的记录

```sql
db.Where("email LIKE ?", "%jinzhu%").Delete(Email{})
//// DELETE from emails where email LIKE "%jinzhu%";

db.Delete(Email{}, "email LIKE ?", "%jinzhu%")
//// DELETE from emails where email LIKE "%jinzhu%";
```

#### .6.5.3 软删除

**如果一个 model 有 `DeletedAt` 字段，他将自动获得软删除的功能！** 当调用 Delete 方法时， 记录不会真正的从数据库中被删除， 只会将 `DeletedAt` 字段的值会被设置为当前时间。

```sql
db.Delete(&user)
//// UPDATE users SET deleted_at="2013-10-29 10:23" WHERE id = 111;

// 批量删除
db.Where("age = ?", 20).Delete(&User{})
//// UPDATE users SET deleted_at="2013-10-29 10:23" WHERE age = 20;

// 查询记录时会忽略被软删除的记录
db.Where("age = 20").Find(&user)
//// SELECT * FROM users WHERE age = 20 AND deleted_at IS NULL;

// Unscoped 方法可以查询被软删除的记录
db.Unscoped().Where("age = 20").Find(&users)
//// SELECT * FROM users WHERE age = 20;
```

#### .6.5.4 物理删除

```sql
// Unscoped 方法可以物理删除记录
db.Unscoped().Delete(&order)
//// DELETE FROM orders WHERE id=10;
```

## 其他参考：

* [阮一峰：ORM 实例教程](http://www.ruanyifeng.com/blog/2019/02/orm-tutorial.html)
* [GORM 中文文档](https://gorm.io/zh_CN/docs/)