## 原型链构造函数或构造器具有 prototype 属性，对象具有 `__proto__` 属性，这就是之前学习的原型。
如果构造函数或对象 A ，A 的原型指向构造函数或对象 B，B 的原型再指向构造函数或对象 C，以此类推，最终的构造函数或对象的原型指向 Object 的原型。由此形成一条链状结构，被称之为原型链。
按照上述的描述，在 B 中定义的属性或方法，可以直接在 A 中使用并不需要定义。这就是继承，它允许每个对象来访问其原型链上的任何属性或方法。
原型链是 ECMAScript 标准中指定的默认实现继承的方式。

原型链的示意结构图如下:

![](20.png)

### 原型链实现继承```javascript
function A(){	this.name = "a";	this.toString = function(){return this.name};}function B(){	this.name = "b";}function C(){	this.name = "c";	this.age = 18;	this.getAge = function(){return this.age};}B.prototype = new A();C.prototype = new B();
```

上述代码实现的示意图如下:

![](21.png)

### 只继承于原型出于对效率的考虑，尽可能地将属性和方法添加到原型上。可以采取以下方式:
- 不要为继承关系单独创建新对象。- 尽量减少运行时的方法搜索。根据上述方式进行更改后，代码如下:```javascript
function A(){}A.prototype.name = "a";A.prototype.toString = function(){return this.name};function B(){}B.prototype = A.prototype;B.prototype.name = "b";function C(){}C.prototype = B.prototype;C.prototype.name = "c";C.prototype.age = 18;C.prototype.getAge = function(){return this.age};
```

### 原型链的问题原型链虽然很强大，用它可以实现 JavaScript 中的继承，但同时也存在着一些问题。
- 原型链实际上是在多个构造函数或对象之间共享属性和方法。- 创建子类的对象时，不能向父级的构造函数传递任何参数。综上所述，在实际开发中很少会单独使用原型链。## 原型式继承所谓原型式继承，就是定义一个函数，该函数中创建一个临时性的构造函数，将作为参数传入的对象作为这个构造函数的原型，最后返回这个构造函数的实例对象。```javascript
function object( o ){	function F(){}	F.prototype = o;	return new F();}
```

根据原型式继承所总结的 object() 函数实现继承，如下代码示例:

```javascript
var person = {	name : "Mary",	friends : ["Tom","King"]}var anotherPerson = object( person );anotherPerson.friends.push("Rob");console.log(anotherPerson.friends);// Tom, King, Rob
```

这种原型式继承要求必须具有一个对象可以作为另一个对象的基础。上述的原型式继承，也可以利用 Object 的 create() 方法替代自定义的 object() 函数，从而实现规范化。```javascript
var person = {	name : "Mary",	friends : ["Tom","King"]}var anotherPerson = Object.create( person );anotherPerson.friends.push("Rob");console.log(anotherPerson.friends);// Tom, King, Rob
```

> **值得注意的是:** 原型式继承具有与原型链同样的问题。## 借助构造函数无论是原型链还是原型式继承，都具有相同的问题。想要解决这样的问题的话，可以借助构造函数（也可以叫做伪造对象或经典继承）。
这种方式实现非常简单，就是在子对象的构造函数中调用父对象的构造函数。具体可以通过调用 apply() 和 call() 方法实现。
apply() 和 call() 方法都允许传递指定某个对象的 this。对于继承来讲，可以实现在子对象的构造函数中调用父对象的构造函数时，将子对象的 this 和父对象的 this 绑定在一起。根据上述描述，借助构造函数实现继承，如下代码示例:

```javascript
function SuperType(){	this.color = ["red","green","blue"];}function SubType(){	// 继承了SuperType	SuperType.call(this);	// 或 SuperType.apply(this,arguments);}var instance = new SubType();instance.color;// red, green, blue
```

## 组合方式继承组合继承，也叫做伪经典继承，指的是将原型链或原型式继承和借助构造函数的技术组合在一起，发挥二者长处的一种继承方式。
具体实现的思路就是: 

- 使用原型链或原型式继承实现对原型的属性和方法的继承。- 通过借助构造函数实现对实例对象的属性的继承。这样，既通过在原型上定义方法实现了函数的重用，又可以保证每个对象都有自己的专有属性。根据上述描述，组合方式继承，如下代码示例:

```javascript
function SuperType( name ){	this name = name;}SuperType.prototype.sayName = function(){	console.log(this.name);}funtion SubType( name, age ){	SuperType.call( this, name );// 继承属性	this.age = age;}SubType.prototype = SuperType.prototype;// 继承方法
```