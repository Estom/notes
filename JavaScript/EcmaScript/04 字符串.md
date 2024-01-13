## 大小写转换String 对象提供如下方法，用于大小写转换。| 方法名 | 说明 || --- | --- |
| toUpperCase() | 把字符串转换为大写。|
| toLowerCase() | 把字符串转换为小写。|

```javascript
var msg = 'Hello World';var lowerMsg = msg.toLowerCase();var upperMsg = msg.toUpperCase();console.log( msg );// Hello Worldconsole.log( lowerMsg );// hello worldconsole.log( upperMsg );// HELLO WORLD
```

## 获取指定位置的字符String 对象提供如下方法，用于获取指定位置的字符。| 方法名 | 说明 || --- | --- |
| charAt() | 返回在指定位置的字符。|
| charCodeAt() | 返回在指定的位置的字符的 Unicode 编码。|

```javascript
var str = "HELLO WORLD";console.log( str.charAt(2) );// Lconsole.log( str.charCodeAt(0) );// 72
```

## 检索字符串String 对象提供如下方法，用于检索字符串。| 方法名 | 说明 || --- | --- |
| indexOf() | 返回某个指定的字符串值在字符串中首次出现的位置。|
| lastIndexOf() | 从后向前搜索字符串。|

```javascript
var email = 'tom@163@sohu.com';console.log( email.indexOf( ‘tom’ ) );// 0console.log( email.indexOf( ‘@ ’, 5) );// 7console.log( email.lastIndexOf( ‘@’ ) );// 7console.log( email.lastIndexOf( ‘@’, 5) );// 3console.log( email.indexOf( ‘Mary’ ) );// -1
```

## 截取子字符串String 对象提供如下方法，用于截取子字符串。| 方法名 | 说明 || --- | --- |
| slice() | 提取字符串的片断，并在新的字符串中返回被提取的部分。|
| substr() | 从起始索引号提取字符串中指定数目的字符。|
| substring() | 提取字符串中两个指定的索引号之间的字符。|

```javascript
var msg = 'abc壹贰叁';console.log( msg.slice(2, 4) );// c壹 console.log( msg.substring(2, 4) );// c壹console.log( msg.substr(2, 1) );// cconsole.log( msg.slice(-3, -2) );// 壹
```

## 分隔字符串String 对象提供如下方法，用于分隔字符串。| 方法名 | 说明 || --- | --- |
| split() | 把字符串分割为字符串数组。|

```javascript
var str = '1 2 3 4';str.split(' '); // ['1', '2', '3', '4'];str.split(' ', 3); // ['1', '2', '3'];
```

## 连接字符串String 对象提供如下方法，用于连接字符串。| 方法名 | 说明 || --- | --- |
| concat() | 连接两个或更多字符串，并返回新的字符串。|

```javascript
var s1 = 'AA';var s2 = s1.concat('BB', 'CC', 55);console.log( s1 ); //AAconsole.log( s2 ) ; //AABBCC55
```