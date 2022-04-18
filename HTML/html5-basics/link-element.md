HTML 使用超级链接与网络上的另一个文档相连。几乎可以在所有的网页中找到链接。点击链接可以从一张页面跳转到另一张页面。

- 超链接可以是一个字，一个词，或者一组词，也可以是一幅图像，您可以点击这些内容来跳转到新的文档或者当前文档中的某个部分。
- 当您把鼠标指针移动到网页中的某个链接上时，箭头会变为一只小手。
- 在标签 `<a>` 中使用了href属性来描述链接的地址。

> **值得注意的是:**
> 
> - 如果没有使用 href 属性，则不能使用 hreflang、media、rel、target 以及 type 属性。
> - 通常在当前浏览器窗口中显示被链接页面，除非规定了其他 target。
> - 请使用 CSS 来改变链接的样式。

`<a>` 元素的属性列表:

| 属性名 | 值 | 描述 |
| --- | --- | --- |
| href | URL | 规定链接的目标 URL。|
| target | _blank/_parent/_self | 规定在何处打开目标 URL。仅在 href 属性存在时使用。|

```html
<!DOCTYPE html><html>  <head>    <title>12_链接元素.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <a name="top">这是顶端</a><br>	<a href="mailto:82328769@qq.com" >联系我们</a><br>	<img src="girl.jpg" /><br>	<a name="middle">这是中间</a><br>	<a href="#top" >回到顶部</a><br>	<a href="#middle" >回到中间</a><br>  </body></html>
```