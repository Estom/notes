允许用户在一个元素上点击并按住鼠标按钮，拖动它到别的位置，然后松开鼠标按钮将元素放到那儿。

在拖动操作过程中，被拖动元素会以半透明形式展现，并跟随鼠标指针移动。放置元素的位置可能会在不同的应用内。

## 源元素事件

**所谓源元素**就是被拖动的元素。

| 事件名称 | 作用 | 触发次数 |
| --- | --- | --- |
| dragstart事件 | 开始拖动源元素时被触发 | 只被触发一次|
| drag事件 | 拖动的过程中，实时被触发 | 被触发多次 |
| dragend事件 | 结束拖动源元素时被触发 | 只被触发一次 |

```html
<div id="d1">
	<img id="img" src="Penguins.jpg" width="256">
</div>
<script>
	// 获取HTML页面中的源元素<img>
	var img = document.getElementById("img");
	// 为源元素绑定拖动事件
	img.addEventListener("dragstart",myDragstart);
	img.addEventListener("drag",myDrag);
	img.addEventListener("dragend",myDragend);
	// 定义事件的处理函数
	function myDragstart(event){
		console.log("开始拖动啦...");
	}
	function myDrag(event){
		console.log("拖动过程中...");
	}
	function myDragend(event){
		console.log("结束拖动啦...");
	}
</script>
```

## 目标元素事件

**所谓目标元素**就是投放到的元素。

| 事件名称 | 作用 | 触发次数 |
| --- | --- | --- |
| dragenter事件 | 当源元素到达目标元素时被触发 | 只被触发一次|
| dragover事件 | 当源元素到达目标元素时被触发 | 被触发多次。阻止默认行为，触发drop事件 |
| drop事件 | 当源元素投放在目标元素时被触发 | 默认该事件不会被触发 |
| dragleave事件 | 当源元素离开目标元素时被触发 | 只被触发一次 |

```html
<div id="d1">
	<img id="img" src="Penguins.jpg" width="256">
</div>
<div id="d2"></div>
<script>
	// 获取目标元素
	var d2 = document.getElementById("d2");
	// 为目标元素绑定事件
	d2.addEventListener("dragenter",myDragenter);
	d2.addEventListener("dragover",myDragover);
	d2.addEventListener("drop",myDrop);
	d2.addEventListener("dragleave",myDragleave);
	// 定义事件的处理函数
	function myDragenter(event){
		//event.preventDefault();
		console.log("大爷,你来啦...");
	}
	function myDragover(event){
		event.preventDefault();
		console.log("大爷,又来啦...");
	}
	function myDrop(event){
		//event.preventDefault();
		console.log("大爷,别走啦...");
	}
	function myDragleave(event){
		//event.preventDefault();
		console.log("大爷,要走啦...");
	}
</script>
```

## dataTransfer对象

该对象已被集成在 `event` 对象中，起到剪切板的功能。

| 方法名称 | 作用 | 场景 |
| --- | --- | --- |
| setData(type,data) | 存储数据 | 在源元素事件中 |
| getData(type) | 取出数据 | 在目标元素事件中 |
| clearData() | 清除剪切板中所有数据 | |

参数：
		
- type：指定当前存储数据的类型(标识)。
- data：需要中转的数据内容。

```html
<div id="d1">
	<img id="img" src="Penguins.jpg" width="256">
</div>
<div id="d2"></div>
<script>
	// 1. 获取源元素和目标元素
	var img = document.getElementById("img");
	var d2 = document.getElementById("d2");
	/*
	   2. 为源元素和目标元素绑定事件
	   * 绑定源元素事件的目的:
	     * 通过dataTransfer对象获取源元素的关键数据
		 * 只需绑定dragstart事件即可
	   * 绑定目标元素事件的目的:
	     * 通过dataTransfer对象使用源元素的关键数据
		 * 需要绑定dragover和drop事件
	 */
	img.addEventListener("dragstart",function(event){
		// 通过dataTransfer对象,存储源元素的关键数据
		event.dataTransfer.setData("text",img.src);
	});
	d2.addEventListener("dragover",function(event){
		event.preventDefault();
	});
	d2.addEventListener("drop",function(event){
		// 通过dataTransfer对象,使用源元素的关键数据
		var src = event.dataTransfer.getData("text");
		
		//d2.innerHTML = "<img src='"+src+"' width='256'>";

		var newImg = document.createElement("img");
		newImg.src = src;
		newImg.width = "256";
		newImg.id = "newImg";
		d2.appendChild(newImg);

		img.parentNode.removeChild(img);
	});
</script>
```