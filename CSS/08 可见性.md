CSS 中的 display 和 visibility 都可以设置一个元素在浏览器中的显示或隐藏效果。

- display: 隐藏某个元素时，不会占用任何空间。换句话讲，不会影响布局。
- visibility: 隐藏某个元素时，仍需占用与未隐藏之前一样的空间。换句话讲，会影响布局。

## display 属性

| 属性值 | 描述 |
| --- | --- |
| none | 此元素不会被显示。|

当将一个元素的 CSS 属性 display 设置为 none 时，该元素会被隐藏。并且被隐藏的元素不会占用 HTML 页面的任何空间。

在 HTML 页面中定义两个 `<div>` 标签，并设置 CSS 样式，具体代码如下:

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

当为第一个 `<div>` 标签设置 display 属性值为 none 时，该 `<div>` 标签会被隐藏。

| 属性值 | 描述 |
| --- | --- |
| block | 此元素将显示为块级元素。|

该值主要作用于**内联元素**。如果将内联元素的 CSS 属性 display 设置为 block 时，该内联元素将在浏览器中显示成块级元素效果。

在 HTML 页面中定义两个 `<div>` 标签，并设置 CSS 样式，具体代码如下:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      #s1 {
        width: 300px;
        height: 300px;
        background-color: lightskyblue;
      }
      #s2 {
        width: 300px;
        height: 300px;
        background-color: green;
      }
    </style>
  </head>
  <body>
    <span id="s1">这是一个span</span>
    <span id="s2">这是一个span</span>
  </body>
</html>
```

当为第一个 `<span>` 标签设置 display 属性值为 block 时，该 `<span>` 标签会呈现块级元素效果。

| 属性值 | 描述 |
| --- | --- |
| inline | 默认值，此元素会被显示为内联元素。|

该值主要作用于**块级元素**。如果将内联元素的 CSS 属性 display 设置为 inline 时，该内联元素将在浏览器中显示成内联元素效果。

在 HTML 页面中定义两个 `<div>` 标签，并设置 CSS 样式，具体代码如下:

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
    <div id="d1">这是一个div</div>
    <div id="d2">这是一个div</div>
  </body>
</html>
```

当为第一个 `<div>` 标签设置 display 属性值为 inline 时，该 `<div>` 标签会呈现内联元素样式。

| 属性值 | 描述 |
| --- | --- |
| inline-block | 行内块元素。|

当将 CSS 属性 display 设置为 inline-block 时，该元素在浏览器中显示为内联块级效果。即每个元素呈现块级元素效果，元素之间呈现内联元素效果。

在 HTML 页面中定义两个 `<div>` 标签，并设置 CSS 样式，具体代码如下:

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
    <div id="d1">这是一个div</div>
    <div id="d2">这是一个div</div>
  </body>
</html>
```

分别为两个 `<div>` 标签设置 display 属性值为 inline-block 时，这两个 `<div>` 会显示在一行中。

### visibility 属性

visibility 属性指定一个元素是否是可见的。

> **值得注意的是:** visibility 属性设置元素不可见的元素，但会占据页面上的空间。请使用 display 属性来创建不占据页面空间的不可见元素。

| 属性值 | 描述 |
| --- | --- |
| visible | 默认值，元素是可见的。|
| hidden | 元素是不可见的。|

在 HTML 页面中定义两个 `<div>` 标签，并设置 CSS 样式，具体代码如下:

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
    <div id="d1">这是一个div</div>
    <div id="d2">这是一个div</div>
  </body>
</html>
```

当为第一个 `<div>` 标签设置 visibility 属性值为 hidden 时，该 `<div>` 会被隐藏。