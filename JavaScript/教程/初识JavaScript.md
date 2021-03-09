**\>变量与数据类型**

\>\>定义：JavaScript，是一种脚本语言（编程语言，用来控制软件应用程序，以文本（ASCIIS）形式保存，在需要时被调用进行解释或编译），广泛应用于客户端网页开发，现在服务端也有应用NODEJS。动态、弱类型、基于原型的语言。像大多数编程语言一样，有变量、类型、流程控制

\>\>变量名称规则：字母下划线或美元符开头，大小写敏感，不允许使用js的关键字或者保留字作为文件名（作为解释性语言的一大优势就是不用考虑变量类型，提前分配孔家，编译过程中，分配空间就行）

\>\>变量类型：整型，浮点型，字符型，字符串。

\>\>变量定义：var 变量名；

（感觉像是C的私生子，有些地方不是那么严格，更加灵活变通）

**\>变量运算**

\>\>自增自减运算

\>\>简化运算。

\>\>字符串之间可以直接进行加法运算，表示连接。

\>\>字符串可以和其它类型的变量加法，表示转换成字符串类型，并连接。

\>数组

\>\>用于存放多个各种类型的数据，便于访问

\>\>数组的定义：

var arr = new array()//参数是数组长度

var arr = [‘a'，'b','c'];//可以直接使用数组内的元素定义

\>\>数组支持嵌套，多重数组（有点类似于存有多种数据的广义表）

\>\>数组一定有length属性，arr.length等于键名中最大值加一。

\>\>数组的长度可以直接在定义数组的时候给出

\>\>数组的定义函数：参数可以是数组，也可以是变量初始化数组中的数据。

\>\>数组的长度可以在任意时候添加，不会出现越界，这就是解释性语言的好处。

**\>对象**

\>\>定义：带有自己的属性和方法的数据类型。含有多个键值对。

var o = {

p:"hello"

}

var 变量声明，o 变量名称，p 键名（属性名）， hello 键值（属性值），
冒号分隔。数据对象的大括号包含，最后加分号。当键名不符合标识符的条件时，必须加引号

\>\>创建语句：

var ogj1 = {};
//大括号，只是声明了这是个对象，但不能说明这个对象属于哪一个类（类和类的对象的理念）

var obj2 = new Object(); //相当于调用对象的构造函数，然后形成一个新的对象

var obj3 = Object.create(null);//想当于调用一个已知对象的构造函数

\>\>对象的引用,如果不同的变量指向同一个对象，他们都称作这个对象的引用，也就是说这些对象指向同一个内存地址，修改其中一个变量的属性，会影响到其他的变量。

\>\>对象属性访的问方式： 对象名.对象的属性。objectName.propertyName //数据成员

\>\>对象方法的访问方式：objectName.methodName(); //成员函数

\>时间类的对象定义：

var now = new Data(); //定义了一个时间对象now

now.setTime（); // 设定时间

now.getTime(); //得到完整的时间

now.getFullYear(); //的到年份

now.getMonth(); //得到月份

now.getData(); //得到日期几号

now.getHours(); //得到小时

now.getMinutes(); //得到分钟

now.getSeconds(); //得到秒

now.getDay(); //星期

\>string类的 对象的使用

对象的定义：

var mystr = “i like javascript”;

var mystr = new String("some string");

对象的访问：

string.toUpperCase();

string.toLowerCase();

string.charAt(number); //返回指定的单个字符

string.indexOf(substring, startpos); //在字符串中寻找子串

string.split(separator, limit);
//将字符串分割为字符串数组,separator是分割符，limit是分割次数

string.substring(startpos,stoppos);
//截取子串，参数分别是起止下标（终止与stop-1）

string.substr(startpos, length);
//截取指定长度的子串，参数分别是起始值、子串长度

\>Math对象(本身就是一个对象而不是类)

\>\>对象成员的使用

Math.PI //圆周率

Math.abs() //绝对值

Math.ceil()/floor()/round() //分别是向上取整，向下取整，四舍五入。

random(); //返回0到1之间的随机数（包含0不包含1）

Math.min() / Math.max(); //返回指定数值中最低值

\>数组类的对象使用

\>\>数组对象的定义方法：

var 数组名 = new Array();

var 数组名 = new Array();

var 数组名 = [元素1，元素2，元素3,,,,,]

\>\>数组对象的使用

数组名[下标] = 值

\>\>数组对象的属性

arr.length //数组的长度

arr.concat(arr1, arr2,arr3.....)
//链接多个数组,不改变数组对象arr，返回值是多个数组的连续

arr.join(separator); //separator是指分割符。

arr.reverse(); //倒序，arr被改变

arr.slice(start, end);
//返回子数组，不包含end，负数表示从末尾开始想前数，不修改原来的数组

arr.sort(方法函数); //如果不指定函数，按Unicode编码的顺序排列
