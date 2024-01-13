## 1 条件判断

### if-else
```
var age = 20;
if (age >= 18) { // 如果age >= 18为true，则执行if语句块
    alert('adult');
} else { // 否则执行else语句块
    alert('teenager');
}
//else是可选的
//如果语句块只有一句话，可以省略大括号。
```

### if-else可以嵌套

```
var age = 3;
if (age >= 18) {
    alert('adult');
} else {
    if (age >= 6) {
        alert('teenager');
    } else {
        alert('kid');
    }
}

if (age >= 6) {
    console.log('teenager');
} else if (age >= 18) {
    console.log('adult');
} else {
    console.log('kid');
}
```

## 2 循环


### for循环

```
var x = 0;
var i;
for (i=1; i<=10000; i++) {
    x = x + i;
}
```

### for-in循环

可以循环数组（列表）和对象（字典）

```
var o = {
    name: 'Jack',
    age: 20,
    city: 'Beijing'
};
for (var key in o) {
    console.log(key); // 'name', 'age', 'city'
}

var a = ['A', 'B', 'C'];
for (var i in a) {
    console.log(i); // '0', '1', '2'
    console.log(a[i]); // 'A', 'B', 'C'
}
```

### while循环

条件循环

```
var x = 0;
var n = 99;
while (n > 0) {
    x = x + n;
    n = n - 2;
}
```

### do-while循环

```
var n = 0;
do {
    n = n + 1;
} while (n < 100);
n; // 100
```

### foreach循环

### for-of循环

### break语句
“跳出”循环。

```
for (i = 0; i < 10; i++) {
    if (i === 3) { break; }
    text += "数字是 " + i + "<br>";
}
```
### continue语句

“跳过”循环中的一个迭代。

```
for (i = 0; i < 10; i++) {
    if (i === 3) { continue; }
    text += "数字是 " + i + "<br>";
} 
```
## 3 条件选择

### switch
Switch case 使用严格比较（===）。
```
switch(表达式) {
     case n:
        代码块
        break;
     case n:
        代码块
        break;
     default:
        默认代码块
} 
```