## 显示和隐藏效果

通过同时改变元素的宽度和高度来实现显示或者隐藏。

### 无动画效果
	
- 显示: show()
- 隐藏: hide()

```javascript
$("#panel h5.head").click(function(){
    var $content = $(this).next("div.content");
    if($content.is(":visible")){
       $content.hide();
    }else{
       $content.show();
    }
})
```

### 有动画效果
	
#### 显示: show(speed,callback)
	
- speed: 预定义三种速度"slow"、"normal"和"fast"，或自定义时间，单位为毫秒。
- callback: 动画执行完毕后的回调函数。

#### 隐藏: hide(speed,callback)
	
- speed: 预定义三种速度"slow"、"normal"和"fast"，或自定义时间，单位为毫秒。
- callback: 动画执行完毕后的回调函数。

```javascript
$("#panel h5.head").click(function(){
    var $content = $(this).next("div.content");
    if($content.is(":visible")){
        $content.hide(600);
    }else{
        $content.show(600);
    }
})
```

## 滑动式动画效果

通过改变高度来实现显示或者隐藏的效果。

### 向上滑动: slideUp(speed,callback)
	
- speed: 预定义三种速度"slow"、"normal"和"fast"，或自定义时间，单位为毫秒。
- callback: 动画执行完毕后的回调函数。

### 向下滑动: slideDown(speed,callback)
	
- speed: 预定义三种速度"slow"、"normal"和"fast"，或自定义时间，单位为毫秒。
- callback: 动画执行完毕后的回调函数。

```javascript
$("#panel h5.head").click(function(){
    var $content = $(this).next("div.content");
    if($content.is(":visible")){
        $content.slideUp(600);
    }else{
        $content.slideDown(600);
    }
})
```

## 淡入淡出动画效果

通过改变不透明度 opacity 来实现显示或者隐藏。

### 淡入效果: fadeIn(speed,callback)
	
- speed: 预定义三种速度"slow"、"normal"和"fast"，或自定义时间，单位为毫秒。
- callback: 动画执行完毕后的回调函数。

### 淡出效果: fadeOut(speed,callback)
	
- speed: 预定义三种速度"slow"、"normal"和"fast"，或自定义时间，单位为毫秒。
- callback: 动画执行完毕后的回调函数。

```javascript
$("#panel h5.head").click(function(){
    var $content = $(this).next("div.content");
    if($content.is(":visible")){
        $content.fadeOut(600);
    }else{
        $content.fadeIn(600);
    }
})
```

## 动画切换效果

### toggle(duration,complete): 显示或隐藏匹配元素。

- duration: 一个字符串或者数字决定动画将运行多久。
- complete: 在动画完成时执行的回调函数。

```javascript
$('#clickme').click(function() {
	$('#book').toggle('slow', function() {
		// Animation complete.
	});
});
```

### slideToggle(duration,complete)：用滑动动画显示或隐藏一个匹配元素。

- duration：一个字符串或者数字决定动画将运行多久。
- complete：在动画完成时执行的回调函数。

```javascript
$('#clickme').click(function() {
	$('#book').slideToggle('slow', function() {
		// Animation complete.
	});
});
```

## 自定义动画效果

animate(properties,duration,easing,complete)

- properties：一个CSS属性和值的对象,动画将根据这组对象移动。
- duration：一个字符串或者数字决定动画将运行多久。
- easing：一个字符串，表示过渡使用哪种缓动函数。
- complete：在动画完成时执行的回调函数。

```javascript
$("#panel").click(function(){
   $(this).animate({left: "500px"}, 3000);
})
```

aniamte(properties,options)

- properties：一个CSS属性和值的对象,动画将根据这组对象移动。
- options：一组包含动画选项的值的集合。 支持的选项：
	- duration：一个字符串或者数字决定动画将运行多久。
	- easing：一个字符串，表示过渡使用哪种缓动函数。
	- queue：一个布尔值，指示是否将动画放置在效果队列中。如果为false时，将立即开始动画。
	- complete：在动画完成时执行的回调函数。

```javascript
$("#panel").click(function(){
    $(this).animate({left: "500px"}, 3000);
})
```

> **注意：**animate方法不接受以下属性:
> 
> - backgroundColor
> - borderBottomColor
> - borderLeftColor
> - borderRightColor
> - borderTopColor
> - Color
> - outlineColor

## 并发与排队效果

### 并发效果: 指的就是多个动画效果同时执行。

```javascript
$("#panel").click(function(){
   $(this).animate({left: "500px",height:"200px"}, 3000);
})
```

### 排队效果: 指的就是多个动画按照先后顺序执行。

```javascript
$("#panel").click(function(){
    $(this).animate({left: "500px"}, 3000).animate({height: "200px"}, 3000);
})
```