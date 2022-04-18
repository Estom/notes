## 示例代码

```html
<html>	<head>		<title>01_helloworld.html</title>	</head>	<body>		<!-- 这是第一个页面 helloworld -->		<font color="red">hello world!</font>	</body></html>
```

示例代码说明:

- html 标签: 定义 HTML 文档，HTML 文档的根标签。
- head 标签: 定义关于文档的基本信息。
- body 标签: 定义文档的主体，运行 HTML 文档时显示的内容。
- title 标签: 定义文档的标题。在运行网页时，页面顶端显示的内容。
- font 标签: 定义文字的字体、尺寸和颜色。

## HTML元素（标签）

HTML 标记标签通常被称为 HTML 标签，"HTML 标签" 和"HTML 元素" 通常都是描述同样的意思。（一个 HTML 元素包含了开始标签与结束标签）

- HTML 标签是由尖括号包围的关键词，比如 `<html>`
- HTML 标签通常是成对出现的，比如 `<b>` 和 `</b>`
- 标签对中的第一个标签是开始标签，第二个标签是结束标签
- 开始和结束标签也被称为开放标签和闭合标签

> **值得注意的是:**
> 
> 不要忘记结束标签:
> 
> ```html
> <font color="red">hello world!
> ```
> 
> - 即使忘记了使用结束标签，大多数浏览器也会正确地显示 HTML。
> - HTML 文档中，关闭标签是可选的。
> - 不要依赖这种做法。忘记使用结束标签会产生不可预料的结果或错误。
> 
> HTML 空元素:
> 
> - 没有内容的 HTML 元素被称为空元素。空元素是在开始标签中关闭的。
> - `<br>` 就是没有关闭标签的空元素（`<br>` 标签定义换行）。
> - 在 XHTML、XML 以及未来版本的 HTML 中，所有元素都必须被关闭。
> - 在开始标签中添加斜杠，比如 `<br />`，是关闭空元素的正确方法，HTML、XHTML 和 XML 都接受这种方式。
> - 即使 `<br>` 在所有浏览器中都是有效的，但使用 `<br />` 其实是更长远的保障。
> 
> 推荐使用小写标签:
> 
> - HTML 标签对大小写不敏感：`<P>` 等同于 `<p>`。许多网站都使用大写的 HTML 标签。
> - 万维网联盟（W3C）在 HTML 4 中推荐使用小写，而在未来 (X)HTML 版本中强制使用小写。

## HTML 属性

```html
<font color="red">hello world!</font>```

属性是 HTML 元素提供的附加信息。

- HTML 元素可以设置属性。
- 属性可以在元素中添加附加信息。
- 属性一般描述于开始标签。
- 属性总是以名称/值对的形式出现，比如：name="value"。

> **值得注意的是:**
> 
> HTML 属性常用引用属性值:
> 
> - 属性值应该始终被包括在引号内。
> - 双引号是最常用的，不过使用单引号也没有问题。 在某些个别的情况下，比如属性值本身就含有双引号，那么必须使用单引号。
> 
> 推荐使用小写属性:
> 
> - 属性和属性值对大小写不敏感。
> - 万维网联盟在其 HTML 4 推荐标准中推荐小写的属性/属性值。
> - 新版本的 (X)HTML 要求使用小写属性。

## HTML 注释

```html
<!-- 这是一个注释 -->
```

- 开始括号之后（左边的括号）需要紧跟一个叹号，结束括号之前（右边的括号）不需要。
- 浏览器会忽略注释，也不会显示它们。
- 将注释插入 HTML 代码中，这样可以提高其可读性，使代码更易被人理解。
- 合理地使用注释可以对未来的代码编辑工作产生帮助。

## HTML 文档

```
HTML文档 = 网页
```

- HTML文档描述网页
- HTML文档包含HTML标签和纯文本
- HTML文档也被称为网页
- HTML文档文件的后缀名为“.html”和“.htm”，两种后缀名没有任何区别

## HTML 基本结构

```html
<html>	<head>	</head>	<body>	</body></html>
```

## <!DOCTYPE> 声明

<!DOCTYPE> 声明有助于浏览器中正确显示网页。网络上有很多不同的文件，如果能够正确声明 HTML 的版本，浏览器就能正确显示网页内容。

- <!DOCTYPE> 声明位于文档中的最前面的位置，处于 <html> 标签之前。
- <!DOCTYPE> 声明不是一个 HTML 标签；它是用来告知 Web 浏览器页面使用了哪种 HTML 版本。
- 总是给您的 HTML 文档添加 <!DOCTYPE> 声明，确保浏览器能够预先知道文档类型。

各个HTML版本的<!DOCTYPE> 声明应如何书写:

- HTML 5

```html
<!DOCTYPE html>
```

- HTML 4.01 Strict

	这个 DTD 包含所有 HTML 元素和属性，但不包括表象或过时的元素（如 font ）。框架集是不允许的。

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
```

- HTML 4.01 Transitional

	这个 DTD 包含所有 HTML 元素和属性，包括表象或过时的元素（如 font ）。框架集是不允许的。

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
```

- HTML 4.01 Frameset

	这个 DTD 与 HTML 4.01 Transitional 相同，但是允许使用框架集内容。

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
```

## HTML 头部

### `<head>` 元素

`<head>` 元素包含了所有的头部标签元素。在 `<head>` 元素中你可以插入脚本（scripts）, 样式文件（CSS），及各种 meta 信息。

可以添加在头部区域的元素标签为: `<title>`, `<style>`, `<meta>`, `<link>`, `<script>`, `<noscript>`, and `<base>`。

### `<title>` 元素

`<title>` 标签定义了不同文档的标题。`<title>` 在 HTML/XHTML 文档中是必须的。

### `<base>` 元素

`<base>` 标签描述了基本的链接地址/链接目标，该标签作为 HTML 文档中所有的链接标签的默认链接。

### `<link>` 元素

`<link>` 标签定义了一个文档和外部资源之间的关系。

### `<style>` 元素

`<style>` 标签定义了HTML文档的样式文件引用地址。

### `<meta>` 元素

meta 标签描述了一些基本的元数据。`<meta>` 标签提供了元数据。元数据也不显示在页面上，但会被浏览器解析。

meta 元素通常用于指定网页的描述，关键词，文件的最后修改时间，作者，和其他元数据。元数据可以使用浏览器（如何显示内容或重新加载页面），搜索引擎（关键词），或其他 Web 服务。

> **`<meta>` 标签使用实例**
> 
> - 为搜索引擎定义关键词:
> 
> ```html
> <meta name="keywords" content="HTML, CSS, XML, XHTML, JavaScript">
> ```
> 
> - 为网页定义描述内容:
> 
> ```html
> <meta name="description" content="Free Web tutorials on HTML and CSS">
> ```
> 
> - 定义网页作者:
> 
> ```html
> <meta name="author" content="King">
> ```
> 
> - 每30秒中刷新当前页:
> 
> ```html
> <meta http-equiv="refresh" content="30">
> ```