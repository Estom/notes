在开发 Web 应用时，开发人员有时需要在本地存储数据。当前浏览器支持 cookie 存储，但其大小有 4KB 的限制。

HTML5 中新引入了 Web Storage 机制，通过使用键值对在客户端保存数据，并且提供了更大容量的存储空间。

HTML5 中的 Web 存储对象有两种类型：

* sessionStorage 对象负责存储一个会话的数据。如果用户关闭了页面或浏览器，则会销毁数据。
* localStorage 对象负责存储没有到期的数据。当 Web 页面或浏览器关闭时，仍会保持数据的存储，当然这还取决于为此用户的浏览器设置的存储量。

这两种存储对象具有相同的方法和属性。

> **值得注意的是：**Web 存储并不比 cookies 安全。所以不要在客户端存储敏感信息，比如密码或信用卡信息。

官方规范资料地址：[https://html.spec.whatwg.org/multipage/webstorage.html](https://html.spec.whatwg.org/multipage/webstorage.html)

## sessionStorge

### 浏览器支持性检查

```javascript
 //sessionStorage 
 if(window.sessionStorage){ 
    alert(“support sessionStorage”); 
 }else{ 
    alert(“not support sessionStorage”); 
    // 不支持 sessionStorage 
 } 
```

### sessionStorage的方法

| 方法名称 | 描述 |
| ---- | --- |
| setItem(key, value) | 为 Web 存储对象添加一个键/值对，供以后使用。该值可以是任何的数据类型：字符串、数值、数组等。|
| getItem(key) | 基于起初用来存储它的这个键检索值。|
| clear() | 从此 Web 存储对象清除所有的键/值对。|
| removeItem(key) | 基于某个键从此 Web 存储对象清除特定的键/值对。|
| key(n) | 检索 key[n] 的值。|

#### a. 向 Web 存储对象添加键/值对

* 使用 `setItem()` 方法

```javascript
sessionStorage.setItem('myKey', 'myValue');
```

* 使用 Web 存储对象来直接设置此键的值

```javascript
sessionStorage.myKey = 'myValue';
```

#### b. 从 Web 存储对象中检索键/值对

* 使用 `getItem()` 方法

```javascript
sessionStorage.getItem('myKey');
```

* 使用 Web 存储对象来直接获取此键的值

```javascript
sessionStorage.myKey;
```

#### c. 删除所有键/值对

```javascript
sessionStorage.clear();
```

#### d. 删除单个键/值对

```javascript
sessionStorage.removeItem('myKey');
```

### 示例代码

```html
<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>sessionStorage</title>
 </head>
 <body>
  <input type="text" id="data">
  <input type="button" id="save" value="保存">
  <input type="button" id="read" value="读取">
  <input type="button" id="dele" value="删除">
  <script>
	var save = document.getElementById("save");
	save.onclick = function(){
		// 将用户输入的数据,保存到sessionStorage中
		// 1. 获取用户输入的数据
		var value = document.getElementById("data").value;
		// 2. 如何生成存储数据所使用的KEY
		var key = new Date().getTime();// 时间戳
		// 3. 存储数据
		window.sessionStorage.setItem(key,value);
	}
	var read = document.getElementById("read");
	read.onclick = function(){
		// 读取sessionSotorage中所有的数据
		// 1. 获取当前sessionStorage中所有数据的个数
		var count = window.sessionStorage.length;
		// 2. 进行遍历
		for(var i=0;i<count;i++){
			// 3. 根据索引值得到key
			var key = window.sessionStorage.key(i);
			// 4. 根据key值得到value
			var value = window.sessionStorage.getItem(key);
			// 5. 进行测试
			console.log(key + " : " + value);
		}
	}
	var dele = document.getElementById("dele");
	dele.onclick = function(){
		// removeItem()
		//window.sessionStorage.removeItem(1452666425707);
		window.sessionStorage.clear();
	}
  </script>
 </body>
</html>
```

## localStorage

### 浏览器支持性检查

```javascript
//localStorage 
 if(window.localStorage){ 
    alert(“support localStorage”); 
 }else{ 
    alert(“not support localStorage”); 
    // 不支持 localStorage 
 }
```

### localStorage的方法

| 方法名称 | 描述 |
| ---- | --- |
| setItem(key, value) | 为 Web 存储对象添加一个键/值对，供以后使用。该值可以是任何的数据类型：字符串、数值、数组等。|
| getItem(key) | 基于起初用来存储它的这个键检索值。|
| clear() | 从此 Web 存储对象清除所有的键/值对。|
| removeItem(key) | 基于某个键从此 Web 存储对象清除特定的键/值对。|
| key(n) | 检索 key[n] 的值。|

#### a. 向 Web 存储对象添加键/值对

* 使用 `setItem()` 方法

```javascript
localStorage.setItem('myKey', 'myValue');
```

* 使用 Web 存储对象来直接设置此键的值

```javascript
localStorage.myKey = 'myValue';
```

#### b. 从 Web 存储对象中检索键/值对

* 使用 `getItem()` 方法

```javascript
localStorage.getItem('myKey');
```

* 使用 Web 存储对象来直接获取此键的值

```javascript
localStorage.myKey;
```

#### c. 删除所有键/值对

```javascript
localStorage.clear();
```

#### d. 删除单个键/值对

```javascript
localStorage.removeItem('myKey');
```

### localStorage的事件

如果想在存储成功或修改存储的值时执行一些操作，可以用 Web Storage 接口提供的事件。

```javascript
// 显示存储事件的相关内容
 function handleStorageEvent(e) { 
    document.write(“key” + e.key + “oldValue” + e.oldValue + “newValue” + e.newValue); 
 } 
 // 添加存储事件监听
 window.addEventListener(“storage”, handleStorageEvent, false);
```

| 事件参数 | 描述 |
| --- | --- |
| key | 发生改变的键 |
| oldValue | 键改变之前的值 |
| newValue | 键改变之后的值 |
| url | 触发存储事件的页面 url |