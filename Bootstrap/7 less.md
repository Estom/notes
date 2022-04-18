## Less 概述

### 1）动态样式语言

CSS 是一门非程序式语言，没有变量、函数、作用域等概念。CSS 被称之为 **静态样式语言**，从而导致样式文件的修改和维护困难。

**动态样式语言** 是指，在静态样式语言的基础上，添加了一门真正的语言所必需的元素：变量、数据类型、运算、逻辑结构、函数、继承等，从而大大提高样式的可修改和可维护性。

### 2）什么是 Less

Less 是一门 CSS 预处理语言，它扩展了 CSS 语言，增加了变量、Mixin、函数等特性，使 CSS 更易维护和扩展。

Less 官网：[http://www.lesscss.net/](http://www.lesscss.net/)

### 3）如何使用 Less

#### a. 在客户端使用

* 在 HTML 页面的 `<head>` 元素内引入 `.less` 样式文件（**`rel`**属性值为`stylesheet/less`）。

```css
@base: #f938ab;

.box-shadow(@style, @c) when (iscolor(@c)) {
  box-shadow:         @style @c;
  -webkit-box-shadow: @style @c;
  -moz-box-shadow:    @style @c;
}
.box-shadow(@style, @alpha: 50%) when (isnumber(@alpha)) {
  .box-shadow(@style, rgba(0, 0, 0, @alpha));
}
.box {
  color: saturate(@base, 5%);
  border-color: lighten(@base, 30%);
  div { .box-shadow(0 0 5px, 30%) }
}
```

* 下载 `less.js` 文件，在 `<head>` 元素内引入。

> **值得注意的是：** `less` 样式文件必须在 `less.js` 文件之前引入。

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>在客户端使用Less</title>
    <link rel="stylesheet/less" type="text/css" href="less/css/style.less">
    <script src="less/js/less.js"></script>
</head>
<body>
    <div class="box">
        <h1>标题</h1>
        <p>段落</p>
    </div>
</body>
</html>
```

#### b. 在服务器端使用

在服务器端安装 `less` 的最简单方式就是通过 `npm`（node 的包管理器）。

> Node.js的安装及验证请参考《Node.js安装教程》

* 通过 `npm` 工具包安装 `less`。

```
npm install less -g
```

* 通过以下命令测试 `less` 是否安装成功。

```
lessc
```

##### 命令行方式将 `less` 文件编译成 `css` 文件。

```
lessc style.less > style.css
```

##### 配置 WebStorm 中的 `less`

1. 点击“File”->“Setting”，弹出配置窗口。
2. 点击“Tools”->“File Watchers”。
3. 点击左下角的“加号”，选择`Less`选项。
4. 配置“Program”选项，值为`lessc`的安装路径。

保存配置后，修改任意`less`文件，即可以自动生成一个`css`文件。

> **值得注意的是：**此配置只对当前项目有效。如果创建新项目，必须重新进行配置。

## Less 语法

### 1）注释

CSS 形式的注释在 LESS 中是依然保留的：

```css
/* Hello, I'm a CSS-style comment */
.class { color: black }
```

LESS 同样也支持双斜线的注释, 但是编译成 CSS 的时候自动过滤掉：

```less
// Hi, I'm a silent comment, I won't show up in your CSS
.class { color: white }
```

### 2）变量

变量就是一次声明可以多次使用的数据。

```less
@nice-blue: #5B83AD;

#header { color: @ nice-blue; }
```

输出：

```css
#header { color: #5B83AD; }
```

> **值得注意的是：**LESS 中的变量为完全的‘常量’，所以只能定义一次。

### 3）混合

在 LESS 中可以定义一些通用的属性集为一个class，然后在另一个class中去调用这些属性。

```less
.bordered {
  border-top: dotted 1px black;
  border-bottom: solid 2px black;
}
```

如果需要在其他 class 中引入那些通用的属性集，只需要在任何class中像下面这样调用就可以了。

```less
#menu a {
  color: #111;
  .bordered;
}
.post a {
  color: red;
  .bordered;
}
```

.bordered class里面的属性样式都会在 #menu a 和 .post a中体现出来：

```css
#menu a {
  color: #111;
  border-top: dotted 1px black;
  border-bottom: solid 2px black;
}
.post a {
  color: red;
  border-top: dotted 1px black;
  border-bottom: solid 2px black;
}
```

### 4）带参混合

在 LESS 中，还可以像函数一样定义一个带参数的属性集合：

```less
.border-radius (@radius) {
  border-radius: @radius;
  -moz-border-radius: @radius;
  -webkit-border-radius: @radius;
}
```

然后在其他 class 中像这样调用：

```less
#header {
  .border-radius(4px);
}
.button {
  .border-radius(6px);  
}
```

##### 为参数设置默认值：

```less
.border-radius (@radius: 5px) {
  border-radius: @radius;
  -moz-border-radius: @radius;
  -webkit-border-radius: @radius;
}
```

这样调用：

```less
#header {
  .border-radius;  
}
```

@radius 的值就是 5px。

##### @arguments 变量

@arguments包含了所有传递进来的参数。

```less
.box-shadow (@x: 0, @y: 0, @blur: 1px, @color: #000) {
  box-shadow: @arguments;
  -moz-box-shadow: @arguments;
  -webkit-box-shadow: @arguments;
}
.box-shadow(2px, 5px);
```

将会输出：

```css
box-shadow: 2px 5px 1px #000;
-moz-box-shadow: 2px 5px 1px #000;
-webkit-box-shadow: 2px 5px 1px #000;
```

### 5）嵌套规则

LESS 可以以嵌套的方式编写层叠样式。例如以下案例：

```css
#header { color: black; }
#header .navigation {
  font-size: 12px;
}
#header .logo { 
  width: 300px; 
}
#header .logo:hover {
  text-decoration: none;
}
```

在 LESS 中就可以这样写：

```less
#header {
  color: black;

  .navigation {
    font-size: 12px;
  }
  .logo {
    width: 300px;
    &:hover { text-decoration: none }
  }
}
```

> **值得注意的是：** `&` 符号的使用
> 
> 如果想写串联选择器，而不是写后代选择器，就可以用到 `&` 了。

```less
.bordered {
  &.float {
    float: left; 
  }
  .top {
    margin: 5px; 
  }
}
```

会这样输出：

```css
.bordered.float {
  float: left;  
}
.bordered .top {
  margin: 5px;
}
```

### 6）运算

任何数字、颜色或者变量都可以参与运算。LESS 中允许的计算有`+`、`-`、`*`、`/`和`%`。

```less
@screen-width: 992px;

.col-md-1 {
  width: floor(@screen-width/12);
}
```

将会输出：

```css
.col-md-1 {
  width: 82px;
}
```

### 7）函数

LESS 内置了几十个函数，用于颜色转换、字符串处理和数学运算等。

#### a. Color 函数

```less
lighten(@color, 10%);     // return a color which is 10% *lighter* than @color
darken(@color, 10%);      // return a color which is 10% *darker* than @color

saturate(@color, 10%);    // return a color 10% *more* saturated than @color
desaturate(@color, 10%);  // return a color 10% *less* saturated than @color

fadein(@color, 10%);      // return a color 10% *less* transparent than @color
fadeout(@color, 10%);     // return a color 10% *more* transparent than @color
fade(@color, 50%);        // return @color with 50% transparency

spin(@color, 10);         // return a color with a 10 degree larger in hue than @color
spin(@color, -10);        // return a color with a 10 degree smaller hue than @color

mix(@color1, @color2);    // return a mix of @color1 and @color2
```

例如下述案例：

```less
@base: #f04615;

.class {
  color: saturate(@base, 5%);
  background-color: lighten(spin(@base, 8), 25%);
}
```

将会输出：

```css
.class {
  color: #f6430f;
  background-color: #f8b38d;
}
```

#### b. Math 函数

```less
round(1.67); // returns `2`
ceil(2.4);   // returns `3`
floor(2.6);  // returns `2`
```

### 8）文件导入

LESS 允许创建一个 main 文件（**主要用于引入其他 LESS 文件**）。

> `.less` 后缀可带可不带。

```less
@import "lib.less";
@import "lib";
```

> **值得注意的是：**最后会生成一个 CSS 文件，而不是多个 CSS 文件。

### 9）定制 Bootstrap

#### a. 查看 Bootstrap 源码

打开 Bootstrap 源码包中的 `less` 目录中的 `bootstrap.less` 文件：

```less
// 核心变量和混合类
@import "variables.less";
@import "mixins.less";

// 重置和依赖类
@import "normalize.less";
@import "print.less";
@import "glyphicons.less";

// 核心类
@import "scaffolding.less";
@import "type.less";
@import "code.less";
@import "grid.less";
@import "tables.less";
@import "forms.less";
@import "buttons.less";

// 组件类
@import "component-animations.less";
@import "dropdowns.less";
@import "button-groups.less";
@import "input-groups.less";
@import "navs.less";
@import "navbar.less";
@import "breadcrumbs.less";
@import "pagination.less";
@import "pager.less";
@import "labels.less";
@import "badges.less";
@import "jumbotron.less";
@import "thumbnails.less";
@import "alerts.less";
@import "progress-bars.less";
@import "media.less";
@import "list-group.less";
@import "panels.less";
@import "responsive-embed.less";
@import "wells.less";
@import "close.less";

// 插件类
@import "modals.less";
@import "tooltip.less";
@import "popovers.less";
@import "carousel.less";

// 工具类
@import "utilities.less";
@import "responsive-utilities.less";
```