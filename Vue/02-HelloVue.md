# 1. HelloVuejs

​	如何开始学习Vue，当然是写一个最简单的demo，直接上代码。此处通过cdn`<script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>`获取vuejs。

​	vue是声明式编程，区别于jquery的命令式编程。

## 1.1.  命令式编程

​	原生js做法（命令式编程）

1. 创建div元素，设置id属性
2. 定义一个变量叫message
3. 将message变量放在div元素中显示
4. 修改message数据
5. 将修改的元素替换到div

## 1.2 . 声明式编程

​	vue写法（声明式）

1. 创建一个div元素，设置id属性
2. 定义一个vue对象，将div挂载在vue对象上
3. 在vue对象内定义变量message，并绑定数据
4. 将message变量放在div元素上显示
5. 修改vue对象中的变量message，div元素数据自动改变

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
  <title>HelloVuejs</title>
</head>
<body>
  <div id="app">
      <h2>{{message}}</h2>
      <p>{{name}}</p>
  </div>
  <script>
    //let变量/const常量
    //编程范式：声明式编程
    const app = new Vue({
      el:"#app",//用于挂载要管理的元素
      data:{//定义数据
        message:"HelloVuejs",
        name:"zzz"
      }
    })
  </script>
</body>
</html>
```

​	在谷歌浏览器中按F12，在开发者模式中console控制台，改变vue对象的message值，页面显示也随之改变。

​	`{{message}}`表示将变量message输出到标签h2中，所有的vue语法都必须在vue对象挂载的div元素中，如果在div元素外使用是不生效的。`el:"#app"`表示将id为app的div挂载在vue对象上，data表示变量对象。

# 2. vue列表的展示（v-for）

​	开发中常用的数组有许多数据，需要全部展示或者部分展示，在原生JS中需要使用for循环遍历依次替换div元素，在vue中，使用`v-for`可以简单遍历生成元素节点。

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
  <title>vue列表展示</title>
</head>
<body>
  <div id="app">
      <h2>{{message}}</h2>
      <ul>
        <li v-for="(item, index) in movies" :key="index">{{item}}</li>
      </ul>
  </div>
  <script>
    const app = new Vue({
      el:"#app",//用于挂载要管理的元素
      data:{//定义数据
        message:"你好啊",
        movies:["星际穿越","海王","大话西游","复仇者联盟"]//定义一个数组
      }
    })
  </script>
</body>
</html>
```

显示结果如图所示：

![](https://cdn.jsdelivr.net/gh/krislinzhao/IMGcloud/img/20200508144357.png)

​	`<li v-for="(item, index) in movies" :key="index">{{item}}</li>`item表示当前遍历的元素，index表示元素索引， 为了给 Vue 一个提示，以便它能跟踪每个节点的身份，从而重用和重新排序现有元素，你需要为每项提供一个唯一 `key` 属性。建议尽可能在使用 `v-for` 时提供 `key` attribute，除非遍历输出的 DOM 内容非常简单，或者是刻意依赖默认行为以获取性能上的提升。

因为它是 Vue 识别节点的一个通用机制，`key` 并不仅与 `v-for` 特别关联。

>  不要使用对象或数组之类的非基本类型值作为 `v-for` 的 `key`。请用字符串或数值类型的值。 

# 3. vue案例-计数器

​	使用vue实现一个小计数器，点击`+`按钮，计数器+1，使用`-`按钮计数器-1。

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
  <title>vue计数器</title>
</head>
<body>
  <div id="app">
      <h2>当前计数：{{count}}</h2>
      <!-- <button v-on:click="count--">-</button>
      <button v-on:click="count++">+</button> -->
      <button v-on:click="sub()">-</button>
      <button @click="add()">+</button>
  </div>
  <script>
    const app = new Vue({
      el:"#app",//用于挂载要管理的元素
      data:{//定义数据
        count:0
      },
      methods: {
        add:function(){
          console.log("add")
          this.count++
        },
        sub:function(){
          console.log("sub")
          this.count--
        }
      },
    })
  </script>
</body>
</html>
```

1. 定义vue对象并初始化一个变量count=0

2. 定义两个方法`add`和`sub`，用于对count++或者count--

3. 定义两个button对象，给button添加上点击事件

   在vue对象中使用methods表示方法集合，使用`v-on:click`的关键字给元素绑定监听点击事件，给按钮分别绑定上点击事件，并绑定触发事件后回调函数`add`和`sub`。也可以在回调方法中直接使用表达式。例如：`count++`和`count--`。