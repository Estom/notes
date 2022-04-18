## 基本表格

表格由 `<table>` 标签来定义。每个表格均有若干行（由 `<tr>` 标签定义），每行被分割为若干单元格（由 `<td>` 标签定义）。字母 td 指表格数据（table data），即数据单元格的内容。数据单元格可以包含文本、图片、列表、段落、表单、水平线、表格等等。

HTML表格元素:

| 标签 | 属性 |
| --- | --- |
| `<table>` | 定义表格 |
| `<th>` | 定义表格的表头 |
| `<tr>` | 定义表格的行 |
| `<td>` | 定义表格单元 |
| `<caption>` | 定义表格标题 |
| `<thead>` | 定义表格的页眉 |
| `<tbody>` | 定义表格的主体 |
| `<tfoot>` | 定义表格的页脚 |

- 示例代码一:

```html
<!DOCTYPE html><html>  <head>    <title>17_基本表格.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <table>		<tr>			<td><b>名称</b></td><td><b>性别</b></td><td><b>年龄</b></td>		</tr>		<tr>			<td>张三</td><td>男</td><td>18</td>		</tr>		<tr>			<td>李四</td><td>女 </td><td>16</td>		</tr>	</table>  </body></html>
```

- 示例代码二:

```html
<!DOCTYPE html><html>  <head>    <title>17_基本表格.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <table border="1" width="20%" rules="rows" frame="below">		<tr>			<td><b>名称</b></td><td><b>性别</b></td><td><b>年龄</b></td>		</tr>		<tr>			<td>张三</td><td>男</td><td>18</td>		</tr>		<tr>			<td>李四</td><td>女 </td><td>16</td>		</tr>	</table>  </body></html>
```

- 示例代码三:

```html
<!DOCTYPE html><html>  <head>    <title>17_基本表格.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <table border="1" width="20%">		<tr align="center">			<td><b>名称</b></td><td><b>性别</b></td><td><b>年龄</b></td>		</tr>		<tr>			<td>张三</td><td>男</td><td>18</td>		</tr>		<tr>			<td>李四</td><td>女 </td><td>16</td>		</tr>	</table>  </body></html>
```

- 示例代码四:

```html
<!DOCTYPE html><html>  <head>    <title>17_基本表格.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <table border="1" width="20%">		<tr align="center">			<td><b>名称</b></td><td><b>性别</b></td><td><b>年龄</b></td>		</tr>		<tr>			<td align="center">张三</td><td>男</td><td>18</td>		</tr>		<tr>			<td height="30px" width="90px">李四</td><td>女 </td><td>16</td>		</tr>	</table>  </body></html>
```

## 带表头的表格

`<th>` 标签定义 HTML 表格中的表头单元格。HTML 表格有两种单元格类型:

- 表头单元格 - 包含头部信息（由 `<th>` 元素创建）
- 标准单元格 - 包含数据（由 `<td>` 元素创建）

> **值得注意的是:**
> 
> - `<th>` 元素中的文本通常呈现为粗体并且居中。
> - `<td>` 元素中的文本通常是普通的左对齐文本。

```html
<!DOCTYPE html><html>  <head>    <title>18_带表头的表格.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>  	<table border="1" width="20%">		<tr>			<th>名称</th><th>性别</th><th>年龄</th>		</tr>		<tr>			<td>张三</td><td>男</td><td>18</td>		</tr>		<tr>			<td>李四</td><td>女 </td><td>16</td>		</tr>	</table>  </body></html>
```

## 带标题的表格

`<caption>` 标签定义表格的标题。

- `<caption>` 标签必须直接放置到 `<table>` 标签之后。
- 只能对每个表格定义一个标题。
- 通常这个标题会被居中于表格之上。

```html
<!DOCTYPE html><html>  <head>    <title>19_带标题的表格.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <table border="1" width="20%">		<caption>人员信息列表</caption>		<tr>			<th>名称</th><th>性别</th><th>年龄</th>		</tr>		<tr>			<td>张三</td><td>男</td><td>18</td>		</tr>		<tr>			<td>李四</td><td>女 </td><td>16</td>		</tr>	</table>  </body></html>
```

## 跨行或跨列的表格

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| colspan | number | 规定表头单元格可横跨的列数。 |
| rowspan | number | 规定表头单元格可横跨的行数。 |

跨列示例代码:

```html
<!DOCTYPE html><html>  <head>    <title>20_跨行或跨列的表格.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <h4>跨两列的表格:</h4>	<table border="1">	<tr>	  <th>名称</th>	  <th colspan="2">电话</th>	</tr>	<tr>	  <td>尚硅谷</td>	  <td>555 77 854</td>	  <td>555 77 855</td>	</tr>	</table>  </body></html>
```

跨行示例代码:

```html
<!DOCTYPE html><html>  <head>    <title>20_跨行或跨列的表格.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>	<h4>跨两行的表格:</h4>	<table border="1">	<tr>	  <th>名称:</th>	  <td>尚硅谷</td>	</tr>	<tr>	  <th rowspan="2">电话:</th>	  <td>555 77 854</td>	</tr>	<tr>	  <td>555 77 855</td>	</tr>	</table>  </body></html>
```

## 表格的页眉、主体及页脚

- `<thead>` 标签用于组合 HTML 表格的页眉内容。
- `<tbody>` 标签用于组合 HTML 表格的主体内容。
- `<tfoot>` 标签用于组合 HTML 表格的页脚内容。

通过使用这些元素，使浏览器有能力支持独立于表格表头和表格页脚的表格主体滚动。当包含多个页面的长的表格被打印时，表格的表头和页脚可被打印在包含表格数据的每张页面上。

> **值得注意的是:**
> 
> - `<tbody>`、`<tbody>` 及 `<tfoot>` 元素内部必须包含一个或者多个 `<tr>` 标签。
> - `<thead>`、`<tbody>` 和 `<tfoot>` 元素默认不会影响表格的布局。

```html
<!DOCTYPE html><html>  <head>    <title>21_表格的页眉、主体及页脚.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <table border="1">	  <thead>	    <tr>	      <th>月份</th>	      <th>收入</th>	    </tr>	  </thead>	  <tfoot>	    <tr>	      <td>总和</td>	      <td>$180</td>	    </tr>	  </tfoot>	  <tbody>	    <tr>	      <td>二月</td>	      <td>$100</td>	    </tr>	    <tr>	      <td>三月</td>	      <td>$80</td>	    </tr>	  </tbody>	</table>  </body></html>
```