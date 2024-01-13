## 1 对象定义

* 在JavaScript中所有事物都是对象。
* 对象也是一个变量，可以包含任意值。`var car = {type:"Fiat", model:500, color:"white"};`

## 2 对象属性

### 定义
* 键值对

### 访问

* person.lastName
* person["lastName"]


## 3 对象方法


### 对象绑定的函数称为方法

```
var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var y = new Date().getFullYear();
        return y - this.birth;
    }
};

xiaoming.age; // function xiaoming.age()
xiaoming.age(); // 今年调用是25,明年调用就变成26了
```

### this变量

* this指针一直指向当前的对象。
* 如果是全局对象，this指向window
* this指向的具体位置，视调用者不同而改变。

```
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25, 正常结果，this指向小明。
getAge(); // NaN,this指向window
```
* 对象的方法中的嵌套方法，this指向不明确（window）。所以，如果在子作用域调用本作用域的内容，定义that进行指针传递。
```
var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};

xiaoming.age(); // 25
```

### apply()
使用函数的apply属性，重新定义this指针的指向。

即，将函数应用到某个对象上。

函数本身的apply方法，它接收两个参数，第一个参数就是需要绑定的this变量，第二个参数是Array，表示函数本身的参数。

```
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25
getAge.apply(xiaoming, []); // 25, this指向xiaoming, 参数为空
```

### call()

使用函数的call属性，同样可以定义this指针的具体指向。

与apply()类似的方法，唯一区别是apply()把参数打包成Array再传入；call()把参数按顺序传入。

比如调用Math.max(3, 5, 4)，分别用apply()和call()实现如下：

```
Math.max.apply(null, [3, 5, 4]); // 5
Math.max.call(null, 3, 5, 4); // 5
```

## 4 new运算符

### 实例
new 运算符创建一个用户定义的对象类型的实例或具有构造函数的内置对象的实例。

```
function Car(make, model, year) {
  this.make = make;
  this.model = model;
  this.year = year;
}

const car1 = new Car('Eagle', 'Talon TSi', 1993);

console.log(car1.make);
// expected output: "Eagle"
```

### 语法

```
new constructor([arguments])
```

### 原理

1. 创建一个空的简单JavaScript对象（即{}）；
2. 链接该对象（即设置该对象的构造函数）到另一个对象 ；
3. 将步骤1新创建的对象作为this的上下文 ；
4. 如果该函数没有返回对象，则返回this。


### 步骤

创建一个用户自定义的对象需要两步：

1. 通过编写函数来定义对象类型。
2. 通过 new 来创建对象实例。