## 文档流

将窗体自上而下分成一行一行，并在每行中按从左至右的挨次排放元素，即为文档流。

文档流是 HTML 页面的底层结构，HTML 页面创建的元素默认都在文档流中。

- 块级元素
	- 块级元素在文档流中自上向下排列（垂直方向排列）
	- 块级元素在文档流中默认的宽度是父元素的100%
	- 块级元素在文档流中默认的高度被是所有子元素的高度总和
- 内联元素
	- 内联元素在文档流中自左向右水平排列（水平方向排列）
	- 内联元素的宽度和高度都由内容确定

> **值得注意的是:** 如果在一行中不能容纳所有的元素，则会换到下一行，继续自左向右排列。

有三种状况将使得元素离开文档流而存在，分别是浮动、绝对定位、固定定位。

> **值得注意的是:** 在 IE 浏览器中浮动元素也存在于文档流中。

## 浮动

CSS 的 Float（浮动），会使元素脱离文档流，向左或向右移动。其他元素会被重新排列。

Float（浮动），往往是用于图像，但它在布局时一样非常有用。

| 属性值 | 描述 |
| --- | --- |
| none | 默认值。元素不浮动。|
| left | 元素向左浮动。|
| right | 元素向右浮动。|

设置元素浮动效果时，以下四种情况比较特殊:

- 子元素只能在父元素的区域中进行浮动（子元素浮动不能超出父元素的范围）。

在 HTML 页面中定义两个 `<div>` 标签为父子元素，并设置 CSS 样式，具体代码如下:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      #d1 {
        height: 300px;
        background-color: lightskyblue;
      }
      #d2 {
        width: 50px;
        height: 50px;
        background-color: green;
      }
    </style>
  </head>
  <body>
    <div id="d1">
      <div id="d2"></div>
    </div>
  </body>
</html>
```

当为子元素 `<div>` 标签设置 float 属性值为 right 时，该 `<div>` 为浮动效果。

- 兄弟元素同时设置相同浮动效果时，会进行自动排列。

在 HTML 页面中定义两个 `<div>` 标签为兄弟元素，并设置 CSS 样式，具体代码如下:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      #d1 {
        width: 300px;
        height: 300px;
        background-color: lightskyblue;
      }
      #d2 {
        width: 300px;
        height: 300px;
        background-color: green;
      }
    </style>
  </head>
  <body>
    <div id="d1"></div>
    <div id="d2"></div>
  </body>
</html>
```

当同时为两个 `<div>` 标签设置 float 属性值为 left 时，这两个 `<div>` 为浮动效果。

- 如果兄弟元素中，前一个兄弟元素没有设置浮动，而后一个兄弟元素设置浮动的话，后一个兄弟元素的浮动不能超过前一个兄弟元素。

在 HTML 页面中定义两个 `<div>` 标签为兄弟元素，并设置 CSS 样式，具体代码如下:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      #d1 {
        width: 300px;
        height: 300px;
        background-color: lightskyblue;
      }
      #d2 {
        width: 300px;
        height: 300px;
        background-color: green;
      }
    </style>
  </head>
  <body>
    <div id="d1"></div>
    <div id="d2"></div>
  </body>
</html>
```

当为第二个 `<div>` 标签设置 float 属性值为 right 时，该 `<div>` 为浮动效果。

> **值得注意的是:** 所有浮动元素的层级要高于文档流中的元素的层级。但文字是个例外，文字不会被浮动元素所覆盖，而是环绕在浮动元素的周围。

### 块级元素浮动

块级元素设置浮动之后，会从文档流中脱离，并且具有以下特点:

- 块级元素不会独占 HTML 页面的一行。换句话讲，多个块级元素可以处在一行。
- 块级元素的宽度和高度等于所有后代元素的总和。

### 内联元素浮动

内联元素设置浮动之后，也会从文档流中脱离，并且会呈现块级元素的效果。特点也与设置浮动的块级元素相同。

### 清除浮动

clear 属性指定元素的左侧或右侧不允许浮动的元素。

| 属性值 | 描述 |
| --- | --- |
| none | 默认值。允许浮动元素出现在两侧。|
| left | 在左侧不允许浮动元素。|
| right | 在右侧不允许浮动元素。|
| both | 在左右两侧均不允许浮动元素。|

## 高度塌陷

在 HTML 页面中定义两个 `<div>` 标签为父子元素，并设置 CSS 样式，具体代码如下:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      #d1 {
        border: 10px black solid;
        background-color: lightskyblue;
      }
      #d2 {
        width: 300px;
        height: 300px;
        background-color: green;
      }
    </style>
  </head>
  <body>
    <div id="d1">
      <div id="d2"></div>
    </div>
  </body>
</html>
```

上述 HTML 页面运行的效果如下:

![](img/15.png)

为作为子元素 `<div>` 设置 float 属性值为 left 时，该 `<div>` 为浮动效果。

![](img/16.png)

由于并没有为作为父元素的 `<div>` 设置高度，作为父元素的 `<div>` 实际的高度与作为子元素的 `<div>` 的高度相等。

但作为子元素的 `<div>` 设置浮动后，脱离了文档流，导致作为父元素的 `<div>` 没有了高度。

现在所看到的效果，就被称为**高度塌陷**。

> 所谓**高度塌陷**，就是指在没有为父元素设置指定高度，并且设置子元素为浮动时，父元素的高度丢失的情况。

高度塌陷的问题，可以通过 BFC（Block Formatting Context）块级格式化环境进行解决。

### BFC 块级格式化环境

BFC（Block Formatting Context）是元素的隐含属性。默认情况下 BFC 是关闭的，当元素开启 BFC 以后，将会具有如下特性:

- 文档流中的元素不会被设置为浮动的元素所覆盖。
- 子元素的垂直方向的外边距不会传递给父元素。
- 元素可以包含浮动的子元素。

当然，并不能直接去开启 BFC，而需要使用一些特殊的样式来间接的打开元素的 BFC。

- 设置元素为浮动（float）
- 设置元素的 display 为 inline-block
- 设置元素为绝对定位（后面的内容）
- 将元素的 overflow 设置为一个非 visible 的值（一般设置为 hidden）
- 在所有子元素的最后新增一个子元素，并设置 clear 属性值为 both

> **值得注意的是:** 开启 BFC 都会有一些副作用，需要选择一些副作用小的方式。