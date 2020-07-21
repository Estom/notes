## 1 JSON 简介

JSON 是存储和传输数据的格式。

JSON 经常在数据从服务器发送到网页时使用。

* JSON 指的是 JavaScript Object Notation
* JSON 是轻量级的数据交换格式
* JSON 独立于语言 *
* JSON 是“自描述的”且易于理解


## 2 JSON使用
### 基本语法

* 数据是名称/值对
* 数据由逗号分隔
* 花括号保存对象
* 方括号保存数组
### JSONObject
JSON 数据的书写方式是名称/值对。

名称/值对由（双引号中的）字段名构成，其后是冒号，再其后是值：
JSON 对象是在花括号内书写的。
```
{"firstName":"Bill", "lastName":"Gates"} 
```
### JSONArray
JSON 数组在方括号中书写。

```
"employees":[
    {"firstName":"Bill", "lastName":"Gates"}, 
    {"firstName":"Steve", "lastName":"Jobs"}, 
    {"firstName":"Alan", "lastName":"Turing"}
]
```
### JSONString
```
var text = '{ "employees" : [' +
'{ "firstName":"Bill" , "lastName":"Gates" },' +
'{ "firstName":"Steve" , "lastName":"Jobs" },' +
'{ "firstName":"Alan" , "lastName":"Turing" } ]}';
```
### JSONString转换为JavaScript对象
```
var obj = JSON.parse(text);
```

### JavaScript对象转换为JSONString

```
var myJSON = JSON.stringify(obj);
```