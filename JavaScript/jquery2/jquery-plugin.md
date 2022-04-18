## 日期插件

layDate 日期插件致力于成为全球最用心的 web 日期支撑，为国内外所有从事 web 应用开发的同仁提供力所能及的动力。

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>01_laydate插件的基本使用</title>
    <script src="laydate/laydate.js"></script>
</head>
<body>
    <input placeholder="请输入日期" class="laydate-icon" onclick="laydate()">
    <br>
    <input placeholder="请输入日期" id="hello1">
    <span class="laydate-icon" onclick="laydate({elem: '#hello1'});"></span>
</body>
</html>
```

### layDate API选项:

- elem: '#id', //需显示日期的元素选择器
- event: 'click', //触发事件
- format: 'YYYY-MM-DD hh:mm:ss', //日期格式
- istime: false, //是否开启时间选择
- isclear: true, //是否显示清空
- istoday: true, //是否显示今天
- issure: true, 是否显示确认
- festival: true //是否显示节日
- min: `1900-01-01 00:00:00`, //最小日期
- max: `2099-12-31 23:59:59`, //最大日期
- start: `2014-6-15 23:00:00`,    //开始日期
- fixed: false, //是否固定在可视区域
- zIndex: 99999999, //css z-index
- choose: function(dates){} //选择好日期的回调

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>02_laydate插件的高级使用</title>
    <script src="jquery-1.11.3.js"></script>
    <script src="laydate/laydate.js"></script>
</head>
<body>
    <input id="mydate" placeholder="请输入日期" class="laydate-icon">
    <script>
        laydate({
            elem : "#mydate",
            event : "focus",
            istime : true,
            isclear : false,
            istoday : false,
            issure : false
        });
    </script>
</body>
</html>
```

## 表单验证插件

表单验证插件主要是针对表单元素的值进行验证，并给出响应的图形以及文字提示。

**常用验证插件**

- formValidator
- jQuery.validator
- easyForm
- validate.js

### jQuery.validator 插件

该插件提供用户方便地实现表单验证，同时还提供大量的定制选项。
官方地址：[http://jqueryvalidation.org/](http://jqueryvalidation.org/)

**validation基本使用**

```html
<div id="main">
    <p>Take a look at the source to see how messages can be customized with metadata.</p>
    <!-- Custom rules and messages via data- attributes -->
    <form class="cmxform" id="commentForm" method="post" action="">
        <fieldset>
            <legend>Please enter your email address</legend>
            <p>
                <label for="cemail">E-Mail *</label>
                <input id="cemail" name="email" data-rule-required="true" data-rule-email="true" data-msg-required="Please enter your email address" data-msg-email="Please enter a valid email address">
            </p>
            <p>
                <input class="submit" type="submit" value="Submit">
            </p>
        </fieldset>
    </form>
</div>
<script>
    $(document).ready(function() {
        $("#commentForm").validate();
    });
</script>
```

**validate()验证方法的选项**

| 选项名称 | 描述说明 |
| -------- | ---------- |
| debug | 设置是否为调试模式，如果为调试模式表单不会被提交。 |
| submitHandler | 表单提交时的回调函数，一般用于提交当前表单。|
| rules | 设置表单元素的验证规则，格式为key:value。 |
| messages | 设置表单元素验证不通过时的错误提示信息。 |
| errorClass | 自定义错误提示信息的样式。 |
| ignore | 设置哪些表单元素不进行验证。|

**validation自定义验证**

```html
<div id="main">
    <form class="cmxform" id="commentForm" method="post" action="">
        <fieldset>
            <legend>Please enter your email address</legend>
            <p>
                <label for="cemail">E-Mail *</label>
                <input id="cemail" name="email" data-rule-required="true" data-rule-email="true" data-msg-email="Please enter a valid email address">
            </p>
            <p>
                <input class="submit" type="submit" value="Submit">
            </p>
        </fieldset>
    </form>
</div>
<script>
    $(document).ready(function() {
        $("#commentForm").validate({
            messages: {
                email: {
                    required: 'Enter this!'
                }
            }
        });
    });
</script>
```

**自定义验证方法**

jQuery.validator.addMethod( name, method [, message ] )方法

- name：设置验证方法的名称。
- method：回调函数，function(value,element,param){}
	- value：元素的值
	- element：元素本身
	- param：参数
- message：设置验证不通过的错误提示信息。

```html
<div id="main">
    <form class="cmxform" id="texttests" method="get" action="foo.html">
        <h2 id="summary"></h2>
        <fieldset>
            <legend>Example with custom methods and heavily customized error display</legend>
            <table>
                <tr>
                    <td>
                        <label for="number">textarea</label>
                    </td>
                    <td>
                        <input id="number" name="number" title="Please enter a number with at least 3 and max 15 characters!">
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <label for="secret">Secret</label>
                    </td>
                    <td>
                        <input name="secret" id="secret">
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <label for="math">7 + 4 =</label>
                    </td>
                    <td>
                        <input id="math" name="math" title="Please enter the correct result!">
                    </td>
                    <td></td>
                </tr>
            </table>
            <input class="submit" type="submit" value="Submit">
        </fieldset>
    </form>
    <h3 id="warning">Your form contains tons of errors! Please try again.</h3>
</div>
<script>
    // this one requires the text "buga", we define a default message, too
    $.validator.addMethod("buga", function(value) {
        return value == "buga";
    }, 'Please enter "buga"!');

    // this one requires the value to be the same as the first parameter
    $.validator.methods.equal = function(value, element, param) {
        return value == param;
    };

    $().ready(function() {
        var validator = $("#texttests").bind("invalid-form.validate", function() {
            $("#summary").html("Your form contains " + validator.numberOfInvalids() + " errors, see details below.");
        }).validate({
            debug: true,
            errorElement: "em",
            errorContainer: $("#warning, #summary"),
            errorPlacement: function(error, element) {
                error.appendTo(element.parent("td").next("td"));
            },
            success: function(label) {
                label.text("ok!").addClass("success");
            },
            rules: {
                number: {
                    required: true,
                    minlength: 3,
                    maxlength: 15,
                    number: true
                },
                secret: "buga",
                math: {
                    equal: 11
                }
            }
        });

    });
</script>
```

## 瀑布流插件

### 什么是瀑布流

瀑布流，又称瀑布流式布局。是比较流行的一种网站页面布局，视觉表现为参差不齐的多栏布局，随着页面滚动条向下滚动，这种布局还会不断加载数据块并附加至当前尾部。

**特点**

- 琳琅满目: 整版以图片为主，大小不一的图片按照一定的规律排列。
- 唯美: 图片的风格以唯美的图片为主。
- 操作简单: 在浏览网站的时候，只需要轻轻滑动一下鼠标滚轮,一切的美妙的图片精彩便可呈现在你面前。

### Masonry 插件

Masonry 是 jQuery 的布局插件，可以把 Masonry 看做是 CSS 的浮动布局。

无论排列的元素是水平浮动的还是垂直浮动的，Masonry 都是根据网格先垂直排列元素，再水平排列元素，就像修墙一样。

配置 Masonry 相当简单，只需在 jQuery 脚本简单的使用 `.masonry()` 方法来包装容器元素。由于布局，很可能需要制定一个选项。

#### masonry() 方法推荐选项

- itemSelector：指定使用项目中哪些子元素进行布局
- columnWidth：设置每列的宽度

```html
<div id="basic" class="container">
    <div class="item"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h5"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h4"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item"></div>
    <div class="item h5"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h4"></div>
    <div class="item h4"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h4"></div>
    <div class="item h4"></div>
    <div class="item h5"></div>
</div>
<script>
    $("#basic").masonry({
        itemSelector: '.item',
        columnWidth: 100
    });
</script>
```

#### masonry() 方法布局选项

- gutter：设置每列之间的宽度
- percentPosition：值为true，使用百分值，而不是像素值
- stamp：在布局中标记元素，Masonry将在这些标记的元素下进行布局
- isFitWidth：基于容器的父元素大小设置容器的宽度以适应可用的列数
- isOriginLeft：设置布局的水平对齐，默认为true时，从左到右
- isOriginTop：设置布局的垂直对齐，默认为true时，从上到下

**百分值效果**

```html
<div id="basic" class="container">
    <div class="item item-sizer"></div>
    <div class="item item-sizer h2"></div>
    <div class="item item-sizer"></div>
    <div class="item item-sizer h3"></div>
    <div class="item item-sizer h5"></div>
    <div class="item item-sizer h2"></div>
    <div class="item item-sizer"></div>
    <div class="item item-sizer h4"></div>
    <div class="item item-sizer"></div>
    <div class="item item-sizer h3"></div>
    <div class="item item-sizer"></div>
    <div class="item item-sizer h5"></div>
    <div class="item item-sizer"></div>
    <div class="item item-sizer h3"></div>
    <div class="item item-sizer h4"></div>
    <div class="item item-sizer h4"></div>
    <div class="item item-sizer"></div>
    <div class="item item-sizer h3"></div>
    <div class="item item-sizer h4"></div>
    <div class="item item-sizer h4"></div>
    <div class="item item-sizer h5"></div>
</div>
<script>
    $("#basic").masonry({
        columnWidth: ".item-sizer",
        percentPosition : true
    });
</script>
```

**固定元素**

```html
<div id="basic" class="container">
    <div class="stamp stamp1"></div>
    <div class="stamp stamp2"></div>
    <div class="item"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h5"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h4"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item"></div>
    <div class="item h5"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h4"></div>
    <div class="item h4"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h4"></div>
    <div class="item h4"></div>
    <div class="item h5"></div>
</div>
<script>
    $("#basic").masonry({
        itemSelector: '.item',
        columnWidth: 100,
        stamp: '.stamp'
    });
</script>
```

**自适应宽度**

```html
<div id="basic" class="container">
    <div class="item"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h5"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h4"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item"></div>
    <div class="item h5"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h4"></div>
    <div class="item h4"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h4"></div>
    <div class="item h4"></div>
    <div class="item h5"></div>
</div>
<script>
    $("#basic").masonry({
        itemSelector: '.item',
        columnWidth: 100,
        isFitWidth: true
    });
</script>
```

#### masonry() 方法设置选项

- containerStyle：对容器中的元素使用CSS样式
- transitionDuration：设置改变位置或外观的过度时间，默认为0.4s
- isResizeBound：是否根据窗口大小调整大小和位置
- isInitLayout：是否初始化布局，为false时，可以在初始化布局前，使用方法或绑定事件

#### Masonry 插件的方法

**布局**

- masonry( )：布局容器中所有的元素。当每个元素改变大小时，布局依旧有效并且每个元素要重新进行布局
- layoutItems( )：布局指定元素

**添加或删除元素**

- appended( )：在布局的最后添加并布局新的元素
- remove( )：从Masonry对象中或DOM中删除指定元素

**事件**

- on事件：添加一个Masonry事件的监听器
- off事件：删除一个Masonry事件的监听器

```html
<div id="basic" class="container">
    <div class="item"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h5"></div>
    <div class="item"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item h5"></div>
    <div class="item h2"></div>
    <div class="item"></div>
    <div class="item h4"></div>
    <div class="item"></div>
    <div class="item h3"></div>
    <div class="item"></div>
    <div class="item h5"></div>
</div>
<script>
    var $grid = $("#basic").masonry({
        itemSelector: '.item',
        columnWidth: 100,
        isFitWidth: true
    });

    $grid.on( 'click', '.item', function() {
        // change size of item via class
        $( this ).toggleClass('grid-item--gigante');
        // trigger layout
        $grid.masonry();
    });

    $grid.on("layoutComplete",function( event, laidOutItems ) {
        console.log( 'Masonry layout complete with ' + laidOutItems.length + ' items' );
    });
</script>
```

## 开发插件

### jQuery 插件种类

- 对象方法插件: 这种插件是将对象方法封装起来，用于对通过选择器获取的jQuery对象进行操作，是最常见的一种插件。
- 全局函数插件: 可以将独立的函数添加到jQuery命名空间下，例如 `$.each( )`方法等。
- 选择器插件: 个别情况下，会需要用到选择器插件。虽然jQuery的选择器已经很强大，但还是会需要扩展一些个性化的选择器用法。

### 对象方法插件

- 第一种定义方式

```javascript
jQuery.fn.changeBgColor = function(color){
	this.css("background",color);
}
```

- 第二种定义方式

```javascript
jQuery.fn.swapClass=function(class1,class2){
	return this.each(function(){ //this 表示的是 匹配到的一组 <li>
		var $element = jQuery(this); //this表示的是每个<li>
		if($element.hasClass(class1)){
			$element.removeClass(class1).addClass(class2);
		} else if ($element.hasClass(class2)){
			$element.removeClass(class2).addClass(class1);
		}
	});
}
```

- 第三种定义方式

```javascript
jQuery.fn.extend({
	changeBgColor = function(color){
		this.css("background",color);
	}
});
```

### 全局函数插件

- 第一种定义方式

```javascript
jQuery.globalFunction = function(){
	alert("This is my plugins ");
}
```

- 第二种定义方式

```javascript
jQuery.extend({
	functionOne : function(){
		alert("This is one function");
	},
	functionTwo : function(param){
		alert("This is two function , param is "+param);
	}
});
```

- 第三种定义方式

```javascript
jQuery.sum = function(array){
	var total = 0;
	jQuery.each(array,function(index,value){
		total += value;
	});
	return total;
}
```

### jQuery插件案例

```javascript
jQuery.fn.shadow = function(){
	return this.each(function(){
		var $originalElement = jQuery(this);
		for(var i=0; i < 5 ; i ++){
			$originalElement.clone().css({
				position:'absolute',
				left:$originalElement.offset().left + i,
				top:$originalElement.offset().top + i,
				margin:0,
				zIndex:-1,
				opacity:0.1
			}).appendTo('body');
		}
	});
}
```