# 第8章Android数据存储于IO接口

-----

> Android 内置了sqlife数据库

## 使用sharePreferences

----

* 使用方法，SharedPreferences负责读取数据，SharedPreferences.Editor负责写入数据。
	* contains()是否包含指定key的数据
	* getAll()获取sharedPreferences数据里全部的keyValue对
	* getXX()得到指定键的值
	* clear()清空用户配置
	* putXxx()存入键值对
	* remove()删除键值对
	* commit()提交修改

* 只能通过Context.getSharedPreferences(String，int)方式来获取Preferences的一个实例。


## File存储

----

* FileInputStream openFileInput(String name)打开应用程序数据文件夹下的那么文件对应的输入流
* FileOutputStream openFileOutput(String name , int mode)打开应用程序数据文件夹下的name文件对应的输出流。模式分别有MODE_PRIVATE(只能被当前程序读写），MODE_APPEND(追加方式，应用程序读写)，MODE_WORLD_READABLE(被其他程序读取)，MODE_WORLD+WRITEABLE(由其他程序读写)
* 相关方法
	* getDir()创建name对应的子目录
	* getFilesDir()获取应用程序的数据文件夹的绝对路径
	* fileList()返回应用程序的数据文件夹下的全部文件
	* deleteFile()删除数据文件夹下的制定文件

* 读取SD卡上的文件
	* Environment.getExternalStorageState()判断是否插入了SD卡
	* Environment.getExternalStorageDirectory()获取外部存储器
	* FileInputStream、FileOutputStream、FileReader、FileWriter读写sd卡内容
	* 权限配置，创建删除文件的权限和向sd卡中写入数据的权限：
	```
	<user-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"/>
	<USER-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
	```


## SQLife数据库

----
* sqlife数据的格式
	一般数据采用的固定的静态数据类型，而SQLite采用的是动态数据类型，会根据存入值自动判断。SQLite具有以下五种常用的数据类型：
	
	NULL: 这个值为空值
	
	VARCHAR(n)：长度不固定且其最大长度为 n 的字串，n不能超过 4000。
	
	CHAR(n)：长度固定为n的字串，n不能超过 254。
	
	INTEGER: 值被标识为整数,依据值的大小可以依次被存储为1,2,3,4,5,6,7,8.
	
	REAL: 所有值都是浮动的数值,被存储为8字节的IEEE浮动标记序号.
	
	TEXT: 值为文本字符串,使用数据库编码存储(TUTF-8, UTF-16BE or UTF-16-LE).
	
	BLOB: 值是BLOB数据块，以输入的数据格式进行存储。如何输入就如何存储,不改  变格式。
	
	DATA ：包含了 年份、月份、日期。
	
	TIME： 包含了 小时、分钟、秒。
* SQLife提供的数据库访问方式：


| 方法名称  | 方法表示含义 |
| -------- |:------------:|
| openOrCreateDatabase(String path,SQLiteDatabase.CursorFactory  factory) | 打开或创建数据库 | 
| insert(String table,String nullColumnHack,ContentValues  values) | 插入一条记录 | 
| delete(String table,String whereClause,String[]  whereArgs) | 删除一条记录 | 
| query(String table,String[] columns,String selection,String[]  selectionArgs,String groupBy,String having,String  orderBy) | 查询一条记录 | 
| update(String table,ContentValues values,String whereClause,String[]  whereArgs) | 修改记录 | 
| execSQL(String sql) | 执行一条SQL语句 | 
|  close() | 关闭数据库 | 

Google公司命名这些方法的名称都是非常形象的。例如openOrCreateDatabase,我们从字面英文含义就能看出这是个打开或创建数据库的方法。

* SQLife进行数据库操作的具体步骤
	1. 获取SQLife对象，它代表了与数据库的链接
	2. 调用SQLife的方法，来执行SQL语句
	3. 操作SQL语句的执行结果，用SimpleCursorAdaptor封装Cursor
	4. 关闭SQLifeDatabase，回收资源。

* SQLite3工具
	* 只支持五中基本数据类型。null,integer,real,text,blob.
	* 使用slite3工具执行相应的命令，能够通过命令行管理数据库
	* 弱类型的数据库，能够将任何数据类型保存到任何数据类型当中,在创建数据库的时候不必声明具体的数据类型。（主键除外）例如：
```
create  table mytest{
 id integer primary key,
 name ,
 gender,
 pass ,
}
```


## SQLife具体的操作方式说明


1. 打开或者创建数据库  
	在Android 中使用SQLiteDatabase的静态方法openOrCreateDatabase(String  path,SQLiteDatabae.CursorFactory  factory)打开或者创建一个数据库。它会自动去检测是否存在这个数据库，如果存在则打开，不存在则创建一个数据库；创建成功则返回一个SQLiteDatabase对象，否则抛出异常FileNotFoundException。
	
	下面是创建名为“stu.db”数据库的代码：
	openOrCreateDatabase(String  path,SQLiteDatabae.CursorFactory  factory)
	参数1  数据库创建的路径
	参数2  一般设置为null就可以了
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	db=SQLiteDatabase.openOrCreateDatabase("/data/data/com.lingdududu.db/databases/stu.db",null);  

2. 创建表  

	创建一张表的步骤很简单：
	
	编写创建表的SQL语句
	调用SQLiteDatabase的execSQL()方法来执行SQL语句
	
	
	下面的代码创建了一张用户表，属性列为：id（主键并且自动增加）、sname（学生姓名）、snumber（学号）
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void createTable(SQLiteDatabase db){   
	//创建表SQL语句   
	String stu_table="create table usertable(_id integer primary key autoincrement,sname text,snumber text)";   
	//执行SQL语句   
	db.execSQL(stu_table);   
	}  

3. 插入数据  
	插入数据有两种方法：
	①SQLiteDatabase的insert(String table,String nullColumnHack,ContentValues  values)方法，
	  参数1  表名称，
	  参数2  空列的默认值
	  参数3  ContentValues类型的一个封装了列名称和列值的Map；
	②编写插入数据的SQL语句，直接调用SQLiteDatabase的execSQL()方法来执行
	第一种方法的代码：
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void insert(SQLiteDatabase db){   
	//实例化常量值   
	ContentValues cValue = new ContentValues();   
	//添加用户名   
	cValue.put("sname","xiaoming");   
	//添加密码   
	cValue.put("snumber","01005");   
	//调用insert()方法插入数据   
	db.insert("stu_table",null,cValue);   
	}   
	
	第二种方法的代码：
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void insert(SQLiteDatabase db){   
	//插入数据SQL语句   
	String stu_sql="insert into stu_table(sname,snumber) values('xiaoming','01005')";   
	//执行SQL语句   
	db.execSQL(sql);   
	}   

4. 删除数据  

	删除数据也有两种方法：
	
	①调用SQLiteDatabase的delete(String table,String whereClause,String[]  whereArgs)方法
	参数1  表名称 
	参数2  删除条件
	参数3  删除条件值数组
	
	②编写删除SQL语句，调用SQLiteDatabase的execSQL()方法来执行删除。
	
	第一种方法的代码：
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void delete(SQLiteDatabase db) {   
	//删除条件   
	String whereClause = "id=?";   
	//删除条件参数   
	String[] whereArgs = {String.valueOf(2)};   
	//执行删除   
	db.delete("stu_table",whereClause,whereArgs);   
	}   
	
	第二种方法的代码：
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void delete(SQLiteDatabase db) {   
	//删除SQL语句   
	String sql = "delete from stu_table where _id = 6";   
	//执行SQL语句   
	db.execSQL(sql);   
	}   

5. 修改数据  
	
	修改数据有两种方法：
	
	①调用SQLiteDatabase的update(String table,ContentValues values,String  whereClause, String[]  whereArgs)方法
	参数1  表名称
	参数2  跟行列ContentValues类型的键值对Key-Value
	参数3  更新条件（where字句）
	参数4  更新条件数组
	
	②编写更新的SQL语句，调用SQLiteDatabase的execSQL执行更新。
	
	第一种方法的代码：
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void update(SQLiteDatabase db) {   
	//实例化内容值 ContentValues values = new ContentValues();   
	//在values中添加内容   
	values.put("snumber","101003");   
	//修改条件   
	String whereClause = "id=?";   
	//修改添加参数   
	String[] whereArgs={String.valuesOf(1)};   
	//修改   
	db.update("usertable",values,whereClause,whereArgs);   
	}   
	
	第二种方法的代码：
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void update(SQLiteDatabase db){   
	//修改SQL语句   
	String sql = "update stu_table set snumber = 654321 where id = 1";   
	//执行SQL   
	db.execSQL(sql);   
	}   

6. 查询数据
	在Android中查询数据是通过Cursor类来实现的，当我们使用SQLiteDatabase.query()方法时，会得到一个Cursor对象，Cursor指向的就是每一条数据。它提供了很多有关查询的方法，具体方法如下：
	
	public  Cursor query(String table,String[] columns,String selection,String[]  selectionArgs,String groupBy,String having,String orderBy,String limit);
	
	各个参数的意义说明：
	
	参数table:表名称
	
	参数columns:列名称数组
	
	参数selection:条件字句，相当于where
	
	参数selectionArgs:条件字句，参数数组
	
	参数groupBy:分组列
	
	参数having:分组条件
	
	参数orderBy:排序列
	
	参数limit:分页查询限制
	
	参数Cursor:返回值，相当于结果集ResultSet
	
	Cursor是一个游标接口，提供了遍历查询结果的方法，如移动指针方法move()，获得列值方法getString()等.
	
	Cursor游标常用方法
	
	方法名称
	方法描述
	getCount()
	获得总的数据项数
	isFirst()
	判断是否第一条记录
	isLast()
	判断是否最后一条记录
	moveToFirst()
	移动到第一条记录
	moveToLast()
	移动到最后一条记录
	move(int offset)
	移动到指定记录
	moveToNext()
	移动到下一条记录
	moveToPrevious()
	移动到上一条记录
	getColumnIndexOrThrow(String  columnName)
	根据列名称获得列索引
	getInt(int columnIndex)
	获得指定列索引的int类型值
	getString(int columnIndex)
	获得指定列缩影的String类型值
	
	下面就是用Cursor来查询数据库中的数据，具体代码如下：
	[sql] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void query(SQLiteDatabase db) {   
		//查询获得游标   
		Cursor cursor = db.query ("usertable",null,null,null,null,null,null);   
		  
		//判断游标是否为空   
		if(cursor.moveToFirst() {   
			//遍历游标   
			for(int i=0;i<cursor.getCount();i++){   
			cursor.move(i);   
			//获得ID   
			int id = cursor.getInt(0);   
			//获得用户名   
			String username=cursor.getString(1);   
			//获得密码   
			String password=cursor.getString(2);   
			//输出用户信息 System.out.println(id+":"+sname+":"+snumber);   
			}   
		}   
	}  

7. 删除指定表  
	编写插入数据的SQL语句，直接调用SQLiteDatabase的execSQL()方法来执行
	[java] view plain copy print?在CODE上查看代码片派生到我的代码片
	private void drop(SQLiteDatabase db){   
	//删除表的SQL语句   
	String sql ="DROP TABLE stu_table";   
	//执行SQL   
	db.execSQL(sql);   
	}   

8. 事务处理  
	beginTransction()开始事务  
	endTransaction()结束事务  
	inTrasaction()判断是否处于事务当中。  
	setTransactionSuccessful()判断事务是提交还是回滚的函数。具体提交回滚是在endTransaction()部分实现。
  
9. SQLiteOpenHelper  
	
	该类是SQLiteDatabase一个辅助类。这个类主要生成一个数据库，并对数据库的版本进行管理。当在程序当中调用这个类的方法getWritableDatabase()或者 getReadableDatabase()方法的时候，如果当时没有数据，那么Android系统就会自动生成一个数据库。 SQLiteOpenHelper 是一个抽象类，我们通常需要继承它，并且实现里面的3个函数：
	1. onCreate（SQLiteDatabase）  
	在数据库第一次生成的时候会调用这个方法，也就是说，只有在创建数据库的时候才会调用，当然也有一些其它的情况，一般我们在这个方法里边生成数据库表。
	
	2.  onUpgrade（SQLiteDatabase，int，int）   
	当数据库需要升级的时候，Android系统会主动的调用这个方法。一般我们在这个方法里边删除数据表，并建立新的数据表，当然是否还需要做其他的操作，完全取决于应用的需求。
	
	3.  onOpen（SQLiteDatabase）：  
	这是当打开数据库时的回调函数，一般在程序中不是很常使用。

	4. synchonized SQLiteDatabase getReadableDatabase()   
	以读写的方式打开数据库对应的SQLliteDatebase对象


	5. synchonized SQLiteDatabase getWritableDatabase()   
	以写的方式打开对应的对象

	6. close  
	关闭所有打开的SQLiteDatabase对象