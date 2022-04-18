类数组对象就是结构上类似于数组的对象，该对象具备数组的一些特性属性或方法，同时具有自己独特的一些属性或方法。

## 数组与类数组对象的区别

- 数组的类型是 Array
- 类数组对象的类型是 Object

## 类数组的操作

- length属性：获取指定元素的个数。
- eq(index)：将下标等于index的DOM对象取出来。
- get(index)：返回一个DOM对象组成的数组。
- index（obj）：返回DOM或jQuery对象在类数组中的下标。

### 遍历方法

`$(selector).each(callback)` 方法

- callback：回调函数，function(index,domEle){}
	- index：遍历过程中的索引值
	- domEle：遍历后得到的DOM对象

```javascript
$("input").each(function(index,domEle){
   console.log(domEle.value);
});
```

`$.each(obj,callback)` 方法

- obj：需要遍历的对象或数组。
- callback：回调函数，function(index,domEle){}
	- index：遍历过程中的索引值
	- domEle：遍历后得到的DOM对象

```javascript
$.each($("input"),function(index,domEle){
    console.log(domEle.value);
    console.log($(domEle).val());
    console.log(this.value);
    console.log($(this).val());
});
```