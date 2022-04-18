## 1 概述

### 1）HTML 5 文档类型

Bootstrap 使用到的某些 HTML 元素和 CSS 属性需要将页面设置为 HTML5 文档类型。

```html
<!DOCTYPE html>
<html lang="zh-CN">
  ...
</html>
```

### 2）移动设备优先

Bootstrap 是移动设备优先的。为了确保适当的绘制和触屏缩放，需要在 `<head>` 之中添加 viewport 元元素。

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

在移动设备浏览器上，通过为 viewport设置 meta 属性为 user-scalable=no 可以禁用其缩放功能。这样禁用缩放功能后，用户只能滚动屏幕，就能让你的网站看上去更像原生应用的感觉。

```html
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
```

### 3）排版与链接

Bootstrap 排版、链接样式设置了基本的全局样式。

* 为 body 元素设置 background-color: #fff;
* 使用 @font-family-base、@font-size-base 和 @line-height-base 变量作为排版的基本参数
* 为所有链接设置了基本颜色 @link-color ，并且当链接处于 :hover 状态时才添加下划线

## 2 布局容器

Bootstrap 提供了以下两种布局容器：

* .container 类用于固定宽度并支持响应式布局的容器。

	| 媒体查询 | 宽度值 |
	| --- | --- |
	| >1200px | 1170px |
	| >992px | 970px |
	| >768px | 750px |
	| 小分辨率 | 100% |

* .container-fluid 类用于 100% 宽度，占据 viewport 的容器。

> **值得注意的是：**这两种 容器类不能互相嵌套。

## 3 栅格系统

### 1）什么是栅格系统

栅格系统用于通过一系列的行（row）与列（column）的组合来创建页面布局，内容就可以放入这些创建好的布局中。

Bootstrap 提供的栅格系统，主要特点如下：

* 行的宽度，可以是固定宽度，也可以是相对宽度（100%）。
* 一行中最多可以包含 12 个列。如果一行中包含的列大于 12，多余的列则被作为一个整体另起一行排列。
* Bootstrap 根据 4 种分辨率提供不同的栅格系统预定义样式。

### 2）栅格系统工作原理

Bootstrap 的栅格系统的工作原理如下：

* 栅格系统必须指定一个容器元素，该元素的 class 必须为 .container（固定宽度）或 .container-fluid（100%宽度）。
* 作为“行”的元素必须作为容器元素的直接子元素，并且 class 设置为 .row。
* 作为“列”的元素必须是“行”元素的直接子元素（**“行”元素的子元素不能直接包含内容，内容应该被包含在“列”元素中。**），并且一行最多允许创建 12 列。
* “列”元素的预定义样式，具体内容请参考 *“3）栅格系统的参数”* 内容。

### 3）栅格系统的参数

Bootstrap 根据 4 种不同的分辨率提供了不同的预定义样式（栅格类）。栅格类适用于与屏幕宽度大于或等于分界点大小的设备 ， 并且针对小屏幕设备覆盖栅格类。

| | **超小屏幕** 手机（<768px）| **小屏幕** 平板（>=768px）| **中等屏幕** 桌面显示器（>=992px）| **大屏幕** 大桌面显示器（>=1200px）|
| --- | --- | --- | --- | --- |
| 栅格系统行为 | 总是水平排列 | 以折叠开始，大于断点成水平方式 | 以折叠开始，大于断点成水平方式 | 以折叠开始，大于断点成水平方式 |
| 容器宽度 | None（自动）| 750px | 970px | 1170px |
| class 前缀 | .col-xs- | .col-sm- | .col-md- | .col-lg- |
| 列数 | 12 | 12 | 12 | 12 |
| 列宽 | 自动 | 60px | 78px | 95px |
| 槽宽 | 30px（每列左右均为 15px）| 30px（每列左右均为 15px）| 30px（每列左右均为 15px）| 30px（每列左右均为 15px）|
| 可嵌套 | 是 | 是 | 是 | 是 |
| 偏移 | 是 | 是 | 是 | 是 |
| 排序 | 是 | 是 | 是 | 是 |

### 4）栅格系统示例

* CSS 代码

```css
body {
	margin-top : 100px;
}
[class*=col-] {
	border : 1px solid black;
	padding-top: 15px;
	padding-bottom: 15px;
}
```

* HTML 代码

```html
<div class="container">
    <h3>三等分列</h3>
    <div class="row">
        <div class="col-md-4">.col-md-4</div>
        <div class="col-md-4">.col-md-4</div>
        <div class="col-md-4">.col-md-4</div>
    </div>
    <h3>三不等分列</h3>
    <div class="row">
        <div class="col-md-3">.col-md-3</div>
        <div class="col-md-6">.col-md-6</div>
        <div class="col-md-3">.col-md-3</div>
    </div>
    <h3>手机、平板电脑和PC桌面不同布局</h3>
    <div class="row">
        <div class="col-md-3 col-sm-6 col-xs-12">col-md-3 col-sm-6 col-xs-12</div>
        <div class="col-md-3 col-sm-6 col-xs-12">col-md-3 col-sm-6 col-xs-12</div>
        <div class="col-md-3 col-sm-6 col-xs-12">col-md-3 col-sm-6 col-xs-12</div>
        <div class="col-md-3 col-sm-6 col-xs-12">col-md-3 col-sm-6 col-xs-12</div>
    </div>
</div>
```

### 5）调整列的顺序

#### a. 列偏移

使用 .col-md-offset-* 类可以将列向右侧偏移。（`*` 表示向右偏移的列数）

```html
<div class="container">
    <h3>列偏移</h3>
    <div class="row">
        <div class="col-md-4">.col-md-4</div>
        <div class="col-md-4 col-md-offset-4">.col-md-4 .col-md-offset-4</div>
    </div>
    <div class="row">
        <div class="col-md-3 col-md-offset-3">.col-md-3 .col-md-offset-3</div>
        <div class="col-md-3 col-md-offset-3">.col-md-3 .col-md-offset-3</div>
    </div>
    <div class="row">
        <div class="col-md-6 col-md-offset-3">.col-md-6 .col-md-offset-3</div>
    </div>
</div>
```

#### b. 嵌套列

在 Bootstrap 的栅格系统允许进行嵌套。所谓**栅格系统嵌套**，就是指在 Bootstrap 栅格系统中的每列中允许包含一个栅格系统。

> 被嵌套的“行”中所包含的列的个数依旧不能超过 12 列。

```html
<div class="container">
    <h3>嵌套列</h3>
    <div class="row">
        <div class="col-sm-9">
            Level 1: .col-sm-9
            <div class="row">
                <div class="col-xs-8 col-sm-6">Level 2: .col-xs-8 .col-sm-6</div>
                <div class="col-xs-4 col-sm-6">Level 2: .col-xs-4 .col-sm-6</div>
            </div>
        </div>
    </div>
</div>
```

#### c. 列排序

通过将栅格系统中的列向右移动（push）或向左移动（pull）来改变列的顺序。

* `.col-md-push-*`表示向右移动
* `.col-md-pull-*`表示向左移动

```html
<div class="container">
    <h3>列排序</h3>
    <div class="row">
        <div class="col-md-9 col-md-push-3">.col-md-9 .col-md-push-3</div>
        <div class="col-md-3 col-md-pull-9">.col-md-3 .col-md-pull-9</div>
    </div>
</div>
``` 

### 6）响应式工具

通过单独或联合使用以下列出的 class，可以针对不同屏幕尺寸隐藏或显示页面内容。

| | **超小屏幕** 手机（<768px）| **小屏幕** 平板（>=768px）| **中等屏幕** 桌面（>=992px）| **大屏幕** 大桌面（>=1200px）|
| --- | :---: | :---: | :---: | :---: |
| .hidden-xs | 隐藏 | 可见 | 可见 | 可见 |
| .hidden-sm | 可见 | 隐藏 | 可见 | 可见 |
| .hidden-md | 可见 | 可见 | 隐藏 | 可见 |
| .hidden-lg | 可见 | 可见 | 可见 | 隐藏 |

```html
<div class="container">
    <h3>响应式工具</h3>
    <div class="row">
        <div class="col-md-3 col-sm-4 hidden-xs">.col-md-3</div>
        <div class="col-md-6 col-sm-8 col-xs-12">.col-md-6</div>
        <div class="col-md-3 hidden-sm hidden-xs">.col-md-3</div>
    </div>
</div>
```

### 7）响应式栅格系统示例

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap栅格系统案例</title>

    <!-- Bootstrap -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!--[if lt IE 9]>
    <script src="bootstrap/js/html5shiv.min.js"></script>
    <script src="bootstrap/js/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<div class="jumbotron">
    <div class="container">
        <h1>Hello, world!</h1>
        <p>This is a template for a simple marketing or informational website. It includes a large callout called a
            jumbotron and three supporting pieces of content. Use it as a starting point to create something more
            unique.</p>
    </div>
</div>

<div class="container">
    <!-- Example row of columns -->
    <div class="row">
        <div class="col-md-4">
            <h2>Heading</h2>
            <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris
                condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis
                euismod. Donec sed odio dui. </p>
            <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Heading</h2>
            <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris
                condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis
                euismod. Donec sed odio dui. </p>
            <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Heading</h2>
            <p>Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Vestibulum id ligula
                porta felis euismod semper. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut
                fermentum massa justo sit amet risus.</p>
            <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div>
    </div>

    <hr>

    <footer>
        <p>&copy; 2015 Company, Inc.</p>
    </footer>
</div>

<script src="bootstrap/js/jquery-1.11.3.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
```
