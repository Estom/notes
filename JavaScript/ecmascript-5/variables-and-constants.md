## 变量

### 什么是变量变量是存储数据信息的容器。变量被认为是有名字的容器。在代码中，使用变量名为值命名，需要遵守一定的规则。> **值得注意的是:** 
> 
> - 在 JavaScript 代码中，必须先声明一个变量，这个变量才能被使用。
> - JavaScript 中的变量是弱类型的，也称之为松散类型的。所谓弱类型/松散类型就是可以用来保存任何类型的数据。```javascript
var v = 100;v = "string";
```

### 变量的声明在 JavaScript 代码中，使用变量前应当先声明。变量是使用关键字 `var` 声明的。#### 只声明未初始化，变量的值自动取值为 undefined- 一行代码只声明一个变量:

```javascript
var sum;// 值为undefinedvar msg;// 值为undefined
```

- 一行代码声明多个变量

```javascript
var x, y, z;// 值为undefined
```

### 将变量的声明和初始化合写在一起

- 一行代码只声明一个变量并赋值:

```javascript
var sum = 100;// 值为 100var msg = "this is message";// 值为 this is message
```

- 一行代码声明多个变量并赋值:

```javascript
var x = 0, y = 1, z = 2;
```

> **值得注意的是:** 等号（=）是赋值运算符。### 命名规则变量的命名需要遵守一定的规则的，具体规则如下:

- 必须以字母、下划线（_）、美元符号（$）开始。
- 不能以数字开头。
- 不能使用关键字和保留字作为名称。
- 由于 JavaScript 是区分大小写的，大写字母与小写字母并不冲突。
- 名称最好有明确的含义。
- 可以采用“下划线命名法”、“小驼峰命名法”或“大驼峰命名法” 之一，在开发团队内进行协调统一。

### 声明的问题#### 重复的声明使用 `var` 语句重复声明变量是合法且无害的。但是如果重复声明并初始化的，这就表示重复声明并初始化。由于 JavaScript 变量只能存储一个数据，之前存储的数据会被覆盖。```javascript
var msg = "this is message";// 值为 this is messagevar msg = 100;// 值为 100
```

#### 遗漏的声明- 直接读取一个没有声明的变量的值，JavaScript会报错。- 为一个没有声明的变量初始化，是合法的，但并不推荐这样使用。### 变量的使用对声明的变量既可以读取操作，也可以赋值操作。- 读取操作```javascript
var message;// 只声明未初始化console.log(message);// 输出 undefinedvar msg = “this is message”;// 声明并初始化console.log(msg);// 输出 this is message
```

- 赋值操作```javascript
var message;// 只声明未初始化message = "this is message";// 初始化操作var msg = "this is message";// 值会被覆盖msg = "this is another message";// 重新赋值
```

## 常量

### 什么是常量常量就是一个只读（read-only）的变量。常量与变量类似，同样用于存储数据信息。只是常量的数据一旦被定义，便不能被修改。> **值得注意的是:** 
> 
> - 常量名习惯使用全大写形式。
> - ECMAScript 5新增了声明常量使用的关键字 const。
> - 如果省略const关键字，JavaScript会认为是一个变量。### 常量的声明- 在 ECMAScript 5 版本前，没有定义常量的语法。使用 `var` 关键字定义变量，人为规定值不改变，也可以是不严格的常量。```javascript
var MY_CONST = 10;
```

- 在 ECMAScript 5 版本后，提供了关键字 `const` 定义常量。```javascript
const MY_FAV = 100;
```

> **值得注意的是:** 常量的声明，必须进行初始化操作，否则会报错误。
> 
> ```javascript
> const FOO; // SyntaxError: missing = in const declaration
> ```

### 常量的使用常量一旦被声明并初始化，值并不能被改变。常量的使用只能进行读取操作:

```javascript
// 定义常量MY_FAV并赋值7const MY_FAV = 7;// 在 Firefox 和 Chrome 这会失败但不会报错(在 Safari这个赋值会成功)MY_FAV = 20;console.log(MY_FAV); // 输出 7const MY_FAV = 20; // 尝试重新声明会报错 var MY_FAV = 20;// MY_FAV 保留给上面的常量，这个操作会失败console.log(MY_FAV);// MY_FAV 依旧为7
```
