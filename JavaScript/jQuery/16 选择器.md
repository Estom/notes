## 什么是 jQuery 的选择器

jQuery 的选择器的想法是源于 CSS 中的选择器的用法，其实在 JavaScript 中也有类似的用法，比如 querySelector() 或 querySelectorAll() 方法的使用，也是借助 CSS 中的选择器来定位 HTML 页面元素的。只不过相比 jQuery 中的选择器，JavaScript 中的 querySelector() 或 querySelectorAll() 方法的性能相对差一些而已。

jQuery 的选择器最主要的作用就是用于定位 HTML 页面的元素。它不仅可以定位 HTML 页面中具体某个元素，还可以通过各种方式定位复合条件的一组元素等等。

> **值得注意的是:** jQuery 的选择器最大的特点就是将定位元素和元素行为进行了有效的分离。这是在实际开发中非常必要的一项特点！

## jQuery 选择器的种类

jQuery 中使用其工厂函数 `$()` 作为容器，来接收 jQuery 的选择器内容。而 jQuery 的选择器则以字符串形式传递给 jQuery 的工厂函数。

jQuery 的选择器种类大概可以分为以下几种:

### 基本选择器

```javascript
//选择 id为 one 的元素
$('#btn1').click(function(){
    $('#one').css("background","#bfa");
});
//选择 class 为 mini 的所有元素
$('#btn2').click(function(){
    $('.mini').css("background","#bfa");
});
//选择 元素名是 div 的所有元素
$('#btn3').click(function(){
    $('div').css("background","#bfa");
});
//选择 所有的元素
$('#btn4').click(function(){
    $('*').css("background","#bfa");
});
//选择 所有的span元素和id为two的div元素
$('#btn5').click(function(){
    $('span,#two').css("background","#bfa");
});
```

> **需要注意**
> 
> 1. 通配符选择器（*）默认匹配HTML页面中所有的元素。
> 2. 复合选择器（多个选择器并列使用）的使用，每个选择器之间使用”,”进行分割。并且复合选择器匹配的结果是多个选择器的并集效果。


### 层级选择器

```javascript
//选择 body内的所有div元素.
$('#btn1').click(function(){
    $('body div').css("background","#bbffaa");
})
//在body内的选择 元素名是div 的子元素.
$('#btn2').click(function(){
    $('body > div').css("background","#bbffaa");
})
//选择 所有class为one 的下一个div元素.
$('#btn3').click(function(){
    $('.one + div').css("background","#bbffaa");
})
//选择 id为two的元素后面的所有div兄弟元素.
$('#btn4').click(function(){
    $('#two ~ div').css("background","#bbffaa");
})
```

> **值得注意的是:**
> 
> selectors~selector2 选择器，是获取符合 selector1 选择器的元素后面所有符合selector2 选择器的兄弟元素。
> 
> jQuery 中还有一个方法 siblings()，是获取指定元素的所有兄弟元素。

### 基本过滤选择器

```javascript
//选择第一个div元素.
$('#btn1').click(function(){
    $('div:first').css("background","#bfa");
})
//选择最后一个div元素.
$('#btn2').click(function(){
    $('div:last').css("background","#bfa");
})
//选择class不为one的 所有div元素.
$('#btn3').click(function(){
    $('div:not(.one)').css("background","#bfa");
})
//选择 索引值为偶数 的div元素。
$('#btn4').click(function(){
    $('div:even').css("background","#bfa");
})
//选择 索引值为奇数 的div元素。
$('#btn5').click(function(){
    $('div:odd').css("background","#bfa");
})
//选择 索引等于 3 的元素
$('#btn6').click(function(){
    $('div:eq(3)').css("background","#bfa");
})
//选择 索引大于 3 的元素
$('#btn7').click(function(){
    $('div:gt(3)').css("background","#bfa");
})
//选择 索引小于 3 的元素
$('#btn8').click(function(){
    $('div:lt(3)').css("background","#bfa");
})
//选择 所有的标题元素.比如h1, h2, h3等等...
$('#btn9').click(function(){
    $(':header').css("background","#bfa");
})
//选择 当前正在执行动画的所有元素.
$('#btn10').click(function(){
    $(':animated').css("background","#bfa");
});
```

> **值得注意的是:**
> 
> 1. “:not(selector)” 选择器，不仅可以匹配到 class 属性值不是 one 的元素，还匹配到没有 class 属性的元素。这不仅仅只是一个反操作的过程。
> 2. “:even” 和 ”:odd” 选择器，表示索引值为偶数或者索引值为奇数的元素，但是需要注意的是索引值是从 0 开始的。
> 3. :header” 选择器，是匹配 h1 - h6 标题元素，并不能匹配指定的某个标题元素。如果需要匹配具体某个标题元素可以使用元素选择器，所以这种用法在实际开发中很少见到。
> 4. “:animated” 选择器，是匹配正在执行动画效果的元素，但需要注意的是它只能匹配 jQuery 执行的动画效果，而不能匹配其他技术实现的动画效果。


### 内容过滤选择器

```javascript
//选取含有文本"di"的div元素.
$('#btn1').click(function(){
    $('div:contains(di)').css("background","#bbffaa");
})
//选取不包含子元素(或者文本元素)的div空元素.
$('#btn2').click(function(){
    $('div:empty').css("background","#bbffaa");
})
//选取含有class为mini元素 的div元素.
$('#btn3').click(function(){
    $('div:has(.mini)').css("background","#bbffaa");
})
//选取含有子元素(或者文本元素)的div元素.
$('#btn4').click(function(){
    $('div:parent').css("background","#bbffaa");
})
```

> **值得注意的是:** “:has(selector)” 选择器，匹配含有符合 selector 选择器元素的元素，并不是匹配符合 selector 的元素。

### 可见性过滤选择器

```javascript
//选取所有不可见的元素.包括<input type="hidden"/>.
$('#btn_hidden').click(function(){
    $('div:hidden').show(3000).css("background","#bbffaa");
})
//选取所有可见的元素.
$('#btn_visible').click(function(){
    $('div:visible').css("background","#FF6500");
})
```

> **值得注意的是:** show() 方法表示将隐藏的元素显示，其参数表示动画执行的时长。（后面的内容会详细讲到）。

### 属性过滤选择器

```javascript
//选取含有 属性title 的div元素.
$('#btn1').click(function(){
    $('div[title]').css("background","#bbffaa");
})
//选取 属性title值等于 test 的div元素.
$('#btn2').click(function(){
    $('div[title=test]').css("background","#bbffaa");
})
//选取 属性title值不等于 test 的div元素.
$('#btn3').click(function(){
    $('div[title!=test]').css("background","#bbffaa");
})
//选取 属性title值 以 te 开始 的div元素.
$('#btn4').click(function(){
    $('div[title^=te]').css("background","#bbffaa");
})
//选取 属性title值 以 est 结束 的div元素.
$('#btn5').click(function(){
    $("div[title$=est]").css("background","#bbffaa");
})
//选取 属性title值 含有 es  的div元素.
$('#btn6').click(function(){
    $("div[title*=es]").css("background","#bbffaa");
})
//组合属性选择器,首先选取有属性id的div元素，然后在结果中 选取属性title值 含有 es 的元素.
$('#btn7').click(function(){
    $("div[id][title*=es]").css("background","#bbffaa");
})
```

> **值得注意的是:**
> 
> 1. “[attrName!=value]” 选择器，匹配 attrName 属性的值不等于 value 的元素，但也包含没有 attrName 属性的所有元素。
> 2. “[attribute][attribute]” 属性复合选择器，是多个属性过滤选择器并列使用，匹配的结果是多个属性过滤选择器的交集。

### 子元素过滤选择器

```javascript
//选取每个父元素下的第2个子元素
$('#btn1').click(function(){
    $('div.one :nth-child(2)').css("background","#bbffaa");
})
//选取每个父元素下的第一个子元素
$('#btn2').click(function(){
    $('div.one :first-child').css("background","#bbffaa");
})
//选取每个父元素下的最后一个子元素
$('#btn3').click(function(){
    $('div.one :last-child').css("background","#bbffaa");
})
//如果父元素下的仅仅只有一个子元素，那么选中这个子元素
$('#btn4').click(function(){
    $('div.one :only-child').css("background","#bbffaa");
})
```

> **值得注意的是:**
> 
> 1. 子元素过滤选择器的特殊用法，就是在其前面需要增加空格。不然子元素过滤选择器将不会有效果！
> 2. “nth-child(index)” 选择器中的 index 是从 0 开始的。

### 表单对象属性过滤选择器

```javascript
//对表单内 可用input 赋值操作.
$('#btn1').click(function(){
    $("#form1 input:enabled").val("这里变化了！");
    return false;
})
//对表单内 不可用input 赋值操作.
$('#btn2').click(function(){
    $("#form1 input:disabled").val("这里变化了！");
    return false;
})
$(":checkbox").click(countChecked);
function countChecked() {
    var n = $("input:checked").length;
    $("div").eq(0).html("<strong>有"+n+" 个被选中!</strong>");
}
countChecked();//进入页面就调用.
$("select").change(function () {
    var str = "";
    $("select :selected").each(function () {
         str += $(this).text() + ",";
    });
    $("div").eq(1).html("<strong>你选中的是："+str+"</strong>");
})
```

> **值得注意的是:**
> 
> 1. “:checked” 选择器，匹配 checkbox 和 radio 元素中被选中的。
> 2. “:selected” 选择器，匹配 select 元素中 option 元素被选中的。

### 表单选择器

```javascript
var $alltext = $("#form1 :text");
var $allpassword= $("#form1 :password");
var $allradio= $("#form1 :radio");
var $allcheckbox= $("#form1 :checkbox");

var $allsubmit= $("#form1 :submit");
var $allimage= $("#form1 :image");
var $allreset= $("#form1 :reset");
var $allbutton= $("#form1 :button"); // <input type=button />  和 <button ></button>都可以匹配
var $allfile= $("#form1 :file");
var $allhidden= $("#form1 :hidden"); // <input type="hidden" />和<div style="display:none">test</div>都可以匹配.
var $allselect = $("#form1 select");
var $alltextarea = $("#form1 textarea");

var $AllInputs = $("#form1 :input");
var $inputs = $("#form1 input");

$("div").append(" 有" + $alltext.length + " 个（ :text 元素）<br/>")
        .append(" 有" + $allpassword.length + " 个（ :password 元素）<br/>")
        .append(" 有" + $allradio.length + " 个（ :radio 元素）<br/>")
        .append(" 有" + $allcheckbox.length + " 个（ :checkbox 元素）<br/>")
        .append(" 有" + $allsubmit.length + " 个（ :submit 元素）<br/>")
        .append(" 有" + $allimage.length + " 个（ :image 元素）<br/>")
        .append(" 有" + $allreset.length + " 个（ :reset 元素）<br/>")
        .append(" 有" + $allbutton.length + " 个（ :button 元素）<br/>")
        .append(" 有" + $allfile.length + " 个（ :file 元素）<br/>")
        .append(" 有" + $allhidden.length + " 个（ :hidden 元素）<br/>")
        .append(" 有" + $allselect.length + " 个（ select 元素）<br/>")
        .append(" 有" + $alltextarea.length + " 个（ textarea 元素）<br/>")
        .append(" 表单有 " + $inputs.length + " 个（input）元素。<br/>")
        .append(" 总共有 " + $AllInputs.length + " 个(:input)元素。<br/>")
        .css("color", "red")

$("form").submit(function () { return false; }); // return false;不能提交.
```