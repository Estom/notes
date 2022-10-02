#!/bin/bash
PRICE=$( expr $RANDOM % 10)

TIMES=0

echo "猜测商品的价格0-9"

while true
do
    read -p "请输入猜测的价格：" YOURS
    let TIMES++

    if [ $YOURS -eq $PRICE ]
    then
        echo "right after $TIMES times"
        exit 0
    elif [ $YOURS -gt $PRICE ]
    then
        echo "bigger than price"
    else
        echo "smaller than price"
    fi
done