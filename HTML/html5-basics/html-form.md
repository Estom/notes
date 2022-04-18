## `<form>` 表单

表单是一个包含表单元素的区域。表单元素是允许用户在表单中输入内容,比如：文本域(textarea)、下拉列表、单选框(radio-buttons)、复选框(checkboxes)等等。

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| action | URL | 规定当提交表单时向何处发送表单数据。|
| method | get/post | 规定用于发送表单数据的 HTTP 方法。|
| name | text | 规定表单的名称。|

## 文本框

文本框通过 `<input type="text">` 标签来设定，当用户要在表单中键入字母、数字等内容时，就会用到文本框。

- `<input>` 元素是空的,它只包含标签属性。
- 你可以使用 `<label>` 元素来定义 `<input>` 元素的标注。
- 表单本身并不可见。同时，在大多数浏览器中，文本框的缺省宽度是 20 个字符。
- `<input>` 元素在 `<form>` 元素中使用，用来声明允许用户输入数据的 input 控件。

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| type | button/checkbox/radio/password | type 属性规定要显示的 `<input>` 元素的类型。|
| value | text | 设置值。 |
| src | URL | src 属性规定显示为提交按钮的图像的 URL。 (只针对 type="image")|
| size | number | size 属性规定以字符数计的 `<input>` 元素的可见宽度。|
| readonly | readonly | readonly 属性规定输入字段是只读的。|
| disabled | disabled | disabled 属性规定应该禁用的 `<input>` 元素。|
| checked | checked | checked 属性规定在页面加载时应该被预先选定的 `<input>` 元素。 (只针对 type="checkbox" 或者 type="radio")|

示例代码:

```html
<!DOCTYPE html><html>  <head>    <title>28_文本框.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <form id="form1" name="form1" action="#" method="post">    	用户名:<input type="text" id="username" name="username" value="用户名">		密码:<input type="text" id="password" name="password" value="密码" readonly="readonly">		确认密码:<input type="text" id="password" name="password" value="密码" disabled="true">    </form>  </body></html>
```

## 密码字段

密码字段通过标签 `<input type="password">` 来定义。

```html
<!DOCTYPE html><html>  <head>    <title>29_密码框.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <form id="form1" name="form1" action="#" method="post">    	用户名:<input type="text" id="username" name="username">		密码:<input type="password" id="password" name="password">    </form>  </body></html>
```

## 单选按钮

`<input type="radio">` 标签定义了表单单选框选项。

```html
<!DOCTYPE html><html>  <head>    <title>30_单选框.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <form id="form1" name="form1" action="#" method="post">		性别:		<input type="radio" checked="checked" id="male" name="sex" value="male">男		<input type="radio" id="female" name="sex" value="female">女<br>    </form>  </body></html>
```

## 复选框

`<input type="checkbox">` 定义了复选框. 用户需要从若干给定的选择中选取一个或若干选项。

```html
<!DOCTYPE html><html>  <head>    <title>31_复选框.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <form id="form1" name="form1" action="#" method="post">		爱好:		<input type="checkbox" checked="checked" id="java" name="like" value="java">java		<input type="checkbox" id="PHP" name="like" value="PHP">PHP    </form>  </body></html>
```

## 下拉列表

### `<select>` 元素用来创建下拉列表。

`<select>` 元素是一种表单控件，可用于在表单中接受用户输入。

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| disabled | disabled | 当该属性为 true 时，会禁用下拉列表。|
| name | name | 定义下拉列表的名称。|
| multiple | multiple | 当该属性为 true 时，可选择多个选项。|
| size | number | 规定下拉列表中可见选项的数目。|

### `<option>` 标签定义下拉列表中的一个选项（一个条目）。

- `<option>` 标签可以在不带有任何属性的情况下使用，但是您通常需要使用 value 属性，此属性会指示出被送往服务器的内容。
- 请与 select 元素配合使用此标签，否则这个标签是没有意义的。

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| disabled | disabled | 当该属性为 true 时，会禁用下拉列表。|
| selected | selected | 规定选项（在首次显示在列表中时）表现为选中状态。|
| value | text | 定义送往服务器的选项值。|

示例代码:

```html
<!DOCTYPE html><html>  <head>    <title>32_下拉列表.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <form id="form1" name="form1" action="#" method="post">		地区: <select id="city" name="city">			<option value="bj">北京</option>			<option selected="selected" value="nj">南京</option>		</select>    </form>  </body></html>
```

## 提交按钮

`<input type="submit">` 定义了提交按钮。当用户单击确认按钮时，表单的内容会被传送到另一个文件。表单的动作属性定义了目的文件的文件名。由动作属性定义的这个文件通常会对接收到的输入数据进行相关的处理。

```html
<!DOCTYPE html><html>  <head>    <title>33_提交按钮.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <form id="form1" name="form1" action="#" method="post">		<input type="submit" id="submit" value="提交">    </form>  </body></html>
```

## HTML 实体

HTML 实体指的就是 HTML 的转移字符。

| 显示结果 | 描述 | 实体名称 |
| --- | --- | --- |
| | 空格 | `&nbsp;` |
| < | 小于号 | `&lt;` |
| > | 大于号 | `&gt;` |
| & | 和号 | `&amp;` |
| " | 引号 | `&quot;` |
| © | 版权（copyright） | `&copy;` |
| ® | 注册商标 | `&reg;` |
| ™ | 商标 | `&trade;` |
| × | 乘号 | `&times;` |
| ÷ | 除号 | `&divide;` |