## 变量

### 变量操作 

* 定义变量

country="china"
number = 10

* 使用变量

$country
${country}
echo "i love you ${country}abcd"

* 重新定义变量

country="hello"

* 只读变量

readonly country = "china"

* 删除变量

unset variable_name

### 变量类型

* 局部变量:在脚本中定义，在当前shell中有效
* 环境变量：所有程序有效
* shell变量：shell设置的特殊变量，有一部分是环境变量

### 特殊变量
```
$0 当前脚本文件名

$n 传递参数：第n个参数

$# 传递参数：参数个数

$* 传递参数：所有参数

$@ 传递参数：所有参数

$? 上个命令的返回至

$$ 当前shell的进程ID
```
### 转义字符

\\

\a

\b

\f

\n

\r

\t

\v

### 命令替换

把一个命令的输出赋值给另一个变量

directory = `pwd`

### 变量替换

... ...

## Shell 运算符

### 算术运算

不支持数学运算，但可以通过shell命令awk expr进行数学运算。

+ - * / % = == ！=

### 关系运算

-eq

-ne

-gt

-lt

-ge

-le

### 布尔运算

!

-o

-a

### 字符串运算

= 检测两个字符串是否相等
!= 字符串不相等
-z 长度是否为零
-n 是否不为零
str 是否为空

## shell字符串

### 单引号限制

单引号内的任何字符原样输出，变量无效，转义字符无效

单引号不允许嵌套

### 双引号

内部可以有变量和转义字符

允许嵌套

### 字符串拼接

"hello $country"

### 字符串长度

${#string}

### 字符串切片

${string:1:4}

### 字符串查找

## shell 数组

### 定义数组

array_name[value0 value1 value2]

array_name[0]=value0

### 使用数组

${array_name[index]}
${array_name[@]}

### 获取数组信息

length = ${#array_name[@]}

## printf 格式化输出函数

$ printf "%d %s\n" 1 "abc"

## 条件语句

### if
if
then
else
fi

### case

case a in
 ;;
 ;;
esac

### for

for a in list
do

done

### while

whle [$a -lt 5]
do

done

### until

util command
do

done

## 函数

function_name(){
    list of commands
    return value
}

## 文件包含

. filename

source filename



