## 元素选择器

元素选择器就是通过 HTML 页面的元素名称来设置 CSS 样式。具体语法如下:

```css
元素名称 { 属性名 : 属性值; }
```

示例代码:

```css
div {color : red; }
```

## 类选择器

类选择器就是通过 HTML 元素的 class 属性值来设置 CSS 样式。具体语法如下:

```css
.class属性值 { 属性名 : 属性值; }
```

示例代码:

```css
.myDiv {color : red; }
```

## ID选择器

ID选择器就是通过 HTML 元素的 id 属性值来设置 CSS 样式。具体语法如下:

```css
#id属性值 { 属性名 : 属性值; }
```

示例代码:

```css
#show1 {color : red; }
```

## 属性选择器

属性选择器就是通过 HTML 元素的属性名称来设置 CSS 样式。具体语法如下:

```css
[属性名称] { 属性名 : 属性值; }
```

示例代码:

```css
[name] {color : red; }
```

| 选择器 | 描述 |
| --- | --- |
| [attribute] | 用于选取带有指定属性的元素。|
| [attribute=value] | 用于选取带有指定属性和值的元素。|
| [attribute~=value] | 用于选取属性值中包含指定词汇的元素。|
| [attribute^=value] | 匹配属性值以指定值开头的每个元素。|
| [attribute$=value] | 匹配属性值以指定值结尾的每个元素。|
| [attribute*=value] | 匹配属性值中包含指定值的每个元素。|

## 后代选择器

后代选择器就是设置 HTML 页面的指定元素的后代元素（中间使用空格）的 CSS 样式。具体语法如下:

```css
祖先元素 后代元素 { 属性名 : 属性值; }
```

示例代码:

```css
div em {color : red; }
```

## 子元素选择器

子选择器就是设置 HTML 页面的指定元素的子元素的 CSS 样式。具体语法如下:

```css
祖先元素 > 子元素{ 属性名 : 属性值; }
```

示例代码:

```css
div > em {color : red; }
```

## 相邻元素选择器

相邻元素选择器就是设置 HTML 页面的指定元素的下一个兄弟元素的 CSS 样式。具体语法如下:

```css
指定元素 + 兄弟元素 { 属性名 : 属性值; }
```

示例代码:

```css
div + div {color : red; }
```

## 其他内容

### 选择器分组

选择器分组就是将不同选择器相同声明的内容“压缩”在一起，得到更简洁的样式表。

```css
/* no grouping */h1 {color:blue;}h2 {color:blue;}h3 {color:blue;}h4 {color:blue;}h5 {color:blue;}h6 {color:blue;}/* grouping */h1, h2, h3, h4, h5, h6 {color:blue;}
```

### 通配符选择器

CSS2 引入了一种新的简单选择器 - 通配选择器（universal selector），显示为一个星号（*）。该选择器可以与任何元素匹配，就像是一个通配符。

```css
* {color:red;}
```

> **值得注意的是:** 通配符选择器的性能并不好。