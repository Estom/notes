# JavaScrip对象
## 0 对象

### typeof
在JavaScript一切皆对象。

使用typeof运算符获取对象类型。返回对象类型。

### 包装对象

将基本类型转换为对象类型。
```
var n = new Number(123); // 123,生成了新的包装类型
var b = new Boolean(true); // true,生成了新的包装类型
var s = new String('str'); // 'str',生成了新的包装类型
```
## 1 JavaScript内建对象

### Array对象

Array 对象用于在变量中存储多个值
### Boolean对象

Boolean 对象用于转换一个不是 Boolean 类型的值转换为 Boolean 类型值 (true 或者false).
### Date对象

Date 对象用于处理日期与时间。
### Math对象

Math 对象用于执行数学任务。
### Number对象
原始数值的包装对象
### String对象

处理文本字符串
### RegExp对象

正则表达式字符串的处理
### 全局属性、函数

encode、decode系列
数据类型转换系列
### Error对象
在错误发生时，提供了错误的提示信息。

## 2 Browser对象

### window对象

表示浏览器打开的窗口。是默认的全局对象。默认绑定了alert等方法。

### Navigator对象

包含浏览器相关的信息。

### Screen对象

客户端显示屏相关的信息。
### History对象

包含用户在浏览器中访问过的URL。是window对象的一部分。

### Location对象

包含当前的URL信息。是window对象的一部分。
### 存储对象

webAPI提供了sessionStorage(会话存储)和localStorage(本地存储)两个对象来对网页的数据进行增删查改操作。

localStorage 用于长久保存整个网站的数据，保存的数据没有过期时间，直到手动去除。

sessionStorage 用于临时保存同一窗口(或标签页)的数据，在关闭窗口或标签页之后将会删除这些数据。


## 3 DOM对象

* 文档是一个文档节点
* 所有的HTML元素是元素节点
* 所有的HTML属性是属性节点
* 文本插入到HTML元素是文本节点
* 注释是注释节点。
### DOM Document对象

当浏览器载入 HTML 文档, 它就会成为 Document 对象。

Document 对象是 HTML 文档的根节点。

Document 对象使我们可以从脚本中对 HTML 页面中的所有元素进行访问。

Document 对象是 Window 对象的一部分，可通过 window.document 属性对其进行访问
### DOM元素对象

元素对象代表着一个 HTML 元素。

元素对象 的 子节点可以是, 可以是元素节点，文本节点，注释节点。

NodeList 对象 代表了节点列表，类似于 HTML元素的子节点集合。

元素可以有属性。属性属于属性节点（查看下一章节）。
### DOM属性对象

在 HTML DOM 中, Attr 对象 代表一个 HTML 属性。

HTML属性总是属于HTML元素。

在 HTML DOM 中, the NamedNodeMap 对象 表示一个无顺序的节点列表。

我们可通过节点名称来访问 NamedNodeMap 中的节点。

### DOM事件对象

HTML DOM 事件允许Javascript在HTML文档元素中注册不同事件处理程序。

事件通常与函数结合使用，函数不会在事件发生前被执行！ (如用户点击按钮)。

### DOMConsole对象

Console 对象提供了访问浏览器调试模式的信息到控制台。


### CSS Style Declaration对象

CSSStyleDeclaration 对象表示一个 CSS 属性-值（property-value）对的集合。
### DOMHTMLCollection
HTMLCollection 是 HTML 元素的集合。

HTMLCollection 对象类似一个包含 HTML 元素的数组列表。
