#!/bin/bash
#判断用户输入的是什么文件

read -p "Please input a filename: " file
#接收键盘的输入，并赋予变量file
if [ -z "$file" ]
then
    #判断file变量是否为空
    echo "Error, please input a filename"
    # 如果为空，执行程序1，也就是输出报错信息
    exit 1
    # 退出程序，并返回值为Ⅰ(把返回值赋予变量$P）
elif [ ! -e "$file" ]
then
    #判断file的值是否存在
    echo "Your input is not a file!"
    #如1果不存在，则执行程序2
    exit 2
    #退出程序，把并定义返回值为2
elif [ -f "$file" ]
then
    #判断file的值是否为普通文件
    echo "$file is a regulare file!"
    #如果是普通文件，则执行程序3
elif [ -d "$file" ]
then
    #到断file的值是否为目录文件
    echo "$file is a directory!"
    #如果是目录文件，网执行程序4
else
    echo "$file is an other file!"
    #如果以上判断都不是，则执行程序5
fi
```