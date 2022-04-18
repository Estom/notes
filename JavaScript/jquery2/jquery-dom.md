DOM 是 Document Object Model 的缩写，译为 **文档对象模型**。根据 W3C DOM 规范，DOM 是一种与浏览器、平台、语言无关的接口，使用该接口可以轻松地访问页面中所有的标准组件。

jQuery 中另一个重要的组成部分就是封装了原生 DOM 的操作。

## 基本操作

### html操作

html() 方法用于读取或设置指定元素的 HTML 代码，类似于原生 DOM 中的 innerHTML 属性。

```javascript
//获取<p>元素的HTML代码
$("input:eq(0)").click(function(){
    alert(  $("p").html() );
});
//设置<p>元素的HTML代码
$("input:eq(1)").click(function(){
    $("p").html("<strong>你最讨厌的水果是?</strong>");
});
```

### 文本操作

text() 方法用于读取或设置指定元素的文本内容，类似于原生 DOM 中的 textContent 属性。

```javascript
//获取<p>元素的文本
$("input:eq(0)").click(function(){
    alert(  $("p").text() );
});
//设置<p>元素的文本
$("input:eq(1)").click(function(){
    $("p").text("你最讨厌的水果是?");
});
```

### 值操作

val() 方法用于读取或设置指定元素的 value 属性值，类似于原生 DOM 中的 value 属性。

```javascript
//获取按钮的value值
$("input:eq(0)").click(function(){
   alert( $(this).val() );
});
//设置按钮的value值
$("input:eq(1)").click(function(){
   $(this).val("我被点击了!");
});
```

### 属性操作

- attr() 方法用于获取或设置指定元素的属性，类似于原生 DOM 中的 getAttribute() 方法和 setAttribute() 方法。
- removeAttr() 方法用于删除指定元素的属性，类似于原生 DOM 中的 removeAttribute() 方法。

```javascript
//设置<p>元素的属性'title'
$("input:eq(0)").click(function(){
   $("p").attr("title","选择你最喜欢的水果.");
});
//获取<p>元素的属性'title'
$("input:eq(1)").click(function(){
   alert( $("p").attr("title") );
});
//删除<p>元素的属性'title'
$("input:eq(2)").click(function(){
   $("p").removeAttr("title");
});
```

## 样式操作

操作样式主要分成两种：

- 一种是使用style属性直接设置CSS中的属性
- 一种是使用class样式名称设置CSS。

### attr() 方法操作

class 本身就是元素中的一个属性，所以也可以使用设置属性方式来设置或删除 class 样式。

**语法结构:**

```javascript
element.attr("class",className)
```

> **值得注意的是:** 使用 attr() 方法设置 class 样式时，无论之前是否包含 class 属性，之前设置的样式都会被覆盖。

```javascript
//<input type="button" value="采用属性增加样式"  id="b1"/>
$("#b1").click(function(){
   $("#mover").attr("class","one");
})
```

### addClass() 方法操作

addClass() 方法表示追加样式，也就是说，无论之前是否包含 class 样式，调用 addClass() 方法只是在其基础上增加一个新的样式。而之前设置的样式依旧存在。

```javascript
//<input type="button" value=" addClass"  id="b2"/>
$("#b2").click(function(){
   $("#mover").addClass("mini");
})
```

### removeClass() 方法操作

removeClass() 方法表示删除样式，但该方法的使用有以下三种方式:

- removeClass(): 默认不传递任何参数，表示删除所有样式。
- removeClass(className): 传递一个样式名称，表示删除指定一个样式。
- removeClass(className1 className2): 传递多个样式名称，中间使用空格隔开，表示删除指定多个样式。

```javascript
//<input type="button" value="removeClass"  id="b3"/>
$("#b3").click(function(){
   $("#mover").removeClass();
})
```

### toggleClass() 方法操作

toggleClass() 方法表示在没有样式与指定样式之间进行切换，效果相当于使用 addClass() 方法和 removeClass() 方法。

```javascript
//<input type="button" value=" 切换样式"  id="b4"/>
$("#b4").click(function(){
   // 在没有样式与指定样式之间切换
   $("#mover").toggleClass("one");
})
```

### hasClass() 方法操作

hasClass() 方法表示指定元素是否包含指定样式。

> **值得注意的是:** hasClass() 方法并不能判断是否包含样式，而是判断是否包含指定样式。

```javascript
//<input type="button" value=" hasClass"  id="b5"/>
$("#b5").click(function(){
   // 判断是否含有某个指定样式
   alert($("#mover").hasClass("one"));
})
```

### css() 方法操作

css() 方法也可以获取或设置 CSS 样式，但并不是通过 class 属性，而是通过 style 属性直接设置 CSS 中的属性。

#### 获取样式: 

css(attrName) 方法，用于获取当前 style 属性的值。

#### 设置样式: 

- css(attrName,attrValue) 方法，用于设置当前 style 属性的值。**但每次只能设置一个CSS中的属性。**
- css({attrName:attrValue,attrName:attrValue,…}) 方法，用于设置当前 style 属性的值。**每次可以设置多个CSS中的属性。**

## 遍历节点

### 获取父元素

parent() 方法可以获取指定元素的父元素。

- parent() 方法: 不传递任何参数，是获取指定元素的父元素。
- parent(selector) 方法: 是获取指定元素的符合 selector 选择器的父元素。

```javascript
var $parent = $("li:first").parent();	//第一个<li>元素的父元素
```

### 获取子元素

children() 方法可以获取指定元素的子元素。

- children() 方法: 不传递任何参数，可以获取指定元素的所有子元素。
- children(selector) 方法: 是获取指定元素的符合 selector 选择器的子元素。

```javascript
var $ul = $("ul").children();
alert( $ul.length );//<p>元素下有3个子元素
```

### 获取兄弟元素

**next() 方法是获取指定元素的下一个兄弟元素。**

- next() 方法: 不传递任何参数，是获取指定元素的下一个兄弟元素。
- next(selector) 方法: 是获取指定元素符合 selector 选择器的下一个兄弟元素。

```javascript
var $p1 = $("p").next();
alert( $p1.html() );  //  紧邻<p>元素后的同辈元素
```

**prev() 方法是获取指定元素的上一个兄弟元素。**

- prev()方法: 不传递任何参数，是获取指定元素的上一个兄弟元素。
- prev(selector) 方法: 是获取指定元素符合 selector 选择器的上一个兄弟元素。

```javascript
var $ul = $("ul").prev();
alert( $ul.html() );  //  紧邻<ul>元素前的同辈元素
```

**siblings() 方法是获取指定元素的所有兄弟元素。**


- siblings()方法: 不传递任何参数，是获取指定元素的所有兄弟元素。
- siblings(selector) 方法:是获取指定元素符合 selector 选择器的所有兄弟元素。

```javascript
var $p2 = $("p").siblings();
alert( $p2.html() );  //  紧邻<p>元素的唯一同辈元素
```

### 查找指定后代元素

find(selector) 方法，可以查找指定元素的符合 selector 选择器的后代元素。

```javascript
var eles = $("ul").find("li");	//查找ul元素下的所有li元素
```

## 创建操作

按照原生 DOM 的思路，创建节点需要分别创建元素节点、文本节点和属性节点。

- 元素节点，使用 jQuery 的工厂函数 `$(HTML代码)` 来创建。
- 文本节点，使用 jQuery 的 `text()` 方法进行设置文本，而不需要创建文本节点。
- 属性节点，使用 jQuery 的 `attr()` 方法进行设置属性，而不需要创建属性节点。

其实，使用 jQuery 创建元素，并不需要按照原生 DOM 的思路进行创建。可以一步代码创建完整的元素。

```javascript
//创建一个<li>元素 包括元素节点,文本节点和属性节点
var $li = $("<li title='香蕉'>香蕉</li>");

// 获取<ul>节点 <li>的父节点
var $parent = $("ul");

// 添加到<ul>节点中，使之能在网页中显示
$parent.append($li);
```

## 插入操作

jQuery 中的插入操作分为内部插入和外部插入。

### 内部插入
	
- append() 方法: 将 append() 后面的元素插入在 append() 前面指定元素的后面。
- prepend() 方法: 将 prepend() 后面的元素插入在 prepend() 前面指定元素的前面。
- appendTo() 方法: 将 appendTo() 前面的元素插入在 appendTo() 后面的元素的后面。
- prependTo() 方法: 将 prependTo() 前面的元素插入在 prependTo() 后面的元素的前面。

```javascript
// append - append后面的节点被添加到append前面的节点的后面
$("#tj").append($("#ms"));

// prepend - prepend后面的节点被添加到prepend前面的节点的前面
$("#tj").prepend($("#ms"));

// appendTo - appendTo前面的节点被添加到appendTo后面的节点的后面
$("#tj").appendTo($("#ms"));

// prependTo - prependTo前面的节点被添加到prependTo后面的节点的前面
$("#tj").prependTo($("#ms"));
```

### 外部插入
	
- before() 方法: 将 before() 后面的元素插入在 before() 前面的指定元素的前面。
- after() 方法: 将 after() 后面的元素插入在 after() 前面的指定元素的后面。
- insertBefore() 方法: 将 insertBefore() 前面的元素插入在 insertBefore() 后面的指定元素的前面。
- insertAfter() 方法: 将 insertAfter() 前面的元素插入在 insertAfter() 后面的指定元素的后面。

```javascript
// before - before后面的节点被添加到before前面的节点的前面
$("#tj").before($("#ms"));

// after - after后面的节点被添加到after前面的节点的后面
$("#tj").after($("#ms"));

// insertBefore
$("#tj").insertBefore($("#ms"));

// insertAfter
$("#tj").insertAfter($("#ms"));
```

## 删除操作

jQuery 中的删除操作分别为 remove() 方法和 empty() 方法。

- remove() 方法: 删除自身元素及所有后代元素。
- empty() 方法: 删除所有后代元素，但保留自身元素。该方法适合完成清空操作。

```javascript
$("ul li:eq(1)").remove(); // 获取第二个<li>元素节点后，将它从网页中删除

$("ul li").remove("li[title!=菠萝]");  //把<li>元素中属性title不等于"菠萝"的<li>元素删除

$("ul li:eq(1)").empty(); // 获取第二个<li>元素节点后，清空此元素里的内容
```

## 替换操作

jQuery 中的替换操作分别为 replaceWith() 方法和 replaceAll() 方法。

- replaceWith() 方法: 该方法前面的元素是被替换元素。
- replaceAll() 方法: 就是颠倒了的repalceWith( )方法。

```javascript
$("p").replaceWith("<strong>你最不喜欢的水果是?</strong>");
// 同样的实现： $("<strong>你最不喜欢的水果是?</strong>").replaceAll("p");
```

## 复制操作

jQuery 中的复制操作使用的方法为 clone() 方法，该方法与原生 DOM 中的复制节点的方法cloneNode() 在使用时极为相似。

- 原生 DOM 中的 cloneNode(Boolean) 方法，参数 Boolean 表示是否复制后代节点。
- jQuery 中的 clone(Boolean) 方法，参数 Boolean 表示是否复制事件。

```javascript
$("ul li").click(function(){
   $(this).clone().appendTo("ul"); // 复制当前点击的节点，并将它追加到<ul>元素
   $(this).clone(true).appendTo("ul"); // 注意参数true
   //可以复制自己，并且他的副本也有同样功能
})
```