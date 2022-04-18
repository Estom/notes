函数是这样的一段 JavaScript 代码，它只定义一次，但可能被执行或调用多次。
简单来说，函数就是一组可重用的代码，你可以在你程序的任何地方调用他。
例如下述代码:

```javascript
function fn(){	console.log("this is function");}
```

## 函数定义定义函数有两种方式:

- 函数声明方式:

```javascript
function fn(){	console.log("this is function");}
```

- 字面量方式:

```javascript
var fun = fnction(){	console.log("this is function");}
```

## 函数调用定义一个函数并不会自动的执行它。定义了函数仅仅是赋予函数以名称并明确函数被调用时该做些什么。调用函数才会真正执行这些动作。- 定义一个函数fn:

```javascript
function fn(){	console.log("this is function");}
```

- 调用函数fn:

```javascript
fn();// 输出字符串 this is function
```

## 函数参数函数的参数就相当于在函数中使用的变量（虽然这个比方不是很准确）。JavaScript 中的函数定义并未制定函数参数的类型，函数调用时也未对传入的参数做任何的类型检查。
函数的参数可以分为以下两种:
- 形参: 出现在函数定义文法中的参数列表是函数的形式参数，简称形参 。简单来说，就是定义函数时使用的参数就是形参。- 实参: 函数调用时实际传入的参数是函数的实际参数，简称实参。 简单来说，就是调用函数时使用的参数就是实参。

> **值得注意的是:** 一般情况下，形参与实参的个数是相同的。但在 JavaScript 中并不强求这一点，在特殊情况下，函数的形参和实参的个数可以不相同。 

```javascript
function fn( one, two ){	console.log( one + two );}fn( 1, 2 );// 输出 3
```

上述代码中，定义函数 fn 时，one 和 two 就是函数的形参；调用函数 fn 时，1 和 2 就是函数的实参。

## return 语句函数还可以包含一个返回语句（return）。当然，这并不是必需的。return 语句使函数可以作为一个值来使用。具体用法如下述代码:

```javascript
function fn( msg ){	return "hello" + msg;}// 变量 fun 的值为 hello atguiguvar fun = fn("atguigu");
```

> **值得注意的是:** return 默认情况下返回的是 undefined。

## 预定义函数

JavaScript 预定义了一组函数，又称为全局函数，允许直接使用。| 函数 | 描述 |
| --- | --- |
| eval( ) | 对一串字符串形式的JavaScript代码字符求值。|
| uneval( ) | 创建的一个Object的源代码的字符串表示。|
| isFinite( ) | 判断传入的值是否是有限的数值。|
| isNaN( ) | 判断一个值是否不是数字值。|
| parseInt( ) | 解析字符串参数，并返回指定的整数。|
| parseFloat( ) | 解析字符串参数，并返回一个浮点数。|
| decodeURI( ) | 对已编码的统一资源标识符(URI)进行解码，并返回其非编码形式。|
| encodeURI( ) | 对统一资源标识符(URI)进行编码，并返回编码后的URI字符串。|

### eval() 函数

eval() 函数用于执行以字符串（String）形式出现的 JavaScript 代码。此函数可以实现动态的执行 JavaScript 代码。具体用法如下述代码:

```javascript
// 定义一个字符串，内容为JavaScript代码var js = "console.log('this is javascript')";// 通过 eval()函数执行上述内容eval(js);// 输出 this is javascript
```

### 字符编码与解码encodeURI() 函数可把字符串作为 URI 进行编码。对以下在 URI 中具有特殊含义的 ASCII 标点符号，encodeURI() 函数是不会进行转义的:```
, / ? : @ & = + $ # 
```decodeURI() 函数可对 encodeURI() 函数编码过的 URI 进行解码。

decodeURI() 函数和 encodeURI() 函数的具体用法如下述代码:```javascript
var uri = "http://www.atguigu.com/Web前端开发工程师";var encode = encodeURI( uri );// 输出 http://www.atguigu.com/Web%E5%89%8D%E7%AB%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E7%A8%8B%E5%B8%88console.log( encode );var decode = decodeURI( encode );// 输出 http://www.atguigu.com/Web前端开发工程师console.log( decode );
```

对以下在 URI 中具有特殊含义的 ASCII 标点符号，可以使用 encodeURIComponent() 函数和decodeURIComponent() 函数。```javascript
var uri = "http://www.atguigu.com/font-end-developer";var encode = encodeURIComponent( uri );// 输出 http%3A%2F%2F www.atguigu.com%2Ffont-end-developerconsole.log( encode );var decode = decodeURIComponent( encode );// 输出 http://www.atguigu.com/font-end-developerconsole.log( decode );
```