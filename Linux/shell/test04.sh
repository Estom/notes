[root@localhost ~]$ vi sh/add_dir.sh
#!/bin/bash
#创建目录，判断是否存在，存在就结束，反之创建
echo "当前脚本名称为$0"
if [ $1 -eq 1 ]
then
	echo 'this is 1'
elif [ $1 -eq 2 ]
then
    echo 'this is 2'

else
    echo 'this is else'
fi
