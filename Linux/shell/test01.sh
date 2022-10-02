#!/bin/bash
echo "第一个参数"$0
echo "第二个参数$1"
echo "第三个参数`echo $2`"
echo "第四个参数${3}"
echo "第五个参数$(echo $4)"

for i in "$*"
#定义for循环，in后面有几个值，for会循环多少次，注意“$*”要用双引号括起来
#每次循环会把in后面的值赋予变量i
#Shell把$*中的所有参数看成是一个整体，所以这个for循环只会循环一次
	do
		echo "The parameters is: $i"
		#打印变量$i的值
	done
x=1
#定义变量x的值为1
for y in "$@"
#同样in后面的有几个值，for循环几次，每次都把值赋予变量y
#可是Shel1中把“$@”中的每个参数都看成是独立的，所以“$@”中有几个参数，就会循环几次
	do
		echo "The parameter$x is: $y"
		#输出变量y的值
		x=$(( $x +1 ))
		#然变量x每次循环都加1，为了输出时看的更清楚
	done

