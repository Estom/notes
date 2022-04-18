## 视频处理

### 基础内容

#### a. 目前实现网页视频播放的技术 - Flash

- Flash并不是浏览器原生支持(第三方组件)
- Flash的性能并不好
- 移动端不支持Flash技术

#### b. HTML 5 提供的视频处理技术 - `<video>`

- 提供了相对应的基本处理方式
- 提供了高级编程自定义方式

#### c. `<video>`元素所支持的视频格式

| 视频格式 | 类型 | 描述 |
| --- | --- | --- |
| MP4格式 | `.mp4` | 目前最主流的视频格式。 |
| OGV格式 | `.ogv` | |
| WEBM格式 | `.webm` | 是由Google公司推出的，目前唯一一个支持超高清的视频格式。 |

### 如何使用`<video>`元素

#### a. 引入单个视频格式

`<video>` 标签的编写结构如下：

```html
<video src="视频文件的路径" autoplay>
	浏览器不支持的提示内容
</video>
```

例如以下示例代码：

```html
<video src="../DATA/oceans-clip.mp4" autoplay width="640px" height="400px" style="background:black;">
	非常抱歉,你的浏览器不支持该视频!
</video>
```

| 属性名称 | 类型 | 描述 |
| --- | --- | --- |
| width | Number | 设置视频的宽度。|
| height | Number | 设置视频的高度。|
| style | | 设置CSS样式属性。|
| class | | 设置CSS样式属性。 |
| autoplay | Boolean | 设置是否自动播放视频。|

#### b. 引入多个视频格式

`<video>` 标签和 `<source>` 标签的编写结构如下：

```html
<video autoplay>
	<source src="视频文件的路径" />
	<source src="视频文件的路径" />
	<source src="视频文件的路径" />
	浏览器不支持的提示内容
</video>
```

例如以下示例代码：

```html
<!-- 解决了浏览器对视频格式的兼容问题 -->
<video autoplay>
	<!--
		<source>元素
		* 引入视频文件(一个<video>元素允许包含多个<source>)
	-->
	<source src="../DATA/oceans-clip.mp4" />
	<source src="../DATA/oceans-clip.ogv" />
	<source src="../DATA/oceans-clip.webm" />
</video>
```

### `<video>`元素的属性

- autoplay属性：自动播放
- controls属性：提供控制面板

```html
<video src="../DATA/oceans-clip.mp4" controls></video>
```

- loop属性：循环播放

```html
<video src="../DATA/oceans-clip.mp4" autoplay loop></video>
```

- poster属性：播放之前实现一张图片

```html
<video src="../DATA/oceans-clip.mp4" controls poster="../DATA/oceans-clip.png"></video>
```

- preload属性：预加载视频
	- none：不预加载
	- auto：默认值,尽快预加载
	- metadata：预加载除视频之外的内容(宽度、高度等)

### 视频高级编程

#### a. 事件

| 事件名称 | 作用 |
| --- | --- |
| play | 视频播放时触发。|
| pause | 视频暂停时触发。|
| ended | 视频播放结束时触发。|
| error | 视频播放错误时触发。|


```html
<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>video元素的高级事件</title>
  <style>
	img {
		position: absolute;
		top : 66px;
		left : 160px;
		display : none;
	}
  </style>
 </head>
 <body>
  <video id="mmedia" src="../DATA/oceans-clip.mp4" controls></video>
  <img id="adv" src="../DATA/oceans-clip.png" width="320">
  <script>
	var mmedia = document.getElementById("mmedia");
	var adv = document.getElementById("adv");
	mmedia.addEventListener("pause",function(){
		adv.style.display = "block";
	});
	mmedia.addEventListener("play",function(){
		adv.style.display = "none";
	});
  </script>
 </body>
</html>
```

#### b. 方法

| 方法名称 | 作用 |
| --- | --- |
| `play()` | 用于播放视频。|
| `pause()` | 用于暂停视频。|
| `load()` | 用于加载视频。|
| `canPlayType()` | 判断当前浏览器是否支持当前视频格式。|

```html
<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>video元素的高级方法</title>
 </head>
 <body>
  <video id="mmedia" src="../DATA/oceans-clip.mp4"></video>
  <br>
  <input type="button" id="btn" value="播放">
  <script>
	var btn = document.getElementById("btn");
	var mmedia = document.getElementById("mmedia");
	btn.onclick = function(){
		if(mmedia.paused){// 播放
			mmedia.play();
			this.value = "暂停";
		}else{// 暂停
			mmedia.pause();
			this.value = "播放";
		}
	}
  </script>
 </body>
</html>
```

#### c. 属性

| 属性名称 | 作用 |
| --- | --- |
| paused | 如果视频为暂停或未播放时,返回true。|
| ended | 如果视频播放完毕时,返回true。|
| duration | 返回当前视频的时长。|
| currentTime | 获取或设置视频的当前位置。|

> **参考内容：**[https://developer.mozilla.org/en-US/docs/Web/HTML/Supported_media_formats](https://developer.mozilla.org/en-US/docs/Web/HTML/Supported_media_formats)

## 音频处理

### 基础内容

#### a. 目前音频处理技术

- Flash技术也可以音频处理
- Media Player播放器允许嵌入在网页中

#### b. HTML5 提供的音频处理 - `<audio>`

- 浏览器原生支持
- 性能很好
- 移动端支持

#### c. `<audio>`元素支持的音频格式

| 音频格式 | 类型 | 描述 |
| --- | --- | --- |
| MP3格式 | `.mp3` | 目前最主流的音频格式。 |
| OGG格式 | `.ogg` | |
| WAV格式 | `.wav` | |

### 如何使用`<audio>`元素

#### a. 引入单个音频格式

```html
<audio src="音频文件的路径" autoplay>
	浏览器不支持的提示内容
</audio>
```

#### b. 引入多个音频格式

```html
<audio autoplay>
	<source src="音频文件的路径" />
	<source src="音频文件的路径" />
	<source src="音频文件的路径" />
	浏览器不支持的提示内容
</audio>
```

### `<audio>`元素的特有属性

| 属性名称 | 作用 |
| --- | --- |
| autoplay | 设置是否自动播放。|
| controls | 提供控制面板。|
| loop | 设置循环播放。|
| preload | 预加载视频。|

### `<audio>`元素的高级编程

#### a. 事件

| 事件名称 | 作用 |
| --- | --- |
| play | 视频播放时触发。|
| pause | 视频暂停时触发。|
| ended | 视频播放结束时触发。|
| error | 视频播放错误时触发。|

#### b. 方法

| 方法名称 | 作用 |
| --- | --- |
| `play()` | 用于播放视频。|
| `pause()` | 用于暂停视频。|
| `load()` | 用于加载视频。|
| `canPlayType()` | 判断当前浏览器是否支持当前视频格式。|

#### c. 属性

| 属性名称 | 作用 |
| --- | --- |
| paused | 如果视频为暂停或未播放时,返回true。|
| ended | 如果视频播放完毕时,返回true。|
| duration | 返回当前视频的时长。|
| currentTime | 获取或设置视频的当前位置。