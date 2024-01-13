## 页面加载

原生 DOM 中的事件具有页面加载的内容 onload 事件，在 jQuery 中同样提供了对应的内容ready() 函数。

### ready与onload之间的区别

| onload | ready |
| ------- | ------ |
| 没有简写方式 | 具有简写方式 | 
| 当HTML页面所有内容加载完毕后才执行onload | 当DOM节点加载完毕后就执行ready |
| 一个HTML页面只能编写一个onload | 一个HTML页面允许同时编写多个ready |

### ready()的编写方式

- $(document).ready(function(){});
- $().ready(function(){});
- $(function(){});

## 事件绑定

jQuery 中提供了事件绑定与解绑机制，类似于原生 DOM 中的 addEventListener() 方法。

### jQuery 的事件绑定

#### 单事件绑定

单事件绑定就是指为指定元素绑定一个指定的事件，例如 click、change 等。

```javascript
<div id="panel">
    <h5 class="head">什么是jQuery?</h5>
    <div class="content">
        jQuery是继Prototype之后又一个优秀的JavaScript库，它是一个由 John Resig 创建于2006年1月的开源项目。jQuery凭借简洁的语法和跨平台的兼容性，极大地简化了JavaScript开发人员遍历HTML文档、操作DOM、处理事件、执行动画和开发Ajax。它独特而又优雅的代码风格改变了JavaScript程序员的设计思路和编写程序的方式。
    </div>
</div>

<script>
    $("#panel h5.head").bind("click",function(){
        var $content = $(this).next("div.content");
        if($content.is(":visible")){
           $content.hide();
        }else{
           $content.show();
        }
    })
</script>
```

#### 多事件绑定

多事件绑定就是为指定元素同时绑定多个指定的事件，例如同时绑定 mouseover 和 mouseout 事件等。

```javascript
<div id="panel">
    <h5 class="head">什么是jQuery?</h5>
    <div class="content">
        jQuery是继Prototype之后又一个优秀的JavaScript库，它是一个由 John Resig 创建于2006年1月的开源项目。jQuery凭借简洁的语法和跨平台的兼容性，极大地简化了JavaScript开发人员遍历HTML文档、操作DOM、处理事件、执行动画和开发Ajax。它独特而又优雅的代码风格改变了JavaScript程序员的设计思路和编写程序的方式。
    </div>
</div>

<script>
   $("#panel h5.head").bind("mouseover mouseout",function(){
       var $content = $(this).next("div.content");
       if($content.is(":visible")){
           $content.hide();
       }else{
           $content.show();
       }
   });
</script>
```

## 模拟操作

模拟操作就是指通过程序模拟用户在页面中的操作，比如用户点击某个按钮的事件完成一个效果，jQuery 中可以通过该方法模拟用户点击按钮事件。也就是说，不需要用户的操作行为，而是我们通过程序来模拟用户操作。

```javascript
<button id="btn">点击我</button>
<div id="test"></div>

<script>
    $('#btn').bind("click", function(){
        $('#test').append("<p>我的绑定函数1</p>");
    }).bind("click", function(){
        $('#test').append("<p>我的绑定函数2</p>");
    }).bind("click", function(){
        $('#test').append("<p>我的绑定函数3</p>");
    });
    $('#btn').trigger("click");
</script>
```

## 与其他JS库共存

### 第一种方式

```javascript
/*
  * 先引入其他JS库,后引入jQuery
  * * "$"符号属于其他JS库
  * 解决冲突
  * * jQuery中 - "$"符号指代jQuery
  * * jQuery中不再使用"$"符号
  */
jQuery(document).ready(function(){
	console.log("this is ready.");
});
```

### 第二种方式

```javascript
jQuery(document).ready(function($){
	// 在当前函数中使用"$"符号 - jQuery
});
// "$"符号 - 其他JS库
```

### 第三种方式

```javascript
(function($){
	// "$"符号 - jQuery
})(jQuery);
// "$"符号 - 其他JS库
```

### 第四种方式

```javascript
jQuery.noConflict();
jQuery(function($){
	console.log($("p").text());
});
```

### 第五种方式

```javascript
jQuery.noConflict();
(function($){
	console.log($("p").text());
})(jQuery);
```