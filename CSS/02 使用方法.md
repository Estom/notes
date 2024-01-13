## 第一种内联样式

通过HTML元素的style属性来设置CSS样式，语法如下:

```html
style="css属性:css属性值;"
```

示例代码:

```html
<!DOCTYPE html><html>  <head>    <title>01_第一种使用方式.html</title>  </head>  <body>    <!-- style="css属性:css属性值;" -->	<div style="color:red;" >atguigu</div>  </body></html>
```

## 第二种内联样式

通过HTML页面的style元素来设置CSS样式，语法如下:

```html
<style type="text/css">	选择器 {		属性名 : 属性值;	}</style>
```

示例代码:

```html
<!DOCTYPE html><html>  <head>    <title>02_第二种使用方式.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">	<!-- 		style标签:封装样式内容			* type:指定使用样式,值为"text/css"			* 设置CSS语法:				选择器 {					属性名 : 属性值;				}	 -->	<style type="text/css">		div {			color : red;		}	</style>  </head>  <body>    <div>atguigu</div>  </body></html>
```

## 外联样式

通过HTML页面的link元素来引入外部CSS样式，语法如下:

```html
<link href="css文件路径" rel="stylesheet" type="text/css" />
```

示例代码:

```html
<!DOCTYPE html><html>  <head>    <title>04_第四种使用方式.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">	<!-- 		link标签:			* href:引入外部css文件路径			* rel:设置引入文件为样式文件			* type:指定使用样式,值为"text/css"	 -->	<link href="div.css" rel="stylesheet" type="text/css" />  </head>  <body>    <div>atguigu</div>  </body></html>
```