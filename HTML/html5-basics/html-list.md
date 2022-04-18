## 有序列表

有序列表也是一列项目，列表项目使用数字进行标记。 有序列表始于 `<ol>` 标签。每个列表项始于 `<li>` 标签。

### `<ol>` 标签定义了一个有序列表. 列表排序以数字来显示。

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| start | number | **HTML5不支持，不赞成使用。**请使用样式取代它。 规定列表中的起始点。|
| type | 1   A   a   I   i | 规定列表的类型。|

### `<li>` 标签定义列表项目。

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| value | number | **HTML5不支持，不赞成使用。**请使用样式取代它。 规定列表项目的数字。|
| type | 1   A   a   I   i | 规定列表的类型。|

```html
<!DOCTYPE html><html>  <head>    <title>13_有序列表.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <h4>Numbered list:</h4>	<ol>	 <li>Apples</li>	 <li>Bananas</li>	 <li>Lemons</li>	 <li>Oranges</li>	</ol>  	<h4>Letters list:</h4>	<ol type="A">	 <li>Apples</li>	 <li>Bananas</li>	 <li>Lemons</li>	 <li>Oranges</li>	</ol>  	<h4>Lowercase letters list:</h4>	<ol type="a">	 <li>Apples</li>	 <li>Bananas</li>	 <li>Lemons</li>	 <li>Oranges</li>	</ol>  	<h4>Roman numbers list:</h4>	<ol type="I">	 <li>Apples</li>	 <li>Bananas</li>	 <li>Lemons</li>	 <li>Oranges</li>	</ol>  	<h4>Lowercase Roman numbers list:</h4>	<ol type="i">	 <li>Apples</li>	 <li>Bananas</li>	 <li>Lemons</li>	</ol>    </body></html>
```

## 无序列表

无序列表是一个项目的列表，此列项目使用粗体圆点（典型的小黑圆圈）进行标记。

### `<ul>` 标签定义无序列表。

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| start | number | **HTML5不支持，不赞成使用。**请使用样式取代它。 规定列表中的起始点。|
| type | disc/square/circle | 规定列表的类型。|

### `<li>` 标签定义列表项目。

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| value | number | **HTML5不支持，不赞成使用。**请使用样式取代它。 规定列表项目的数字。|
| type | 1   A   a   I   i | 规定列表的类型。|

```html
<!DOCTYPE html><html>  <head>    <title>14_无序列表.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>	<h4>Disc bullets list:</h4>	<ul style="list-style-type:disc">	 <li>Apples</li>	 <li>Bananas</li>	 <li>Lemons</li>	 <li>Oranges</li>	</ul>  		<h4>Circle bullets list:</h4>	<ul style="list-style-type:circle">	 <li>Apples</li>	 <li>Bananas</li>	 <li>Lemons</li>	 <li>Oranges</li>	</ul>  		<h4>Square bullets list:</h4>	<ul style="list-style-type:square">	 <li>Apples</li>	 <li>Bananas</li>	 <li>Lemons</li>	 <li>Oranges</li>	</ul>  </body></html>
```

## 嵌套列表

### 有序嵌套列表

```html
<!DOCTYPE html><html>  <head>    <title>15_嵌套列表.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>	<h4>有序嵌套列表:</h4>	<ol>	  <li>咖啡</li>	  <li>茶	    <ol type="a">	      <li>红茶</li>	      <li>绿茶	        <ol type="i">	          <li>中国</li>	          <li>非洲</li>	        </ol>	      </li>	    </ol>	  </li>	  <li>牛奶</li>	</ol>  </body></html>
```

### 无序嵌套列表

```html
<!DOCTYPE html><html>  <head>    <title>15_嵌套列表.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <h4>无序嵌套列表:</h4>	<ul>	  <li>咖啡</li>	  <li>茶	    <ul>	      <li>红茶</li>	      <li>绿茶	        <ul>	          <li>中国</li>	          <li>非洲</li>	        </ul>	      </li>	    </ul>	  </li>	  <li>牛奶</li>	</ul>  </body></html>
```

## 定义列表

定义列表不仅仅是一列项目，而是项目及其注释的组合。定义列表以 `<dl>` 标签开始。每个定义列表项以 `<dt>` 开始。每个定义列表项的定义以 `<dd>` 开始。

- `<dl>` 标签定义一个描述列表。
- `<dt>` 标签定义一个描述列表的项目/名字。
- `<dd>` 标签被用来对一个描述列表中的项目/名字进行描述。

```html
<!DOCTYPE html><html>  <head>    <title>16_自定义列表.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <dl>		<dt>		平时爱好:		</dt>			<dd>- 抽烟</dd>			<dd>- 喝酒</dd>			<dd>- 烫头</dd>		<dt>		喜欢的游戏:		</dt>			<dd>- 魔兽世界</dd>			<dd>- 反恐精英</dd>			<dd>- 红色警戒</dd>	</dl>  </body></html>
```