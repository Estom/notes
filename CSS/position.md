CSS 的 position 定位属性允许自定义元素在 HTML 页面的位置，但需要先开启元素在 HTML 页面中的定位。

> **值得注意的是:** 元素在 HTML 页面中默认是不开启定位的。

CSS 定位属性提供了四种方式的定位效果:

- static: 默认值，表示元素为静态定位。
- absolute: 表示元素为绝对定位。
- fixed: 表示元素为固定定位。
- relative: 表示元素为相对定位。

当设置元素的 position 定位属性为**非默认值**时，CSS 提供了上、右、下和左四个方向的偏移量完成元素的位置设置。

- top: 表示当前元素到上边的距离。
- right: 表示当前元素到右边的距离。
- bottom: 表示当前元素到下边的距离。
- left: 表示当前元素到左边的距离。

![](03.png)

## 绝对定位

| 属性值 | 描述 |
| --- | --- |
| absolute | 生成绝对定位的元素，相对于 static 定位以外的第一个父元素进行定位。|

> 元素的位置通过 "left", "top", "right" 以及 "bottom" 属性进行规定。

元素开启绝对定位后，与浮动效果类似:

- 元素会脱离文档流。
- 元素会呈现块级元素效果。
- 如果不设置偏移量，元素的位置不会发生变化。

### 如果元素的父元素是 `<body>` 的话，绝对定位会相对于当前页面

在 HTML 页面中定义两个 `<div>` 标签，并且为相邻的兄弟元素，并设置其 CSS 样式，具体代码如下:

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

为第二个 `<div>` 元素开启绝对定位，并设置偏移量，具体代码如下:

```css
position: absolute;
left: 0px;
top: 0px;
```

> **值得注意的是:** 如果开启绝对定位的元素的父元素并不是 `<body>` 标签，但父元素没有开启任何定位的话，开启绝对定位的元素还是相对于当前页面。

### 如果元素的父元素不是 `<body>` 标签，并且开启定位的话，绝对定位会相对于父元素

在 HTML 页面中定义两个 `<div>` 标签，并且为父元素与子元素的关系，并设置其 CSS 样式，具体代码如下:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      #d1 {
        width: 500px;
        height: 400px;
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

为两个 `<div>` 元素开启绝对定位，并设置偏移量，具体代码如下:

```css
#d1 {
  width: 500px;
  height: 400px;
  background-color: lightskyblue;
  
  position: absolute;
  left: 100px;
  top: 0px;
}
#d2 {
  width: 300px;
  height: 300px;
  background-color: green;
  
  position: absolute;
  left: 100px;
  top: 0px;
}
```

## 固定定位

| 属性值 | 描述 |
| --- | --- |
| fixed | 生成绝对定位的元素，相对于浏览器窗口进行定位。|

> 元素的位置通过 "left", "top", "right" 以及 "bottom" 属性进行规定。

固定定位是一种特殊的绝对定位，固定定位与绝对定位的区别在于:

- 固定定位始终相对于当前页面进行定位。
- 绝对定位相对于最近的祖先元素进行定位。

例如上述效果就是固定定位的一种应用方式。实现上述效果的具体代码如下:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      body {
        margin: 0px;
        height: 2000px;
      }
      #d1 {
        width: 100%;
        height: 100px;
        background-color: lightskyblue;
        position: fixed;
        bottom: 0px;
      }
    </style>
  </head>
  <body>
    <div id="d1"></div>
  </body>
</html>
```

## 相对定位

| 属性值 | 描述 |
| --- | --- |
| relative | 生成相对定位的元素，相对于其正常位置进行定位。|

> **值得注意的是:**
> 
> - 开启相对定位的元素，不会脱离文档流。
> - 开启相对定位的元素，是相对于该元素在文档流中的定位效果。
> - 开启相对定位的元素，不会改变元素的性质。（块级元素呈现块级元素效果，内联元素呈现内联元素效果）

在 HTML 页面中定义两个 `<div>` 标签，并且为相邻的兄弟元素，并设置其 CSS 样式，具体代码如下:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      #d1 {
        width: 500px;
        height: 400px;
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

为第二个 `<div>` 元素开启相对定位，并设置偏移量，具体代码如下:

```css
position: absolute;
left: 0px;
top: 0px;
```