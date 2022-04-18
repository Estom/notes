img元素定义及使用说明:

- `<img>` 标签定义 HTML 页面中的图像。
- `<img>` 标签有两个必需的属性：src 和 alt。

> **值得注意的是:**
> 
> - 从技术上讲，图像并不会插入 HTML 页面中，而是链接到 HTML 页面上。`<img>` 标签的作用是为被引用的图像创建占位符。
> - 通过在 `<a>` 标签中嵌套 `<img>` 标签，给图像添加到另一个文档的链接。

img元素的属性列表:

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| align | top\bottom\middle\left\right | HTML5 不支持。HTML 4.01 已废弃。 规定如何根据周围的文本来排列图像。|
| alt | text | 规定图像的替代文本。|
| height | pixels | 规定图像的高度。|
| src | URL | 规定显示图像的 URL。|
| width | pixels | 规定图像的宽度。|

```html
<!DOCTYPE html><html>  <head>    <title>10_图像img元素.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <h4>Image with default alignment (align="bottom"):</h4>	<p>帅哥,请看这里. <img src="girl.jpg" alt="Smiley face" width="32" height="32"> 我在这里等你哦.</p>	<h4>Image with align="middle":</h4>	<p>帅哥,请看这里. <img src="girl.jpg" alt="Smiley face" align="middle" width="32" height="32"> 我在这里等你哦.</p>	<h4>Image with align="top":</h4>	<p>帅哥,请看这里. <img src="girl.jpg" alt="Smiley face" align="top" width="32" height="32"> 我在这里等你哦.</p>  	<br>	<a href="99_biggirl.html"><img src="girl.jpg" title="点击我看大图哦!" alt="liuyan" width="32" height="32"></a>  </body></html>```