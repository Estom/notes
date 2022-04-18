JavaScript 中的对象，和其它编程语言中的对象一样，可以比照现实生活中的对象来理解它。 JavaScript 中对象的概念可以比照着现实生活中实实在在的物体来理解。
在 JavaScript 中，一个对象可以是一个单独的拥有属性和类型的实体。拿它和一个杯子做下类比，一个杯子是一个对象，拥有属性。杯子有颜色、图案、重量等等。同样， JavaScript 对象也有属性来定义它的特征。
方法 是关联到某个对象的函数，或者简单地说，一个方法是一个值为某个函数的对象属性。定义方法就象定义普通的函数，除了它们必须被赋给对象的某个属性。

### 对象分类- 内置对象/原生对象就是 JavaScript 语言预定义的对象。在 ECMAScript 标准定义，由 JavaScript 解释器/引擎提供具体实现。- 宿主对象指的是 JavaScript 运行环境提供的对象。一般是由浏览器厂商提供实现（目前也有独立的 JavaScript 解释器/引擎提供实现），主要分为 BOM 和 DOM。- 自定义对象就是由开发人员自主创建的对象。## 创建对象### 对象初始化器方式使用对象初始化器也被称作通过字面值创建对象。通过对象初始化器创建对象的语法如下:

```javascript
var obj = {	property_1: value_1, // property_# 作为一个标示符	property_2: value_2, // 标示符可以是一个数字值	// ...,	"property_n": value_n // 标示符也可以是一个字符串}; 
```

- obj 是创建的对象名称。- 标示符和值都是可选的。### 构造函数方式- 通过 JavaScript 提供的预定义类型的构造函数来创建对象，如下示例:

```javascript
var date = new Date();// 创建一个 Date 对象var str = new String("this is string.");// 创建一个 String 对象var num = new Number(100);// 创建一个 Number 对象
```

- 通过 JavaScript 提供的 Object 类型的构造函数来创建自定义对象，如下示例:

```javascript
var obj = new Object();// 创建一个自定义对象
```

### Object.create() 方法

Object.create() 方法创建一个拥有指定原型和若干个指定属性的对象。语法如下:

```javascript
Object.create(proto, [ propertiesObject ])
```

参数:

- proto 参数: 一个对象，作为新创建对象的原型。- propertiesObject 参数: 可选。该参数对象是一组属性与值，该对象的属性名称将是新创建的对象的属性名称，值是属性描述符。

通过 Object.create() 方法创建一个新对象，同时扩展自有属性:

```javascript
var flyer = {	name : "A380",	speed : 1000 }var plane = Object.create( flyer,{	capacity : { 		value : 555,		writable : true,		enumerable : true 	}});
```

Object.create() 方法的一些特殊用法:

- 创建一个原型为 null 的空对象。```javascript
var obj = Object.create( null );
```

- 实现子类型构造函数的原型继承父类型构造函数的原型。```javascript
Sub.prototype = Object.create( Super.prototype );
```

- 创建普通空对象。```javascript
var obj = Object.create( Object.prototype );// 等效于 var o = {}
```

## 对象的属性

### 定义对象的属性一个 JavaScript 对象有很多属性。一个对象的属性可以被解释成一个附加到对象上的变量。对象的属性和普通的 JavaScript 变量基本没什么区别，仅仅是属性属于某个对象。
- 可以通过点符号来访问一个对象的属性。```javascript
var myCar = new Object();myCar.make = "Ford";myCar.model = "Mustang";myCar.year = 1969;
```

- JavaScript 对象的属性也可以通过方括号访问。对象有时也被叫作关联数组, 因为每个属性都有一个用于访问它的字符串值。```javascript
var myCar = new Object();myCar["make"] = "Ford";myCar["model"] = "Mustang";myCar["year"] = 1969;
```

### 访问对象的属性- JavaScript 可以通过点符号来访问一个对象的属性。

```javascript
var emp = { ename : 'Tom', salary : 3500 };emp.ename = 'Tommy';// 修改属性的值console.log(emp.ename);// 获取属性的值
```

- JavaScript 对象的属性也可以通过方括号访问。```javascript
var emp = { ename : 'Tom', salary : 3500 };emp[ 'ename' ] = 'Tony';// 修改属性的值console.log(emp[ "ename" ]);// 获取属性的值
```

### 遍历（枚举）属性JavaScript 提供了三种原生方法用于遍历或枚举对象的属性:
- for…in 循环: 该方法依次访问一个对象及其原型链中所有可枚举的属性。

```javascript
var emp = { ename : 'Tom', salary : 3500 };

for (var n in emp){
    console.log(n, emp[n]);
}
```
- Object.keys( object ) 方法: 该方法返回一个对象 o 自身包含（不包括原型中）的所有属性的名称的数组。

```javascript
var emp = { ename : 'Tom', salary : 3500 };

var arr = Object.keys(emp);

for (var i=0;i<arr.length;i++){
    console.log(arr[i],emp[arr[i]]);
}
```
- Object.getOwnPropertyNames( object ) 方法: 该方法返回一个数组，它包含了对象 o 所有拥有的属性（无论是否可枚举）的名称。```javascript
var emp = { ename : 'Tom', salary : 3500 };

var arr = Object.getOwnPropertyNames(emp);

for (var i=0;i<arr.length;i++){
    console.log(arr[i],emp[arr[i]]);
}
```

### 属性访问出错当不确定对象是否存在、对象的属性是否存在时，可以使用错误处理结构 try…catch 语句块来捕捉抛出的错误，避免程序异常终止。```javascript
//访问未声明的变量console.log( emp );// ReferenceEerror//访问未声明的属性 var emp = { };console.log( emp.ename );// undefined//访问未声明的属性的成员console.log( emp.ename.length );// TypeError 
```

### 检测对象的属性可以使用如下四种方法检测对象中是否存在指定属性:

- 使用 in 关键字。```javascript
console.log( 'ename' in emp );
```

- 使用 Object 对象的 hasOwnProperty() 方法。```javascript
console.log( emp.hasOwnProperty( 'ename' ));
```

- 使用 undefined 进行判断。```javascript
console.log( emp.ename === undefined );
```

- 使用 if 语句进行判断。```javascript
if( emp.ename ){
	console.log( 'ename属性存在' );
}
```

### 删除对象的属性可以用 delete 操作符删除一个不是继承而来的属性。如下示例:

```javascript
// 创建一个 myobj 对象，具有 a 和 b 属性var myobj = new Object;myobj.a = 5;myobj.b = 12;// 删除 myobj 对象的自有属性 adelete myobj.a;
```

## 对象的方法### 定义对象的方法定义方法就象定义普通的函数，除了它们必须被赋给对象的某个属性。如下示例:

```javascript
var obj = new Object();obj.sayMe = function(){	console.log( "this is me." );}var obj = {	name : "javascript",	sayMe : function(){		console.log( "this is me." );	}}
```

### 调用对象的方法对象方法的调用类似于对象属性的调用，同样具有以下两种方式:

- 通过点符号来访问一个对象的方法。```javascript
var obj = new Object();obj.sayMe = function(){	console.log( "this is me." );}obj.sayMe();// 调用 obj 对象的 sayMe 方法
```

- 也可以通过方括号访问一个对象的方法。```javascript
var obj = {	name : "javascript",	sayMe : function(){		console.log( "this is me." );	}}obj[ "sayMe" ]();// 访问 obj 对象的 sayMe 方法
```

### 删除对象的方法可以用 delete 操作符删除对象的方法，如下示例:

```javascript
var obj = {	name : "javascript",	sayMe : function(){		console.log( "this is me." );	}}delete obj.sayMe;// 这里没有 "()"
```

> **值得注意的是:** 删除对象的方法时，不需要小括号“()”。如果有小括号则删除失败。