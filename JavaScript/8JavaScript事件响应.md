## 1 常见事件

> 本质上也是一种异步通信的方式。基于回调的异步通信，和基于事件响应机制的异步通信。

### 鼠标事件

* onclick	用户点击了 HTML 元素
* ondblclick	当用户双击某个对象时调用的事件句柄
* onmousedown	鼠标按钮被按下。	
* onmouseenter	当鼠标指针移动到元素上时触发。	
* onmouseleave	当鼠标指针移出元素时触发	
* onmousemove	鼠标被移动。	
* onmouseover	鼠标移到某元素之上。	
* onmouseout	鼠标从某元素移开。	
* onmouseup	鼠标按键被松开。


### 键盘事件


* onkeydown	用户按下键盘按键
* onkeypress	某个键盘按键被按下并松开。	
* onkeyup	某个键盘按键被松开。
### 框架对象事件

* onabort	图像的加载被中断。 ( <object>)	2
* onbeforeunload	该事件在即将离开页面（刷新或关闭）时触发	2
* onerror	在加载文档或图像时发生错误。 ( <object>, <body>和 <frameset>)	 
* onhashchange	该事件在当前 URL 的锚部分发生修改时触发。	 
* onload	一张页面或一幅图像完成加载。	2
* onpageshow	该事件在用户访问页面时触发	
* onpagehide	该事件在用户离开当前网页跳转到另外一个页面时触发	
* onresize	窗口或框架被重新调整大小。	2
* onscroll	当文档被滚动时发生的事件。	2
* onunload	用户退出页面。 ( <body> 和 <frameset>)

### 表单事件

* onblur	元素失去焦点时触发	2
* onchange	该事件在表单元素的内容改变时触发( <input>, <keygen>, <select>, 和 <textarea>)	2
* onfocus	元素获取焦点时触发	2
* onfocusin	元素即将获取焦点时触发	2
* onfocusout	元素即将失去焦点时触发	2
* oninput	元素获取用户输入时触发	3
* onreset	表单重置时触发	2
* onsearch	用户向搜索域输入文本时触发 ( <input="search">)	 
* onselect	用户选取文本时触发 ( <input> 和 <textarea>)	2
* onsubmit	表单提交时触发
### 剪贴板事件
### 打印事件
### 拖动事件

* ondrag	该事件在元素正在拖动时触发	 
* ondragend	该事件在用户完成元素的拖动时触发	 
* ondragenter	该事件在拖动的元素进入放置目标时触发	 
* ondragleave	该事件在拖动元素离开放置目标时触发	 
* ondragover	该事件在拖动元素在放置目标上时触发	 
* ondragstart	该事件在用户开始拖动元素时触发	 
* ondrop	该事件在拖动元素放置在目标区域时触发* 
### 多媒体事件


### 动画事件

* animationend	该事件在 CSS 动画结束播放时触发	 
* animationiteration	该事件在 CSS 动画重复播放时触发	 
* animationstart	该事件在 CSS 动画开始播放时触发
### 过度事件
### 其他事件

## 2 
## 3 事件处理

### 通过HTML事件属性，绑定JS方法
```
<button onclick="displayDate()">点这里</button>
```

### 通过JS给HTML对象添加事件属性，并绑定方法

```
<script>
document.getElementById("myBtn").onclick=function(){displayDate()};
</script>
```