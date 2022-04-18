## 什么是BOOTSTRAP

### 1）BOOTSTRAP概述

Bootstrap 是 Twitter 公司开发的一个基于 HTML、CSS、JavaScript 的技术框架，符合 HTML、CSS 规范，且代码简介、视觉优美。

Bootstrap 集合 HTML、CSS 和 JavaScript，使用了最新的浏览器技术，为实现快速开发提供了一套前端工具包。使用 Bootstrap 不仅可以构建出非常优雅的 HTML 页面，而且占用资源非常少，使用 gzip 压缩后大小仅用 10KB。并且 Bootstrap 在跨浏览器兼容方面表示也很好。

### 2）选择BOOTSTRAP的理由

* Bootstrap 的 HTML 是基于 HTML5 的最新技术。
* Bootstrap 可以快速实现响应式页面。
* Bootstrap 集成了非常友好的 CSS 样式表，对于非设计人员也可以制作出很漂亮的网页。

### 3）BOOTSTRAP提供的功能

根据 Bootstrap 官网提供的文档，可以知道 Bootstrap 分为以下几个模块：

* 全局 CSS 样式：提供了格栅系统、表格、表单、按钮等集成样式。
* 组件：提供了下拉菜单、输入框、导航、列表组等组件。
* 插件：提供了模态框、滚动监听、警告框、弹出框等插件。

### 4）BOOTSTRAP的版本变化

* 2011年8月，Twitter 推出了 Bootstrap 1 版本，该工具由 Twitter 的设计师 Mark Otto 和 Jacob Thornton 合作完成。
* 2012年1月，Twitter 推出了 Bootstrap 2 版本。相比 Bootstrap 1 版本，Bootstrap 2 添加了响应式设计、采用 12 栏栅格布局，并且清晰地划分出 CSS 布局、组件和插件等功能。
* 2013年8月，Twitter 推出了 Bootstrap 3 版本。在这个版本中，采用移动优先和更好的盒子模型等。并且官方不再支持 IE 7及以下版本的浏览器。
* 目前，Bootstrap 4 只是开发者预览版。

## 下载BOOTSTRAP

### 1）Bootstrap 官网及下载地址

* Bootstrap 官网：[http://getbootstrap.com](http://getbootstrap.com)
* Bootstrap 下载地址：[http://getbootstrap.com/getting-started/#download](http://getbootstrap.com/getting-started/#download)

### 2）Bootstrap 使用的两种方式

* 将 Bootstrap 提供的压缩包下载，导入到工程目录中使用。
* 使用 CDN 加速服务，例如以下内容：

```html
<!-- 新 Bootstrap 核心 CSS 文件 -->
<link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.6/css/bootstrap.min.css">

<!-- 可选的Bootstrap主题文件（一般不用引入） -->
<link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.6/css/bootstrap-theme.min.css">

<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<script src="//cdn.bootcss.com/jquery/1.11.3/jquery.min.js"></script>

<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="//cdn.bootcss.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
```

### 3）Bootstrap 目录结构及说明

下载压缩包之后，将其解压缩到任意目录即可看到以下（压缩版的）目录结构：

```
bootstrap/
├── css/		样式库
│   ├── bootstrap.css				样式文件
│   ├── bootstrap.css.map
│   ├── bootstrap.min.css			压缩后的样式文件
│   ├── bootstrap-theme.css			主题文件
│   ├── bootstrap-theme.css.map
│   └── bootstrap-theme.min.css		压缩后的主题文件
├── js/			核心 js 文件
│   ├── bootstrap.js				核心 js 文件
│   └── bootstrap.min.js			压缩后的核心 js 文件
└── fonts/		字体库
    ├── glyphicons-halflings-regular.eot
    ├── glyphicons-halflings-regular.svg
    ├── glyphicons-halflings-regular.ttf
    ├── glyphicons-halflings-regular.woff
    └── glyphicons-halflings-regular.woff2
```

## 对浏览器的支持情况

### 1）目前支持的浏览器

| | Chrome | Firefox | Internet Explorer | Opera | Safari |
| --- | --- | --- | --- | --- | --- |
| Android | 支持 | 支持 | N/A | 不支持 | N/A |
| IOS | 支持 | N/A | N/A | 不支持 | 支持 |
| Mac OS X | 支持 | 支持 | N/A | 支持 | 支持 |
| Windows | 支持 | 支持 | 支持 | 支持 | 不支持 |

### 2）IE 8及之前版本的兼容

* 对 HTML 5 提供的新元素，需要通过 html5shiv.js 库进行兼容。
* 对 CSS 3 提供的媒体查询，需要通过 respond.js 库进行支持。

需要在使用 Bootstrap 框架的页面 head 元素中，插入以下内容：

```html
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
	<script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
```

### 3）IE 兼容模式

Bootstrap 不支持 IE 古老的兼容模式。为了让 IE 浏览器运行最新的渲染模式下，建议将此 `<meta>` 元素加入到页面中：

```html
<meta http-equiv="X-UA-Compatible" content="IE=edge">
```

### 4）国产浏览器高速模式

国内浏览器厂商一般都支持兼容模式（即 IE 内核）和高速模式（即 webkit 内核），不幸的是，所有国产浏览器都是默认使用兼容模式，这就造成由于低版本 IE （IE8 及以下）内核让基于 Bootstrap 构建的网站展现效果很糟糕的情况。

将下面的 `<meta>` 元素加入到页面中，可以让部分国产浏览器默认采用高速模式渲染页面：

```html
<meta name="renderer" content="webkit">
```

## box-sizing

Bootstrap 默认使用的盒子模型是 border-box，可能会和一些第三方组件冲突。

为了避免 Bootstrap 设置的全局盒模型所带来的影响，可以重置单个页面元素或覆盖整个区域的盒模型。

* 覆盖单个页面元素

```css
/* 通过 CSS 代码覆盖单个页面元素的盒模型 */
.element {
  -webkit-box-sizing: content-box;
     -moz-box-sizing: content-box;
          box-sizing: content-box;
}
```

* 重置整个区域

```css
/* 通过 CSS 代码重置整个区域 */
.reset-box-sizing,
.reset-box-sizing *,
.reset-box-sizing *:before,
.reset-box-sizing *:after {
  -webkit-box-sizing: content-box;
     -moz-box-sizing: content-box;
          box-sizing: content-box;
}
```

## 基本模板

Bootstrap 提供了一个最基本的 HTML 模板，基于这个模板开始实现 Bootstrap 响应式页面。

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <!-- 设置当前 HTML 页面的编码格式为 UTF-8 -->
    <meta charset="utf-8">
    <!-- 设置 IE 的兼容模式 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- 设置移动优先 -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签必须放在最前面，任何其他内容都必须跟随其后！ -->
    <title>Bootstrap最基本的HTML模板</title>

    <!-- 导入 Bootstrap 框架的 CSS 文件 -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!--
        html5shiv.js 文件解决 IE8及之前版本的浏览器支持 HTML 5 元素的问题。
        respond.js 文件解决 IE8及之前版本的浏览器支持 CSS 3 的媒体查询问题。
    -->
    <!--[if lt IE 9]>
    <script src="bootstrap/js/html5shiv.min.js"></script>
    <script src="bootstrap/js/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<h1>你好，世界！</h1>

<!--
    由于 Bootstrap 是基于 jQuery 实现的核心 js 功能,
    所以想要使用 Bootstrap 提供的插件功能,需要先导入 jQuery 文件。
-->
<script src="bootstrap/js/jquery-1.11.3.js"></script>
<!-- 导入 Bootstrap 框架的 js 文件 -->
<script src="bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
```