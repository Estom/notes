> 详情参考
> [awk参考文档](../Linux工具命令/awk.md)
> [awk常用函数](https://www.runoob.com/w3cnote/awk-built-in-functions.html)
## 1 awk基本使用

### 使用格式
```
[root@localhost ~]$ awk‘条件1{动作1} 条件2{动作2}…’ 文件名
条件（Pattern）:
	一般使用关系表达式作为条件。这些关系表达式非常多，例如:
	x > 10  判断变量x是否大于10
	x == y  判断变量x是否等于变量y
	A ~ B   判断字符串A中是否包含能匹配B表达式的子字符串
	A !~ B  判断字符串A中是否不包含能匹配B表达式的子字符串
	
动作（Action） :
	格式化输出
	流程控制语句

常用参数：

   -F	指定输入时用到的字段分隔符
   -v	自定义变量
   -f	从脚本中读取awk命令
   -m	对val值设置内在限制
```

### 基本原理
* 按行来读入的。执行步骤
  1. 如果有BEGIN条件，则先执行BEGIN定义的动作。
  2. 如果没有BEGIN条件，则读入第一行，把第一行的数据依次赋予$0、$1、$2等变量。其中$0代表此行的整体数据，$1代表第一字段，$2代表第二字段。
  3. 依据条件类型判断动作是否执行。如果条件符合，则执行动作，否则读入下一行数据。如果没有条件，则每行都执行动作。
  4. 读入下一行数据，重复执行以上步骤
* 条件{动作} 多个条件动作之间是管道流式关系。
### 内置变量
| awk内置变量 | 作用                                                  |
|---------|-----------------------------------------------------|
| $0      | 代表目前awk所读入的整行数据。我们已知awk是一行一行读入数据的，$0就代表当前读入行的整行数据。  |
| $n      | 代表目前读入行的第n个字段。比如，$1表示第1个字段(列)，$2表示第2个字段(列)，如此类推     |
| NF      | 当前行拥有的字段（列）总数。                                      |
| NR      | 当前awk所处理的行，是总数据的第几行。                                |
| FS      | 用户定义分隔符。awk的默认分隔符是任何空格，如果想要使用其他分隔符（如“:”），就需要FS变量定义。 |
| ARGC    | 命令行参数个数。                                            |
| ARGV    | 命令行参数数组。                                            |
| FNR     | 当前文件中的当前记录数（对输入文件起始为1）。                             |
| OFMT    | 数值的输出格式（默认为%.6g）。                                   |
| OFS     | 输出字段的分隔符（默认为空格）。                                    |
| ORS     | 输出记录分隔符（默认为换行符）。                                    |
| RS      | 输入记录分隔符（默认为换行符）。                                    |

```
awk常用统计实例
1、打印文件的第一列(域) ：
 awk '{print $1}' filename
 
2、打印文件的前两列(域) ：
 awk '{print $1,$2}' filename
 
3、打印完第一列，然后打印第二列 ： 
awk '{print $1 $2}' filename

4、打印文本文件的总行数 ： 
awk 'END{print NR}' filename

5、打印文本第一行 ：
awk 'NR==1{print}' filename

6、打印文本第二行第一列 ：
sed -n "2, 1p" filename | awk 'print $1'



1. 获取第一列
ps -aux | grep watchdog | awk '{print $1}'

2. 获取第一列，第二列，第三列
ps -aux | grep watchdog | awk '{print $1, $2, $3}'

3. 获取第一行的第一列，第二列，第三列
ps -aux | grep watchdog | awk 'NR==1{print $1, $2, $3}'

4. 获取行数NR
df -h | awk 'END{print NR}'

5. 获取列数NF（这里是获取最后一行的列数，注意每行的列数可能是不同的）
ps -aux | grep watchdog | awk 'END{print NF}'

6. 获取最后一列
ps -aux | grep watchdog | awk '{print $NF}'

7. 对文件进行操作
awk '{print $1}' fileName

8. 指定分隔符（这里以:分割）
ps -aux | grep watchdog |awk  -F':' '{print $1}'

9. 超出范围不报错
ps -aux | grep watchdog | awk '{print $100}

“:”分隔符生效了，可是第一行却没有起作用，原来我们忘记了“BEGIN”条件，那么再来试试;
[root@localhost ~]$ cat /etc/passwd | grep "/bin/bash" | awk 'BEGIN {FS=":"} {printf $1 "\t" $3 "\n"}’

如果我只想看看sshd这个伪用户的相关信息，则可以这样使用:

[root@localhost ~]$ cat /etc/passwd | awk 'BEGIN {FS=":"} $1=="sshd" {printf $1 "\t" $3 "\t 行号:" NR "\t 字段数:" NF "\n"}’
#可以看到sshd 伪用户的UID是74，是/etc/passwd_文件的第28行，此行有7个字段
```
## 2 条件

### 条件类型

| 条件的类型  | 条件    | 说明                                           |
|--------|-------|----------------------------------------------|
| awk保留字 | BEGIN | 在awk程序一开始时，尚未读取任何数据之前执行。BEGIN后的动作只在程序开始时执行一次 |
| awk保留字 | END   | 在awk程序处理完所有数据，即将结束时执行。END后的动作只在程序结束时执行一次     |
| 关系运算符  | &gt;  | 大于                                           |
| 关系运算符  | &lt;  | 小于                                           |
| 关系运算符  | &gt;= | 大于等于                                         |
| 关系运算符  | &lt;= | 小于等于                                         |
| 关系运算符  | ==    | 等于。用于判断两个值是否相等，如果是给变量赋值，请使用“”号               |
| 关系运算符  | !=    | 不等于                                          |
| 关系运算符  | A~B   | 判断字符串A中是否包含能匹配B表达式的子字符串                      |
| 关系运算符  | A!~B  | 判断字符串A中是否不包含能匹配B表达式的子字符串                     |
| 正则表达式  | /正则/  | 如果在"//"中可以写入字符，也可以支持正则表达式                    |

### BEGIN
BEGIN是awk的保留字，是一种特殊的条件类型。BEGIN的执行时机是“在 awk程序一开始时，尚未读取任何数据之前执行”。一旦BEGIN后的动作执行一次，当awk开始从文件中读入数据，BEGIN的条件就不再成立，所以BEGIN定义的动作只能被执行一次。
例如:
```
[root@localhost ~]$ awk 'BEGIN{printf "This is a transcript \n" } {printf $2 "\t" $6 "\n"}’ student.txt
#awk命令只要检测不到完整的单引号不会执行，所以这个命令的换行不用加入“|”,就是一行命令
#这里定义了两个动作
#第一个动作使用BEGIN条件，所以会在读入文件数据前打印“这是一张成绩单”(只会执行一次)
#第二个动作会打印文件的第二字段和第六字段
```

### END

END也是awk保留字，不过刚好和BEGIN相反。END是在awk程序处理完所有数据，即将结束时执行。END后的动作只在程序结束时执行一次。例如:

```
[root@localhost ~]$ awk 'END{printf "The End \n"} {printf $2 "\t" $6 "\n"}’ student.txt
#在输出结尾输入“The End”，这并不是文档本身的内容，而且只会执行一次
```

### 关系运算符
举几个例子看看关系运算符。假设我想看看平均成绩大于等于87分的学员是谁，就可以这样输入命令:
例子1:
```
[root@localhost ~]$ cat student.txt | grep -v Name | awk '$6 >= 87 {printf $2 "\n"}'
#使用cat输出文件内容，用grep取反包含“Name”的行
#判断第六字段（平均成绩）大于等于87分的行，如果判断式成立，则打第六列（学员名$2）
```

```
[root@localhost ~]$ awk '$2 ~ /AAA/ {printf $6 "\n"}' student.txt
#如果第二字段中输入包含有“Sc”字符，则打印第六字段数据
85.66
```

### 正则表达式
如果要想让awk 识别字符串，必须使用“//”包含，例如:

```
[root@localhost ~]$ awk '/Liming/ {print}’student.txt
#打印Liming的成绩
```
当使用df命令查看分区使用情况是，如果我只想查看真正的系统分区的使用状况，而不想查看光盘和临时分区的使用状况，则可以:

```
[root@localhost ~]$ df -h | awk '/sda[O-9]/ {printf $1 "\t" $5 "\n"}’
#查询包含有sda数字的行，并打印第一字段和第五字段
```

## 3 动作

### 变量定义

```
[root@localhost ~]$ awk 'NR==2 {php1=$3}
NR==3 {php2=$3}
NR==4 {php3=$3;totle=phpl+php2+php3;print "totle php is " totle}’ student.txt
#统计PHIP成绩的总分
```
### 流程控制

* if实现动作中的流程控制。

```
在看看该如何实现流程控制，假设如果Linux成绩大于90，就是一个好男人
[root@localhost ~]$ awk '{if (NR>=2) {if ($4>60) printf $2 "is a good man!\n"}}’ student.txt
#程序中有两个if判断，第一个判断行号大于2，第二个判断Linux成绩大于90分
Liming is a good man !
Sc is a good man !
```
* xawk中 if判断语句，完全可以直接利用awk自带的条件来取代，刚刚的脚本可以改写成这样:
```
[root@localhost ~]$  awk ’NR>=2 {test=$4}
test>90 {printf $2 "is a good man! \n"}’ student.txt
#先判断行号如果大于2，就把第四字段赋予变量test
#在判断如果test的值大于90分，就打印好男人
Liming is a good man!
Sc is a good man!
```

### 注意事项

在awk编程中，因为命令语句非常长，在输入格式时需要注意以下内容:

* 多个条件 {动作} 可以用空格分割，也可以用回车分割。
* 在一个动作中，如果需要执行多个命令，需要用 “;” 分割，或用回车分割。
* 在awk中，变量的赋值与调用都不需要加入“$”符。
* 条件中判断两个值是否相同，请使用 “==”，以便和变量赋值进行区分。

## 4 函数
awk函数的定义方法如下:
```
function 函数名（参数列表）{
	函数体
}
```

```
函数来打印student.txt的学员姓名和平均成绩，应该这样来写函数
[root@localhost ~]$ awk 'function test(a,b) { printf a "\t" b "\n"}
#定义函数test，包含两个参数，函数体的内容是输出这两个参数的值
{ test($2,$6) } ' student.txt
#调用函数test，并向两个参数传递值。
Name    Average
AAA      87.66
BBB      85.66
CCC      91.66
```
### 内置函数
https://blog.51cto.com/u_15794314/5682471

gsub(r,s) 在整个$0中用s替代r；gsub(r,s,t) 在整个t中用s替代r

gsub函数有点类似于sed查找和替换。它允许替换一个字符串或字符为另一个字符串或字符，并以正则表达式的形式执行。第一个函数作用于记录$0，第二个gsub函数允许指定目标，然而，如果未指定目标，缺省为$0。
index(s,t)：函数返回目标字符串s中查询字符串t的首位置。
length(s) ：返回s长度
match(s,r)： 测试s是否包含匹配r的字符串
split(s,a,fs) 在fs上将s分成序列a
sprint (fmt,exp) ：函数类似于printf函数(以后涉及)，返回基本输出格式fmt的结果字符串exp。
sub(r,s) 用$0中最左边最长的子串代替s
substr(s,p) 返回字符串s中从p开始的后缀部分
substr(s,p,n) 返回字符串s中从p开始长度为n的后缀部分。
match函数测试字符串s是否包含一个正则表达式r定义的匹配。
split使用域分隔符fs将字符串s划分为指定序列a。

## 5 脚本
对于小的单行程序来说，将脚本作为命令行自变量传递给awk是非常简单的，而对于多行程序就比较难处理。当程序是多行的时候，使用外部脚本是很适合的。首先在外部文件中写好脚本，然后可以使用awk的-f选项，使其读入脚本并且执行。

* 编写脚本
```
[root@localhost ~]$ vi pass.awk
BEGIN {FS=":"}
{ print $1 "\t"  $3}
```

* 然后可以使用“一f”选项来调用这个脚本:
```
[root@localhost ~]$ awk -f pass.awk /etc/passwd
rooto
bin1
daemon2
…省略部分输出…
```

### 将外部变量值传递给awk  

借助 **`-v`选项** ，可以将外部值（并非来自stdin）传递给awk：

```shell
VAR=10000
echo | awk -v VARIABLE=$VAR '{ print VARIABLE }'
```

另一种传递外部变量方法：

```shell
var1="aaa"
var2="bbb"
echo | awk '{ print v1,v2 }' v1=$var1 v2=$var2
```

当输入来自于文件时使用：

```shell
awk '{ print v1,v2 }' v1=$var1 v2=$var2 filename
```

## 6 应用场景

```shell
[root@localhost ~]$ vi student.txt
ID      Name    php  	 Linux  	MySQL 	  Average
1       AAA      66         66       66           66
2       BBB      77         77       77           77
3       CCC      88         88       88           88
```

### 输出指定行

```
[root@localhost ~]$ awk '{printf $2 "\t" $6 "\n"}’ student.txt
#输出第二列和第六列
```