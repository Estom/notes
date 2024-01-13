在 JavaScript 中，函数是一个包含属性和方法的 Function 类型的对象。而原型（Prototype）就是 Function 类型对象的一个属性。
在函数定义时就包含了 prototype 属性，它的初始值是一个空对象。在 JavaScript 中并没有定义函数的原型类型，所以原型可以是任何类型。
原型是用于保存对象的共享属性和方法的，原型的属性和方法并不会影响函数本身的属性和方法。```javascript
function foo(a,b){	return a + b;}console.log( typeof foo.prototype );// object
```

## 获取原型通过如下两种方式可以获取对象的原型，从而设置共享的属性和方法:
- 通过构造函数的 prototype 属性。```javascript
function Person() {	console.log('Person instantiated');}console.log( Person.prototype );
```

- 通过 Object 对象的 getPrototypeOf( obj ) 方法。

```javascript
function Person() {	console.log('Person instantiated');}console.log( Object.getPrototypeOf( Person ) );
```

## 原型的属性和方法通过如下两种方式可以设置原型的属性和方法:

- 原型的属性和方法单独进行定义。```javascript
构造函数.prototype.属性名 = 属性值;构造函数.prototype.方法名 = function(){}
```

- 直接为原型定义一个新对象。```javascript
构造函数.prototype = {	属性名 : 属性值,	方法名 : function(){}}
```

## 自有属性与原型属性- 自有属性: 通过对象的引用添加的属性。其它对象可能无此属性；即使有，也是彼此独立的属性。- 原型属性: 从原型对象中继承来的属性，一旦原型对象中属性值改变，所有继承自该原型的对象属性均改变。

```javascript
function Emp( ename, salary ){	this.ename = ename;	this.salary = salary;}Emp.prototype = { city : "北京市", dept : "研发部" }var emp1 = new Emp("Mary",3800);var emp2 = new Emp("Tom",3000);
```

上述代码的内存结构图如下:

![](19.png)

## 检测自有或原型属性- 使用 hasOwnPrototype() 方法检测对象是否具有指定的自有属性:

```javascript
function Hero(){}var hero = new Hero();console.log( hero.hasOwnPrototype("name") );
```

- 使用 in 关键字检测对象及其原型链中是否具有指定属性:

```javascript
function Hero(){}var hero = new Hero();console.log( "name" in hero );
```

## 扩展属性或方法通过原型可以为指定构造函数或对象扩展其属性或方法，如下代码示例:

```javascript
functon Hero(){}Hero.prototype = {	name : "Mary",	salary : 3800}var hero = new Hero();console.log( hero.name );// Mary
```

## 重写原型属性通过构造函数或对象的自有属性可以重写原型的属性，如下代码示例:

```javascript
functon Hero(){}Hero.prototype = {	name : "Mary",	salary : 3800}var hero = new Hero();hero.name = "Tom";console.log( hero.name );// Tom
```

## 删除属性通过 delete 关键字可以删除对象的属性，如果该对象既具有原型属性又具有自有属性的话，先删除自有属性，再删除原型属性。如下代码示例:

```javascript
functon Hero(){}Hero.prototype = { name : "Mary", salary : 3800 }var hero = new Hero();hero.name = "Tom";delete hero.name;// 删除 Tomconsole.log( hero.name );// Marydelete hero.name;// 删除 Maryconsole.log( hero.name );// undefined
```

## isPrototypeOf() 方法

每个对象中都会具有一个 isPrototypeOf() 方法，该方法用来判断一个对象是否是另一个对象的原型。```javascript
var monkey = {}function Human(){}Human.prototype = monkey;var man = new Human();monkey.isPrototypeOf( man );// true
```

## `__proto__` 属性```javascript
functon Hero(){}Hero.prototype = {	name : "Mary",	salary : 3800}var hero = new Hero();console.log( hero.name );// Mary
```

上述代码说明 hero 对象存在一个指向构造函数 Hero 的原型，这个链接被叫做 `__proto__` 属性。

> **值得注意的是:** `__proto__` 属性与 prototype 属性并不等价。
> 
> - `__proto__` 属性是指定对象的属性。
> - prototype 属性是指定构造函数的属性。
> 
> 再有就是，`__proto__` 属性只能在学习或调试的时候使用。

## 扩展内建对象JavaScript 中的内置对象有些也具有 prototype 属性，利用内置对象的 prototype 属性可以为内置对象扩展属性或方法。
通过原型扩展内置对象的属性和方法非常灵活，根据个性化要求制定 JavaScript 语言的具体内容。
一般建议慎用这种方式，如果 JavaScript 的版本更新时可能会提供个性化的属性或方法，导致冲突。

如下代码示例，利用 Array 对象的 prototype 属性扩展了 inArray() 方法。```javascript
Array.prototype.inArray = function(color){	for(var i = 0, len = this.length; i < len; i++){		if(this[i] === color){			return true;		}	}	return false;}var a = ["red", "green", "blue"];alert(a.inArray("red")); //truealert(a.inArray("yellow")); //false
```