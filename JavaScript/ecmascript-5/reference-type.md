引用类型通常被叫做类（class）。但在 ECMAScript 2015 版本之前的 JavaScript 中并没有类的概念，在 JavaScript 中通常叫做对象定义。
也就是说，使用引用类型其实就是使用对象（该内容在后面的章节学习）。
JavaScript 中预定义了很多的引用类型，其中包含之前学习的包装类型 Boolean、Number 和 String。

下述列表罗列了 JavaScript 中所提供的引用类型:

| 引用类型 | 说明 |
| --- | --- |
| Date类型 | 获取和设置当前日期时间。|
| Math类型 | 用于数学计算。 |
| Global类型 | 全局对象，提供全局属性和全局方法。|
| Array类型 | 用于有序的存储多个值。|
| RegExp类型 | 用于对字符串模式匹配及检索替换，是对字符串执行模式匹配的强大工具。|
| Error类型 | 用于匹配代码错误并提供对应提示内容。|
| Functions类型 | 用于定义 JavaScript 中的函数。|
| Object类型 | 用于定义 JavaScript 中的对象。|

### Date类型#### 创建 Date 对象JavaScript 中并没有提供日期的数据类型，而是通过 Date 对象的大量方法对日期和时间进行存储或操作。```javascript
// 使用指定的年月日[时分秒]进行初始化var d1 = new Date(2008, 7, 8);var d2 = new Date(2008, 7, 8, 20, 18, 18);var d3 = new Date( '2008/8/8' ); // 把string转换为Date// 初始化为系统时间var d3 = new Date() var d4 = new Date;var d5 = Date(); // 构建一个string，值为当前系统时间// 初始化为距离计算机元年指定毫秒数的时间 var d6 = new Date(0);var d7 = new Date( 1000*3600*24*365 ); 
```

#### 获取日期方法通过使用如下方法，获取日期和时间:

| 方法 | 说明 |
| --- | --- |
| getDate( ) | 返回Date对象“日期”部分数值(1 ~ 31)。|
| getDay( ) | 返回Date对象“星期”部分的数值(0 ~ 6)。 |
| getFullYear( ) | 返回Date对象“年份”部分的实际数值。|
| getHours( ) | 返回Date对象“小时”部分的数值(0 ~ 23)。|
| getMilliseconds( ) | 返回Date对象“毫秒”部分的数值(0 ~ 999)。|
| getMinutes( ) | 返回Date对象“分钟”部分的数值(0 ~ 59)。 |
| getMonth( ) | 返回Date对象“月份”部分的数值(0 ~ 11)。|
| getSeconds( ) | 返回Date对象“秒”部分的数值(0 ~ 59)。|
| getTime( ) | 返回Date对象与UTC时间1970年1月1日午夜之间相差的毫秒数。|

#### 设置日期方法通过使用如下方法，设置日期和时间:

| 方法 | 说明 |
| --- | --- |
| setDate( ) | 设置Date对象中“日期”部分的数值(1 ~ 31，但不限于)。|
| setFullYear( ) | 设置Date对象中“年份”部分的实际数值。|
| setHours( ) | 设置Date对象中“小时”部分的数值(0 ~ 23，但不限于)。|
| setMilliseconds( ) | 设置Date对象中“毫秒”部分的数值(0 ~ 999，但不限于)。|
| setMinutes( ) | 设置Date对象中“分钟”部分的数值(0 ~ 59，但不限于)。|
| setMonth( ) | 设置Date对象中“月份”部分的数值(0 ~ 11，但不限于)。|
| setSeconds( ) | 设置Date对象中“秒”部分的数值(0 ~ 59，但不限于)。|
| setTime( ) | 以毫秒值设置Date对象。|
| setDate( ) | 设置Date对象中“日期”部分的数值(1 ~ 31，但不限于)。|

#### 日期格式化方法通过使用如下方法，对日期和时间进行格式化:

| 方法 | 说明 |
| --- | --- |
| toString() | 返回Date对象的字符串形式。|
| toDateString() | 返回Date对象“日期”部分(年月日)的字符串形式。|
| toTimeString() | 返回Date对象“时间”部分(时分秒)的字符串形式。|
| toLocaleString() | 基于本地时间格式，返回Date对象的字符串形式。|
| toLocaleDateString() | 基于本地时间格式，返回Date对象“ 日期”部分(年月日)的字符串形式。|
| toLocaleTimeString() | 基于本地时间格式，返回Date对象“时间”部分(时分秒)的字符串形式。|
| toGMTString() | 基于GMT时间格式，返回Date对象的字符串形式。|
| toUTCString() | 基于UTC时间格式，返回Date对象的字符串形式。|

### Math类型JavaScript 为保存数学公式和信息提供了一个公共位置，即 Math 对象。与直接编写的计算功能相比，Math 对象提供的计算功能执行起来要快得多。
Math 对象是 JavaScript 中的一个全局对象，它并没有构造函数，而是直接使用 Math 对象名称即可。如下所示:```javascript
var m = new Math();// 这种写法是错误的console.log( Math.PI );// 直接使用对象名调用属性console.log( Math.random() );// 直接使用对象名调用方法
```

#### Math 对象的属性

Math 对象具有如下成员属性:

| 属性 | 说明 |
| --- | --- |
| E | 返回算术常量 e，即自然对数的底数（约等于2.718）。|
| LN2 | 返回 2 的自然对数（约等于0.693）。|
| LN10 | 返回 10 的自然对数（约等于2.302）。|
| LOG2E | 返回以 2 为底的 e 的对数（约等于 1.414）。|
| LOG10E | 返回以 10 为底的 e 的对数（约等于0.434）。|
| PI | 返回圆周率（约等于3.14159）。|
| SQRT1_2 | 返回2 的平方根的倒数（约等于 0.707）。|
| SQRT2 | 返回 2 的平方根（约等于 1.414）。|

#### Math 对象的方法Math 对象具有如下方法:

| 方法 | 说明 |
| --- | --- |
| abs(x) | 返回数的绝对值。|
| ceil(x) | 对数进行上舍入。|
| exp(x) | 返回 e 的指数。 |
| log(x) | 返回数的自然对数（底为e）。|
| floor(x) | 对数进行下舍入。|
| max(x, y) | 返回 x 和 y 中的最高值。|
| min(x, y) | 返回 x 和 y 中的最低值。|
| pow(x, y) | 返回 x 的 y 次幂。|
| round(x) | 把数四舍五入为最接近的整数。|

#### 三角函数Math 对象提供了常见的三角函数计算的方法:

| 方法 | 说明 |
| --- | --- |
| acos(x) | 返回数的反余弦值。|
| asin(x) | 返回数的反正弦值。|
| atan(x) | 以介于 -PI/2 与 PI/2 弧度之间的数值来返回 x 的反正切值。|
| atan2(x) | 返回从 x 轴到点 (x,y) 的角度（介于 -PI/2 与 PI/2 弧度之间）。|
| cos(x) | 返回数的余弦。|
| sin(x) | 返回数的正弦。|
| tan(x) | 返回角的正切。|

#### 随机数Math 对象提供了生成随机数的方法:

| 方法 | 说明 |
| --- | --- |
| random() | 返回 0 ~ 1 之间的随机数。|

```javascript
i = Math.random();// 0<=i<1var max = 100;i = Math.random()*max ;// 0<=i<maxi = parseInt( Math.random()*max );// 0<=i<maxvar min = 50; i = parseInt( Math.random()*(max-min) ) + min;// min<=i<max
```

### Global 类型#### 全局对象Global（全局）对象是 JavaScript 中最特别的对象，因为这个对象感觉上并不存在似的。
不属于任何其他对象的属性和方法，实际上都是 Global 对象的属性和方法。
事实上，也没有全局属性和全局方法，所有在全局域中定义的属性和方法，都是 Global 对象的属性和方法。例如之前学习的 isNaN( )、parseInt( ) 和 parseFloat( ) 方法等，都是 Global 对象的方法。

#### 全局属性Global 对象提供的属性，即全局属性。在 JavaScript 中的任何位置都可以使用。具体属性如下列表:

| 方法 | 说明 |
| --- | --- |
| Infinity | 正的无穷大的数值。|
| NaN | 某个值是不是数字值。|
| undefined | 未定义的值。|

#### 全局方法Global 对象提供的方法，即全局方法。在 JavaScript 中的任何位置都可以使用。具体方法如下列表:

| 方法 | 说明 |
| --- | --- |
| eval( ) | 对一串字符串形式的JavaScript代码字符求值。|
| uneval( ) | 创建的一个Object的源代码的字符串表示。|
| isFinite( ) | 判断传入的值是否是有限的数值。|
| isNaN( ) | 判断一个值是否不是数字值。|
| parseInt( ) | 解析字符串参数，并返回指定的整数。|
| parseFloat( ) | 解析字符串参数，并返回一个浮点数。|
| decodeURI( ) | 对已编码的统一资源标识符(URI)进行解码，并返回其非编码形式。|
| encodeURI( ) | 对统一资源标识符(URI)进行编码，并返回编码后的URI字符串。|

#### 深入理解 eval( )eval( ) 方法存在安全问题。因为 eval( ) 方法会执行任意传给它的代码，而这段代码可能是未知的或者是来自不信任的源。
大部分使用 eval( ) 方法实现时，都会具有不使用 eval( ) 方法实现的方式。
一般建议在任何情况下，都不要使用 eval( ) 方法。