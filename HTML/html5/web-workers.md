## 基础内容

### 什么是 Web Workers

> 能够把 JavaScript 计算委托给后台线程，通过允许这些活动以防止使交互型事件变得缓慢。

上句话是 MDN 对象 Web Workers 的简单描述。

Web Workers 是可以在后台（页面端）运行的任务，它能够被轻松的创建，还能向它的创建者发送消息。 

Web Workers 的三大主要特征：能够长时间运行（响应），理想的启动性能以及理想的内存消耗。

### 两种 Web Workers

Web Workers 可以分为两种类型：Dedicated Web Worker（专用线程）和 Shared Web Worker（共享线程）。

#### a. Dedicated Web Worker

目前绝大多数的应用场景所使用的是 Dedicated Web Worker（专用线程）。Dedicated Web Worker随着 HTML 页面关闭而被终止，这就意味着 Dedicated Web Worker 只能被创建它的 HTML 页面所访问。

在 JavaScript 代码中，`Work` 类型代表 Dedicated Web Worker。

#### b. Shared Web Worker

与 Dedicated Web Worker（专用线程）相比，Shared Web Worker 一般用于一些特定情况，可以为多个 HTML 页面服务，即可以被多个 HTML 页面所访问。与之对应的，只有将与之相关的所有 HTML 页面都关闭才能被终止。

在 JavaScript 代码中，`SharedWorker` 类型代表 Shared Web Worker。

### Web Workers 的限制

Web Workers 在具体使用中，具有以下几种限制：

* Web Workers 无法访问 DOM 节点；
* Web Workers 无法访问全局变量或是全局函数；
* Web Workers 无法调用 `alert()` 或者 `confirm()` 之类的函数；
* Web Workers 无法访问 window、document 之类的浏览器全局变量；

Web Workers 可以在它的作用域内访问 navigator 对象。它含有如下能够识别浏览器的字符串，就像在普通脚本中做的那样：

* appName
* appVersion
* platform
* userAgent

### Web Workers 的使用场景

* Web Workers 线程能够在不干扰 UI 的情况下执行一些计算的任务。
* Web Workers 线程能够使用 XMLHttpRequest 对象与服务器端进行异步交互。

### 参考资料

* [Web Workers - W3C](http://www.w3.org/TR/workers/)
* [使用 Web Workers](https://developer.mozilla.org/zh-CN/docs/Web/API/Web_Workers_API/Using_web_workers)
* [Microsoft Web Workers](https://msdn.microsoft.com/library/hh673568(v=vs.85).aspx)

## Worker API

### Worker 构造函数

```javascript
Worker(DOMString scriptURL)
```

通过该构造函数可以直接创建 Worker 对象，并传递 Worker 文件的路径（scriptURL）。具体用法如下：

```javascript
var worker = new Worker(my_task.js);
```

通过 Worker 的构造函数得到 Worker 对象，在 HTML 页面与 Worker 文件之间创建通信。

> **值得注意的是：**指定的 Worker 文件路径必须遵循`同源策略`。

### 监听通信消息机制

```javascript
worker.onmessage = function(event){
	逻辑编写在这里...
}
```

当 Worker 传递消息给 HTML 页面（或 HTML 页面传递消息给 Worker）时，可以通过 onmessage 事件进行监听并且捕获。

传递的消息存储在 onmessage 事件处理函数的参数 `data` 中。

```javascript
worker.onmessage = function(event) {
  console.log("Worker's message: " + event.data);
};
```

### 发送通信消息方法

```javascript
postMessage(JSObject message)
```

HTML 页面通过该方法向 Worker 的内部作用域内传递消息。该方法接收一个单独的参数，即要传递给 Worker 的数据。

`message` 参数用于传递给 Worker 的数据，该数据将包含于传递给 onmessage 处理函数的事件对象中的 data 字段内。

```javascript
// 普通数据
worker.postMessage("ali");
// JSON格式的数据
worker.postMessage({"cmd": "init", "timestamp": Date.now()});
```

### 终止 Worker 通信

```javascript
terminate()
```

该方法用于立即终止 Worker。该方法不会给 Worker 留下任何完成操作的机会；就是简单的立即停止。

### 监听通信错误机制

```javascript
worker.onerror = function(event){
	错误处理编写在这里...
}
```

错误信息对象包含三个属性：

* message：一个可读性良好的错误信息。
* filename：产生错误的脚本文件名。
* lineno：发生错误时所在的脚本文件行号。

## 双向通信

所谓“单向通信”就是指 HTML 页面与 Worker 建立通信后，只是 Worker 向 HTML 页面传递消息。

所谓“双向通信”就是指 HTML 页面与 Worker 之间可以相互传递消息的一种方式。

要建立双向通信，HTML 页面和 Worker 线程都要侦听 onmessage 事件。

* 首先，该脚本创建 worker 线程。

```javascript
var echo = new Worker('echo.js'); 
echo.onmessage = function(e) {
  alert(e.data); 
}
```

* 当用户单击提交按钮时，脚本会将两条信息以 JavaScript 对象文本的形式传递给 Worker。

```html
<script>
window.onload = function() {
  var echoForm = document.getElementById('echoForm'); 
  echoForm.addEventListener('submit', function(e) {
    echo.postMessage({
      message : e.target.message.value,
      timeout : e.target.timeout.value
    }); 
    e.preventDefault();
  }, false); 
  }
</script>
<form id="echoForm">
  <p>Echo the following message after a delay.</p>
  <input type="text" name="message" value="Input message here."/><br/>
  <input type="number" name="timeout" max="10" value="2"/> seconds.<br/>
  <button type="submit">Send Message</button>
</form>
```

* 最后，Worker 侦听消息，并在指定的超时间隔之后将其返回。

```javascript
onmessage = function(e){
  setTimeout(function(){
    postMessage(e.data.message);
  }, 
  e.data.timeout * 1000);
}
```