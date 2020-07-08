> 参考教程
> * [廖雪峰](https://www.liaoxuefeng.com/wiki/1022910821149312/1023025235359040)
> * [W3school](https://www.w3school.com.cn/js/js_intro.asp)
> * [菜鸟教程](https://www.runoob.com/js/js-intro.html)


## 1 基本使用

### 使用方法
* 直接嵌入<head></head>标签当中。type属性默认是javascript

```
<head>
<script type="text/javacript">

</script>
</head>
```
* 单独放入js文件当中，通过标签引入
```
<head>
<script src=
"/static/js/abc.js">
</head>
```

## 2 基本语法

> 单独语句尽量加分号，自动加分号会导致理解问题。


### 赋值语句
```
var x = 1;
```
### 注释语句
```
//单行注释
/* 多行注释
多行注释*/
```

## 3 数据类型

### Number
> 不区分证书和浮点数
```
123//整数
-0.45//负数、浮点数
1.23e3//科学计数法
NaN//不是数字
Infinity//无限大
```




### bool值
```
true;
false;
```

### null与undefined
```
null; \\表示空值，不等于0，不等于''空字符串。
undefined;\\未定义，没什么用
```

### 字符串
```
'hello';
"world";
"\"\u";//反斜杠转义字符，Unicode字符
`h
ll
o`;//反引号多行字符串
```

### 数组（列表）
```
[1,2,3.14,'hello',null,true];
new Array(1,2,3);
var arr =[1,2,3.14,'hello',null,true];
arr[0];
```
### 对象（字典，集合，键值对）

```
var person ={
    name:'bob',
    age:20,
    tags:['js','web'],
    zipcode:null
};
```
### 变量
```
var a;//不强调类型
var b = 1;
```

## 4 字符串

### 模板字符串
```
var name = 'xiaoming';
var message= "hello" + "world"+name;//两种字符串拼接的办法，通过加号连接。
var message = 'hello world ${name}';//两种字符串拼接的方法，模板字符串
```

### 字符串访问

```
var s = 'Hello,world!';
s.length//长度属性，字符串看成对象。
s[0]//访问字符，字符串看成列表、集合、数组。
s[0]='t';//下标只能访问，不能修改字符串，字符串是不可变的。
```

### 字符串操作
```
var s='Hello';
s.toUpperCase();
s.toLowerCase();
s.indexOf('lo');//字符串首次出现的位置。
s.substring(0,5);//字字符串
```

## 数组

### 数组访问与修改
```
var arr = [1,2,3];
arr.length;//=3
arr.length=6;
arr[1]=99;//数组内容与长度均可变。长度变为6
```
> 如果通过索引赋值时，索引超过了范围，同样会引起Array大小的变化：
```
var arr = [1, 2, 3];
arr[5] = 'x';
arr; // arr变为[1, 2, 3, undefined, undefined, 'x']
```

### 数组的操作
```
var arr = [10,20,'30','xyz'];
arr.indexOf(10);
arr.slice(0,3);//切片操作
arr.push('a','b');//向末尾加入多个元素
arr.pop();//去掉最后一个元素
arr.unshift('a','b');//向开头加入多个元素
arr.shift();//去掉第一个元素并返回。
arr.sort();//默认方法排序。
arr.reverse();//array 反转
arr.splice(2,3,'google',88);//从指定位置开始删除若干元素，然后，添加若干元素。
var added = arr.concat([1,2,3]);//连接另一个数组，并返回新的数组
arr.join('-');//用指定字符连接数组元素
```
### 多维数组

```
var arr= [[1,2,3],[400,500,600],'0'];
arr[1][1];//=500
```

## 6 对象

### 对象访问
```
var xiaoming = {
    name:'xiaoming',
    birth:1990,
    'weight':333
};

xiaoming.name;//'xiaoming'通过点运算符访问。
xiaohong['middle-school'];//访问特殊字符的键。只能用下标的方式。
```

### 对象修改

```
var xiaoming = {
    name: '小明'
};
xiaoming.age; // undefined
xiaoming.age = 18; // 新增一个age属性
xiaoming.age; // 18
delete xiaoming.age; // 删除age属性
xiaoming.age; // undefined
delete xiaoming['name']; // 删除name属性
xiaoming.name; // undefined
delete xiaoming.school; // 删除一个不存在的school属性也不会报错

'name' in xiaoming;//检查属性是否存在。
```

### 

## 7 运算符
> NaN与NaN也不相等。使用isNaN()判断是否为数值类型。
```
+ - * / %;//基本运算符
> < >= <= ==（强制类型转换） ===（包括类型）;//比较运算符
! && || ;//逻辑运算符
```