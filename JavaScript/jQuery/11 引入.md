## JavaScript 类库

- **作用:** JavaScript 类库的出现，就是为了简化 JavaScript 的开发。
- **内容:** JavaScript 类库封装了预定义的对象和函数。
- **目的:** 帮助开发人员建立有高难度交互的 Web 2.0 特性的富客户端页面，并且兼容各大浏览器。

> **扩展内容**
> 
> Web 2.0 相关概念:
> 
> 1. Web 1.0: 网络 -> 人（单向信息。网络是信息提供者，单向的提供和单一理解）
> 2. Web 2.0: 人 -> 人（以网络为沟通渠道进行人与人沟通。网络是平台，用户提供信息，通过网络，其他用户获取信息）
> 3. Web 3.0: 人 -> 网络 -> 人（人与网络之间的双向沟通。网络成为用户需求理解者和提供者）
> 
> 富客户端与瘦客户端：
> 
> 1. 富客户端:（Rich Internet Applications，RIA）利用具有很强交互性的富客户端技术来为用户提供一个更高和更全方位的网络体验。
> 2. 瘦客户端:（Thin Client）指的是在客户端-服务器网络体系中的一个基本无需应用程序的计算机终端。

## jQuery 的编程步骤

- 在 HTML 页面引入 jQuery 文件

```html
<!-- 1. 引入jQuery文件 -->
<script src="jquery-1.11.3.js"></script>
```

- 在 HTML 页面定义元素

```html
<!-- 定义HTML页面元素 -->
<input type="text" value="请输入你的用户名" id="username">
```

- 使用 jQuery 的选择器定位元素

```javascript
// 2. 使用jQuery选择器定位HTML页面元素
var $username = $("#username");
```

- 利用 jQuery 提供的 API 完成需求

```javascript
// 3. 调用jQuery的API方法
console.log($username.val());
```

## jQuery 基础内容

### jQuery 工厂函数

jQuery 的工厂函数算做是 jQuery 的一个入口，通过它既可以使用选择器，也可以包装 DOM 对象，还可以创建元素等功能。

**工厂函数的写法有两种:**

- 第一种是 `$()`
- 第二种是 `jQuery()`

> 这里的 `$` 符号就表示 jQuery，是 jQuery 的一个约定。
> 
> 不仅如此，jQuery 也建议通过 jQuery 获取的元素变量前都增加 `$` 符号。目前有很多 JS 库都效仿了 jQuery 的这种做法，当然也引起了多个使用 `$` 的 JS 库一起使用时的一些冲突，主要还是集中在 `$` 的使用权上。

### jQuery 对象与 DOM 对象

#### DOM 对象

定义：是指通过 DOM 获取的元素。

#### jQuery 对象

定义：是通过包装 DOM 对象后产生的一种对象（jQuery 自定义的全局对象）。可以说 jQuery 底层其实还是 DOM 对象。

> **注意:** jQuery 是类数组对象，所以 jQuery 对象中可能包含多个 DOM 对象或一个 DOM 对象，这要看具体情况。

### DOM 对象转换为 jQuery 对象

DOM 对象要想转换为 jQuery 对象，需要使用 jQuery 的工厂函数 `$()` 将其包裹，返回的就是对应的 jQuery 对象。

```javascript
// DOM对象
var username = document.getElementById("username");
// DOM对象转换为jQuery对象
var $username = $(username);
// 测试
console.log($username.val());
```

### jQuery 对象转换为 DOM 对象

- jQuery 对象是数组对象。jQuery 对象[索引值]可以直接转换为对应的 DOM 对象

```javascript
// jQuery对象
var $user = $("#username");
// 1. jQuery对象是数组对象
var user1 = $user[0];
// 测试
console.log(user1.value);
```

- jQuery提供了get(index)方法。jQuery对象.get(索引值)也可以转换为对应的DOM对象

```
// jQuery对象
var $user = $("#username");
// 2. jQuery提供get(index)方法进行转换
var user2 = $user.get(0);
// 测试
console.log(user2.value);
```