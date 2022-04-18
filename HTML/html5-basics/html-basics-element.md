## 示例代码

```html
<!DOCTYPE html><html>  <head>    <title>06_基本元素实例.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <h1 align="center">春晓</h1>	<hr align="center" width="30%">	<p align="center">		春眠不觉晓， <br>		处处闻啼鸟。<br>		夜来风雨声，<br>		花落知多少。<br>	</p>  </body></html>
```

## HTML 标题

```html
<!DOCTYPE html><html>  <head>    <title>02_标题元素.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <h1>这是标题 1</h1>	<h2>这是标题 2</h2>	<h3>这是标题 3</h3>	<h4>这是标题 4</h4>	<h5>这是标题 5</h5>	<h6>这是标题 6</h6>  </body></html>
```

在 HTML 文档中，标题很重要。

- 标题（Heading）是通过 `<h1>` - `<h6>` 标签进行定义的。
- `<h1>` 定义最大的标题。 `<h6>` 定义最小的标题。
- 浏览器会自动地在标题的前后添加空行。
- 用户可以通过标题来快速浏览您网页。

> **值得注意的是:**
> 
> - 标题（Heading）在浏览器运行显示的效果并不重要。（后面可以通过 CSS 进行修改）
> - 标题（Heading）更重要的在于其语义化。
> - 搜索引擎检索 HTML 页面时，`<h1>` 元素仅次于 `<title>` 元素。
> - 一般一个 HTML 页面中只包含一个 `<h1>` 元素。

## 段落

```html
<!DOCTYPE html><html>  <head>    <title>03_段落元素.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <p>这是一个段落。</p>    <p>这是一个段落。</p>    <p>这是一个段落。</p>  </body></html>
```

- 段落是通过 `<p>` 标签定义的。
- 浏览器会自动地在段落的前后添加空行。

> **值得注意的是:不要忘记结束标签。**
> 
> - 即使忘了使用结束标签，大多数浏览器也会正确地将 HTML 显示出来，但不要依赖这种做法。
> - 忘记使用结束标签会产生意想不到的结果和错误。
> - 在未来的 HTML 版本中，不允许省略结束标签。

## 换行

```html
<!DOCTYPE html><html>  <head>    <title>04_换行元素.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <p>This is<br>a para<br>graph with line breaks</p>  </body></html>
```

- 在不产生一个新段落的情况下进行换行（新行），请使用 `<br />` 标签。
- `<br />` 元素是一个空的 HTML 元素。
- 由于关闭标签没有任何意义，因此它没有结束标签。

## 水平线

```html
<!DOCTYPE html><html>  <head>    <title>05_水平线元素.html</title>    <meta http-equiv="content-type" content="text/html; charset=UTF-8">  </head>  <body>    <p>hr 标签定义水平线：</p>	<hr />	<p>这是段落。</p>	<hr />	<p>这是段落。</p>	<hr />	<p>这是段落。</p>  </body></html>
```

- `<hr>` 标签在 HTML 页面中创建水平线。
- hr 元素可用于分隔内容。