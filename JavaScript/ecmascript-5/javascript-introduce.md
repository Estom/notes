## JavaScript 介绍

### 什么是 JavaScript

JavaScript 是一种由 Netscape 的 LiveScript 发展而来的原型化继承的基于对象的动态类型的区分大小写的客户端脚本语言，主要目的是为了解决服务器端语言，比如 Perl，遗留的速度问题，为客户提供更流畅的浏览效果。

当时服务端需要对数据进行验证，由于网络速度相当缓慢，只有 28.8kbps，验证步骤浪费的时间太多。于是 Netscape 的浏览器 Navigator 加入了 JavaScript，提供了数据验证的基本功能。

JavaScript，一种直译式脚本语言，是一种动态类型、弱类型、基于原型的语言，内置支持类型。它的解释器被称为 JavaScript 引擎，为浏览器的一部分，广泛用于客户端的脚本语言，最早是在 HTML 网页上使用，用来给HTML网页增加动态功能。然而现在 JavaScript 也可被用于网络服务器，如 Node.js。

### JavaScript发展历史

- 在 1995 年由 Netscape (网景)公司推出 LiveScript。在此之前，没有所谓的前端技术。所有的处理都需要由服务器端进行操作。当时的目的是同时在客户端和服务器端使用。
- 由 Netscape(网景)公司联合 SUN 公司完善 LiveScrip。此时， Netscape(网景)公司将 LiveScript 更名为 JavaScript。目的是利用 Java 语言的流行。
- 微软在推出 IE3.0 时，使用了 JavaScript 的克隆版本，Jscript。
- 在 1997 年，JavaScript 1.1 由欧洲计算机制造商协会定义。此举，只为 JavaScript 语言定制统一的语言版本。该全新版本的推出，更名为 ECMAScript。该版本由 Netscape、Sun、微软等共同定义。

### JavaScript 组成部分

- ECMAScript
	- ECMAScript是一种脚本语言的标准，ECMA-262标准。
	- 该标准不仅限于JavaScript语言使用，例如ActionScript语言中的标准也为ECMA-262标准。
	- ECMAScript 描述了以下内容：语法、类型、语句、关键字、保留字、运算符和对象等。
- BOM：全称： Browser Object Model，译为浏览器对象模型。
- DOM：全称： Document Object Model，译为文档对象模型。

## ECMAScript 介绍

### 什么是 ECMAScript

ECMAScript 是一种由 Ecma 国际（前身为欧洲计算机制造商协会）通过 ECMA-262 标准化的脚本程序设计语言。这种语言在万维网上应用广泛，它往往被称为 JavaScript 或 JScript，但实际上后两者是 ECMA-262 标准的实现和扩展。

### ECMAScript 发展历史

- 1995 年 12 月 SUN 公司与 Netscape 公司一起引入了 JavaScript。
- 1996 年 03 月网景通讯公司发表了支持 JavaScript 的网景导航者2.0。
- 1996 年 08 月由于 JavaScript 作为网页的客户面脚本语言非常成功，微软将之引入了Internet Explorer 3.0，取名 JScript。
- 1996 年 11 月网景通讯公司将 JavaScript 提交给欧洲计算机制造商协会进行标准化。
- 1997 年 06 月 ECMA-262 的第一个版本被欧洲计算机制造商协会采纳。并将 ECMA-262 标准取名为 ECMAScript。

## 如何使用 JavaScript

可以在HTML页面中的任何位置，使用 `<script></script>` 标签来插入 JavaScript。

> **值得注意的是:** 在 HTML 页面中的不同位置，插入 JavaScript。执行地效果各不相同（执行顺序是自上而下）。

`<script>` 标签的属性说明:

| 属性名 | 描述 |
| --- | --- |
| type | text/javascript，指定使用的脚本语言。|
| language | JavaScript，也是指定使用的脚本语言。弃用！|
| src | 载入外部JavaScript脚本代码（路径可以是绝对路径和相对路径）。|

> **值得注意的是:** 如果编写 DOM 代码时，JavaScript 插入在 HTML 页面的位置是有区别的。