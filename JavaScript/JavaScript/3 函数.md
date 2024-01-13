## 1 定义函数

### 函数
```JavaScript
function abs(x) {
    if (x >= 0) {
        return x;
    } else {
        return -x;
    }
}

var abs = function (x) {
    if (x >= 0) {
        return x;
    } else {
        return -x;
    }
};

abs(10);
```

JavaScript的函数允许传入过多的参数或者过少的参数，也不会影响函数的执行。

### 函数的属性arguments
> 因为javascript中，函数也被看做对象，所以能给变量赋值。也能有函数的属性。

只在函数内部起作用，并且永远指向当前函数的调用者传入的所有参数

```
function foo(x) {
    console.log('x = ' + x); // 10
    for (var i=0; i<arguments.length; i++) {
        console.log('arg ' + i + ' = ' + arguments[i]); // 10, 20, 30
    }
}
foo(10, 20, 30);
```

### 函数的属性rest

用来表示可能的多余的参数
```
function foo(a, b, ...rest) {
    console.log('a = ' + a);
    console.log('b = ' + b);
    console.log(rest);
}

foo(1, 2, 3, 4, 5);
// 结果:
// a = 1
// b = 2
// Array [ 3, 4, 5 ]

foo(1);
// 结果:
// a = 1
// b = undefined
// Array []
```

## 2 变量作用域与解构赋值

### 作用范围

* 使用中括号确定一组作用域。只有函数会区分作用域。
* 作用域内部的变量，只在内部起作用。
* 不同作用域的相同变量相互独立。
* 作用域可以嵌套，外部作用域的变量可以在内部作用域使用，反之不可。
* 作用域可以嵌套，内部作用域的变量可以覆盖外部作用域的变量。

### 变量提升

JavaScript的函数定义有个特点，它会先扫描整个函数体的语句，把所有申明的变量“提升”到函数顶部。

也就是说，你在函数体中变量的声明被提前，但是变量的定义没有提前。

```
function a(){
    var x = 1;
    function b(){
        console.log(x);//x is undefined
        var x = 2;
    } 
}
```
> 因为在函数b中，x的声明提前了，console输出的是，函数b中的x。但是x的定义还在后边，所以x的值是undefined。如果删掉内部的生命，则x是1.

### 全局作用域

不再任何函数体内定义的变量就是全局作用域。

* 默认全局变量window。
* 顶层寒素的定义也被是为一个全局变量，冰杯绑定到window对象。
```
function foo() {
    alert('foo');
}

foo(); // 直接调用foo()
window.foo(); // 通过window.foo()调用
```

### 名字空间

全局变量会绑定到window上，不同的JavaScript文件如果使用了相同的全局变量，或者定义了相同名字的顶层函数，都会造成命名冲突，并且很难被发现。

减少冲突的一个方法是把自己的所有变量和函数全部绑定到一个全局变量中。例如：
```
// 唯一的全局变量MYAPP:
var MYAPP = {};

// 其他变量:
MYAPP.name = 'myapp';
MYAPP.version = 1.0;

// 其他函数:
MYAPP.foo = function () {
    return 'foo';
};

```
把自己的代码全部放入唯一的名字空间MYAPP中，会大大减少全局变量冲突的可能。

### 局部作用域

javascript的变量作用域只有函数内部。在for循环语句块中无法定义具有局部作用域变量的。

可以使用let代替var申请块级作用域变量。


```
function foo() {
    var sum = 0;
    for (let i=0; i<100; i++) {
        sum += i;
    }
    // SyntaxError:
    i += 1;
}
```


### 解构赋值

```
//数组的结构赋值
var [x, y, z] = ['hello', 'JavaScript', 'ES6'];

//嵌套数组的结构赋值
let [x, [y, z]] = ['hello', ['JavaScript', 'ES6']];

//对象的解构赋值
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school',
    address: {
        city: 'Beijing',
        street: 'No.1 Road',
        zipcode: '100001'
    }
};
var {name, address: {city="he", zip}} = person;//使用默认赋值
name; // '小明'
city; // 'Beijing'
zip; // undefined, 因为属性名是zipcode而不是zip
// 注意: address不是变量，而是为了让city和zip获得嵌套的address对象的属性:
address; // Uncaught ReferenceError: address is not defined
```



## 3 变量的引用

* JavaScript中的变量都是引用。所以直接赋值，会将引用传递给另一个变量。应该通过创建新的类型，然后进行值的复制。

```
a={r:1};
b=a;
a.x=5;
b;//{r:1,x=5}
```

## 4 箭头函数

### 箭头函数的定义
```
x => x*x

(x, y) => x * x + y * y

// 无参数:
() => 3.14

// 可变参数:
(x, y, ...rest) => {
    var i, sum = x + y;
    for (i=0; i<rest.length; i++) {
        sum += rest[i];
    }
    return sum;
}
```

### 箭头函数的this

箭头函数内this指针指向当前词法作用域的对象。指向函数外层的对象。而且this指针无法更高绑定。

```
var obj = {
    birth: 1990,
    getAge: function () {
        var b = this.birth; // 1990
        var fn = () => new Date().getFullYear() - this.birth; // this指向obj对象
        return fn();
    }
};
obj.getAge();//25
```

## 6 generator函数

### generator函数定义

```
function* foo(x) {
    yield x + 1;
    yield x + 2;
    return x + 3;
}
```
### generator函数调用
```
function* fib(max) {
    var
        t,
        a = 0,
        b = 1,
        n = 0;
    while (n < max) {
        yield a;
        [a, b] = [b, a + b];
        n ++;
    }
    return;
}
```

直接调用调用，仅仅创建了一个generator对象，没有执行函数。不断调用next()方法，可以执行generator函数执行。每次遇到yield返回一次。
```
var f = fib(5);//一个generator对象
f.next(); // {value: 0, done: false}
f.next(); // {value: 1, done: false}
f.next(); // {value: 1, done: false}
f.next(); // {value: 2, done: false}
f.next(); // {value: 3, done: false}
f.next(); // {value: undefined, done: true}
```

利用for of方法访问generator对象。

```
for (var x of fib(10)) {
    console.log(x); // 依次输出0, 1, 1, 2, 3, ...
}
```

### 特点
因为generator可以在执行过程中多次返回，所以它看上去就像一个可以记住执行状态的函数，利用这一点，写一个generator就可以实现需要用面向对象才能实现的功能。

generator还有另一个巨大的好处，就是把异步回调代码变成“同步”代码。


简单来说，就是一个局部状态变量。



## 7 装饰器

> （java中称为注解，Python也称为装饰器）

因为JavaScript是脚本语言所有的对象、变量都是动态的。可以随时解绑。可以利用重新绑定的方法，修改原来的函数，为原来的函数添加装饰器。
```
//统计函数的执行次数
var count = 0;
var oldParseInt = parseInt; // 保存原函数

window.parseInt = function () {
    count += 1;
    return oldParseInt.apply(null, arguments); // 调用原函数
};
```




