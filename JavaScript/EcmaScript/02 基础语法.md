## 区分大小写

JavaScript 是一种区分大小写的语言。这意味着 JavaScript 的关键字、变量名、函数名、以及任何其他的标识符必须使用一致的大小写形式。比如 atguigu、Atguigu 或 ATGUIGU 是不同的变量名。

```javascript
var jinyunlong = "jinyunlong";// 定义jinyunlong变量console.log(jinyunlong);// 打印jinyunlong变量var Jinyunlong = "Jinyunlong";// 定义Jinyunlong变量console.log(Jinyunlong);// 打印Jinyunlong变量var JINYUNLONG = "JINYUNLONG";// 定义JINYUNLONG变量console.log(JINYUNLONG);// 打印JINYUNLONG变量
```

> **值得注意的是:** 在 JavaScript 中定义变量名和函数名时应该特别注意。## 空格和换行JavaScript 会忽略出现在代码中的空格、制表符和换行符。
由于可以自由地在代码中使用空格、制表符和换行符，所以采用整齐、一致的缩进来形成统一的编码风格，从而提高代码的可读性显得尤为重要。
JavaScript 还可以识别水平制表符、垂直制表符、换页符等，JavaScript 将以下字符识别为行结束符：换行符、回车符、行分隔符、段分隔符等。回车符加换行符在一起被解析为一个单行结束符。

## 可选的分号JavaScript 的语句一般是以一个分号作为结尾。当然，JavaScript 也允许忽略这个分号。如果省略分号，则由解释器确定语句的结尾，如下述代码：```javascript
var sum = a + b// 即使没有分号也是有效的语句 —— 不推荐var diff = a - b;// 有效的语句 —— 推荐
```

> **值得注意的是:** 在 JavaScript 中，虽然语句结尾的分号不是必需的，但还是建议任何时候都不要省略。使用分号是一个非常好的编程习惯。## 注释在编写 JavaScript 代码时，经常利用注释为代码添加说明。注释的内容会被 JavaScript 解释器/引擎忽略，JavaScript 支持两种格式的注释:

- 单行注释

```javascript
// 这里是单行注释
```

- 多行注释

```javascript
/* * 这里是多行注释 */
```> **值得注意的是:** 上述注释的第二行是以星号开始，但这并不是必需的。## 语句JavaScript代码将多行组合成一个代码块，每个代码块一般是以左花括号（{）开始，以右花括号（}）结束。例如下述代码:```javascript
if(test){	test = false;	alert(test);}
```

> **值得注意的是:** 一般在执行多行代码时才需要语句块，但最好是始终都使用花括号将代码块进行包裹。## 关键字JavaScript 定义了一组具有特定用途的关键字，这些关键字可用于表示语句的开始或结束、或者执行特定操作等。也就是说，定义变量名或、函数名或对象名时不能使用这些名称。![](01.png)

## 保留字JavaScript 除了定义了一组关键字，还定义了一组同样不能作为变量名、函数名或对象名的保留字。保留字可能在将来被作为新的关键字出现的。![](02.png)