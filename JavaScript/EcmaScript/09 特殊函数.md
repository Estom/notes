## 匿名函数

JavaScript 可以将函数作为数据使用。作为函数本体，它像普通的数据一样，不一定要有名字。默认名字的函数被称之为匿名函数。 如下示例:

```javascript
function (a){return a;}
```

匿名函数的两种用法:
- 可以将匿名函数作为参数传递给其他函数。这样，接收方函数就能利用所传递的函数来完成某些事情。 - 可以定义某个匿名函数来执行某些一次性任务。 

## 自调函数

所谓自调函数就是在定义函数后自行调用。如下示例:

```javascript
(function(){	alert("javascript");})();
```

上述代码的含义如下:
- 第一对括号，放置的是一个匿名函数。 - 第二对括号的作用，是“立即调用”。 自调函数只需将匿名函数的定义放进一对括号中，然后外面再跟一对括号即可。 自调函数也可以在调用时接收参数，如下示例:

```javascript
(function(name){	alert("hello " + name + "!");})("javascript");// hello javascript
```

上述代码的含义如下:
- 第一个括号中的匿名函数接受一个参数。 - 第二个括号，在调用时，向匿名函数传递参数内容。 

## 回调函数当一个函数作为参数传递给另一个函数时，作为参数的函数被称之为回调函数。```javascript
function add(a, b){	return a() + b();}var one = function(){return 1;}var two = function(){return 2;}alert(add(one,two)); //output 3//可以直接使用匿名函数来替代one()和two()，以作为目标函数的参数alert(add(function(){return 1;}, function(){return 2;}));
```

上述代码中，函数 one() 和 two() 都作为函数 add() 的参数传递。所以函数 one() 和 two() 都是回调函数。
当将函数A传递给函数B，并由B来执行A时，A就成了一个回调函数。如果A还是一个无名函数，就称之为匿名回调函数。
### 回调函数的优点如下:
- 它可以在不做命名的情况下传递函数（这意味着可以节省全局变量）。- 可以将一个函数调用操作委托给另一个函数（这意味着可以节省一些代码编写工作）。- 回调函数也有助于提升性能。## 作为值的函数将一个函数作为另一个函数的结果进行返回，作为结果返回的函数称之为作为值的函数。```javascript
function fn( f, args ){	return f( args );}function add( num ){// 作为值的函数	return num + 10;}var result = fn( add, 10 );console.log( result );// 20
```

上述代码还可以编写成如下方式:

```javascript
function fn( args ){	return add(){		return args + 10;	}}
```

上述两段代码的区别在于:

```javascript
var f = fn( 10 );// function add(){ return 10 + 10; }var result = f();// 20
```