## 概览

Bootstrap 提供相应插件在 HTML 页面中实现动态交互效果。

### 1）前提条件

由于 Bootstrap 提供的插件都是依赖于 jQuery 的，所以必须要先引入 jQuery 文件。

Bootstrap 的每个插件都对应具有一个 JavaScript 文件，允许单独引入到 HTML 页面。也提供了一个完整版本（Bootstrap.js 或 Bootstrap.min.js 文件），允许一次性将所有插件全部引入到 HTML 页面中。

```html
<script src="bootstrap/js/jquery-1.11.3.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
```

### 2）两种使用方式

#### a. data 属性

通过 data 属性 API 就能使用所有的 Bootstrap 插件，无需写一行 JavaScript 代码。

```html
<div class="container">
    <div class="dropdown">
        <a data-toggle="dropdown" class="btn btn-default" href="#">产品大全</a>
        <ul class="dropdown-menu">
            <li><a href="#">冰箱</a></li>
            <li><a href="#">洗衣机</a></li>
            <li><a href="#">电视</a></li>
        </ul>
    </div>
</div>
```

如果在某些情况下可能需要将此功能关闭，提供了关闭 data 属性 API 的方法（**即解除以 data-api 为命名空间并绑定在文档上的事件**）。

```javascript
$(document).off('.data-api')
```

#### b. JavaScript API

所有 Bootstrap 插件提供了纯 JavaScript 方式的 API。所有公开的 API 都是支持单独或链式调用方式，并且返回其所操作的元素集合(**和jQuery的调用形式一致**)。

```html
<div class="container">
    <div class="dropdown">
        <button id="btn2" class="btn btn-default">产品大全</button>
        <ul class="dropdown-menu">
            <li><a href="">冰箱</a></li>
            <li><a href="">洗衣机</a></li>
            <li><a href="">电视</a></li>
        </ul>
    </div>
</div>

<script src="bootstrap/js/jquery-1.11.3.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script>
    //var num = 1;
    $('#btn2').dropdown();
</script>
```

## 下拉菜单

### 1）通过 `data-*` 属性方式实现

```html
<div class="container">
    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            Dropdown
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li><a href="#">Separated link</a></li>
        </ul>
    </div>
</div>
```

### 2）通过 JavaScript 编程方式实现

```html
<div class="container">
    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle">
            Dropdown
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li><a href="#">Separated link</a></li>
        </ul>
    </div>
</div>

<script src="bootstrap/js/jquery-1.11.3.jsy"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script>
    $('button[class*=btn]').dropdown();
</script>
```

## 警告框

### 1）通过 `data-*` 属性方式实现

```html
<div class="container">
    <div class="alert alert-danger alert-dismissible">
        <span data-dismiss="alert" class="close">&times;</span>
        <h4><span class="glyphicon glyphicon-alert"></span>警告！</h4>
        <p>您的浏览器版本太老了！请更新到最新版本的浏览器！</p>
    </div>
</div>
```

### 2）通过 JavaScript 编程方式实现

```html
<div class="container">
    <div class="alert alert-danger alert-dismissible">
        <span id="btn_close" class="close">&times;</span>
        <h4><span class="glyphicon glyphicon-alert"></span>警告！</h4>
        <p>您的浏览器版本太老了！请更新到最新版本的浏览器！</p>
    </div>
</div>

<script src="bootstrap/js/jquery-1.11.3.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script>
    //$('#btn_close').alert();  //如此书写，将直接消失
    $('#btn_close').click(function(){
        $(this).alert('close');
    });
</script>
```

## 标签页

### 1）通过 `data-*` 属性方式实现

```html
<div class="container">
    <ul class="nav nav-tabs">
        <li data-toggle="tab" class="active"><a href="#">Home</a></li>
        <li data-toggle="tab"><a href="#">Profile</a></li>
        <li data-toggle="tab"><a href="#">Messages</a></li>
    </ul>
</div>
```

### 2）通过 JavaScript 编程方式实现

```html
<div class="container">
    <ul class="nav nav-tabs" id="mytab">
        <li class="active"><a href="#">Home</a></li>
        <li><a href="#">Profile</a></li>
        <li><a href="#">Messages</a></li>
    </ul>
</div>

<script src="bootstrap/js/jquery-1.11.3.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script>
    $('#mytab a').click(function(event){
        event.preventDefault();
        $(this).tab('show');
    })
</script>
```

## 折叠框

### 1）通过 `data-*` 属性方式实现

```html
<div class="container">
    <a class="btn btn-primary" role="button" data-toggle="collapse" href="#collapseExample">
        Link with href
    </a>
    <button class="btn btn-primary" data-toggle="collapse" data-target="#collapseExample">
        Button with data-target
    </button>
    <div class="collapse" id="collapseExample">
        <div class="well">
            ...
        </div>
    </div>
</div>
```

### 2）通过 JavaScript 编程方式实现

```html
<div class="container">
    <a id="href" class="btn btn-primary" href="#collapse2">
        Link with href
    </a>
    <button id="btn" class="btn btn-primary" data-target="#collapse2">
        Button with data-target
    </button>
    <div class="collapse" id="collapse2">
        <div class="well">
            ...
        </div>
    </div>
</div>

<script src="bootstrap/js/jquery-1.11.3.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script>
    $('#href,#btn').click(function(){
        $("#collapse2").collapse('toggle');
    });
</script>
```

### 3）实现手风琴组件效果

#### a. panel 组件

* 通过 `<div>` 元素作为 panel 组件的容器元素，并设置 `class` 为 `panel`，以及一个修饰类。
* panel 组件是由一个标题（`panel-heading`）和一个主体（`panel-body`）组成。

```html
<div class="container">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">Collapsible Group</h4>
        </div>
        <div class="panel-body">
            ...
        </div>
    </div>
</div>
```

#### b. 动态的 panel 组件

想要实现动态的 panel 组件，需要 `.collapse` 和 `.panel` 两种组件组合而成。

```html
<div class="container">
    <div class="panel panel-default">
        <div class="panel-heading" id="headingOne">
            <h4 class="panel-title">
                <a role="button" data-toggle="collapse" href="#collapseOne">
                    Collapsible Group Item #1
                </a>
            </h4>
        </div>
        <div id="collapseOne" class="panel-collapse collapse in">
            <div class="panel-body">
                Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
            </div>
        </div>
    </div>
</div>
```

#### c. panel-group 组成手风琴

将 `.panel-group` 元素作为手风琴的容器元素，与 `.panel` 组件相关联。

```html
<div class="container">
    <div class="panel-group" id="accordion">
        <div class="panel panel-default">
            <div class="panel-heading" id="headingOne">
                <h4 class="panel-title">
                    <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                        Collapsible Group Item #1
                    </a>
                </h4>
            </div>
            <div id="collapseOne" class="panel-collapse collapse in">
                <div class="panel-body">
                    Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading" id="headingTwo">
                <h4 class="panel-title">
                    <a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
                        Collapsible Group Item #2
                    </a>
                </h4>
            </div>
            <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                <div class="panel-body">
                    Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading" id="headingThree">
                <h4 class="panel-title">
                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
                        Collapsible Group Item #3
                    </a>
                </h4>
            </div>
            <div id="collapseThree" class="panel-collapse collapse">
                <div class="panel-body">
                    Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
                </div>
            </div>
        </div>
    </div>
</div>
```

## 工具提示

工具提示的效果，就是将鼠标悬停在按钮、文本框、链接等等一些基本控件上就可以看到提示。

为对应 HTML 元素设置属性 `data-toggle` 为 `tooltip` 即可实现工具提示。

> **需要注意的是：**默认的工具提示功能是由 `title` 属性提供（该属性是必须的）。

```html
<button class="btn btn-default" data-toggle="tooltip" title="tooltip">tooltip</button>
```

工具提示插件与其他 Bootstrap 插件不同是，工具提示插件必须编写 JavaScript 代码才能实现相应功能。

```javascript
$('[data-toggle=tooltip]').tooltip();
```

Bootstrap 还提供了上下左右（`top、bottom、left、right`）四种提示位置，将该值设置给 `data-placement` 即可。

```html
<button class="btn btn-default" data-toggle="tooltip" data-placement="left" title="Tooltip on left">Tooltip on left</button>
<button class="btn btn-default" data-toggle="tooltip" data-placement="top" title="Tooltip on top">Tooltip on top</button>
<button class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Tooltip on bottom">Tooltip on bottom</button>
<button class="btn btn-default" data-toggle="tooltip" data-placement="right" title="Tooltip on right">Tooltip on right</button>
```

## 弹出框

弹出框是依赖工具提示插件的。与工具提示不同的是弹出框不仅提供提示标题（`title`），还提供提示内容（`data-content`）。

为对应 HTML 元素设置属性 `data-toggle` 为 `popover` 即可实现工具提示。

```html
<button class="btn btn-lg btn-danger" data-toggle="popover" title="Popover title" data-content="And here's some amazing content. It's very engaging. Right?">点我弹出/隐藏弹出框</button>
```

除此之外，弹出框还需要通过 JavaScript 编程激活相应功能。

```javascript
$('[data-toggle=popover]').popover();
```

Bootstrap 还提供了上下左右（`top、bottom、left、right`）四种提示位置，将该值设置给 `data-placement` 即可。

```html
<button class="btn btn-default" data-container="body" data-toggle="popover" data-placement="left" data-content="Vivamus sagittis lacus vel augue laoreet rutrum faucibus.">
	Popover on 左侧
</button>
<button class="btn btn-default" data-container="body" data-toggle="popover" data-placement="top" data-content="Vivamus sagittis lacus vel augue laoreet rutrum faucibus.">
	Popover on 顶部
</button>
<button class="btn btn-default" data-container="body" data-toggle="popover" data-placement="bottom" data-content="Vivamus
sagittis lacus vel augue laoreet rutrum faucibus.">
	Popover on 底部
</button>
<button class="btn btn-default" data-container="body" data-toggle="popover" data-placement="right" data-content="Vivamus sagittis lacus vel augue laoreet rutrum faucibus.">
	Popover on 右侧
</button>
```

## 模态框

Bootstrap 提供的模态框是对浏览器默认的（`alert()/confirm()/prompt()`）一种扩展。

模态框的基本结构如下：

```html
<div class="container">
    <div class="modal"><!-- 模态框容器元素 -->
        <div class="modal-dialog"><!-- 定位、高宽等 -->
            <div class="modal-content"><!-- 背景色、边框等 -->
                <div class="modal-header"><!-- 模态框的头部 -->
                    ...
                </div>
                <div class="modal-body"><!-- 模态框的主体 -->
                    ...
                </div>
                <div class="modal-footer"><!-- 模态框的尾部 -->
                    ...
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
</div>
```

实现动态地显示和隐藏模态框，可通过以下两个属性实现：

* 弹出一个模态框，使用属性 `data-toggle` 为 `modal`。
* 关闭一个模态框，使用属性 `data-dismiss` 为 `modal`。

```html
<div class="container">
    <!-- Button trigger modal -->
    <button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">
        Launch demo modal
    </button>
    <div class="modal" id="myModal"><!-- 模态框容器元素 -->
        <div class="modal-dialog"><!-- 定位、高宽等 -->
            <div class="modal-content"><!-- 背景色、边框等 -->
                <div class="modal-header"><!-- 模态框的头部 -->
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body"><!-- 模态框的主体 -->
                    ...
                </div>
                <div class="modal-footer"><!-- 模态框的尾部 -->
                    ...
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
</div>
```

也可以通过 JavaScript 编程方式实现动态地模态框。

* HTML 代码

```html
<div class="container">
    <button id="btn" class="btn btn-primary btn-lg">Launch demo modal</button>
    <div class="modal" id="myModal2"><!-- 模态框容器元素 -->
        <div class="modal-dialog"><!-- 定位、高宽等 -->
            <div class="modal-content"><!-- 背景色、边框等 -->
                <div class="modal-header"><!-- 模态框的头部 -->
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    <h4 class="modal-title">Modal title</h4>
                </div>
                <div class="modal-body"><!-- 模态框的主体 -->
                    <p>One fine body&hellip;</p>
                </div>
                <div class="modal-footer"><!-- 模态框的尾部 -->
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
</div>
```

* JavaScript 代码

```javascript
$('#btn').click(function(){
	$('#myModal2').modal();
});
```

模态框提供了两个可选尺寸，通过为 .modal-dialog 增加一个样式调整类实现。

| class 名称 | 描述 |
| --- | --- |
| modal-lg | 大模态框 |
| modal-sm | 小模态框 |

```html
<div class="container">
    <button class="btn btn-primary" data-toggle="modal" data-target="#myModal3">大模态框</button>

    <div id="myModal3" class="modal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header"><!-- 模态框的头部 -->
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    <h4 class="modal-title">Modal title</h4>
                </div>
                <div class="modal-body"><!-- 模态框的主体 -->
                    ...
                </div>
                <div class="modal-footer"><!-- 模态框的尾部 -->
                    ...
                </div>
            </div>
        </div>
    </div>
</div>
```

> **值得注意的是：**
> 
> * 不支持同时打开多个模态框。
> 
> * 务必将模态框的 HTML 代码放在文档的最高层级内（也就是说，尽量作为 body 标签的直接子元素），以避免其他组件影响模态框的展现和/或功能。

## 轮播

Bootstrap 轮播（Carousel）插件是一种灵活的响应式的向站点添加滑块的方式。除此之外，内容也是足够灵活的，可以是图像、内嵌框架、视频或者其他您想要放置的任何类型的内容。

### 1）最基本的轮播

实现最基本的轮播内容，至少需要以下元素：

* 将 `class` 为 `carousel` 的 `<div>` 元素作为轮播的容器元素。
* 样式 `class` 为 `carousel-inner` 的 `<div>` 元素表示轮播的项目。
* 在 `.carousel-inner` 元素内，`class` 为 `item` 的 `<div>` 元素作为具体内容。

```html
<div class="container">
    <div class="carousel">
        <div class="carousel-inner">
            <div class="item active">
                <img src="imgs/1.jpg">
            </div>
            <div class="item">
                <img src="imgs/2.jpg">
            </div>
        </div>
    </div>
</div>
```

实现轮播的动态效果，同样具有两种方式：

* 通过 `data-*` 属性方式：为作为容器元素的 `<div>` 添加属性 `data-ride` 为 `carousel` 即可。
* 通过 JavaScript 编程方式：

```javascript
$('#carousel').carousel();
```

> * 基于上述效果，可以通过为作为轮播插件的容器元素添加属性 `data-interval` 设置轮播切换的时间。
> * 也可以通过为作为轮播插件的容器元素添加样式 `slide` 实现轮播切换的效果。

### 2）带文字说明的轮播

文字说明就是在每个作为轮播内容的 `.item` 元素中，添加一个 `class` 为 `carousel-caption` 的 `<div>` 元素。

```html
<div class="container">
    <div class="carousel slide" data-ride="carousel">
        <div class="carousel-inner">
            <div class="item active">
                <img src="imgs/3.png">
                <div class="carousel-caption">
                    <h3>标题</h3>
                    <p>说明...</p>
                </div>
            </div>
            <div class="item">
                <img src="imgs/4.png">
                <div class="carousel-caption">
                    <h3>标题</h3>
                    <p>说明...</p>
                </div>
            </div>
        </div>
    </div>
</div>
```

### 3）带“前进/后退”功能的轮播

前进和后退功能，就是在 `.carousel` 元素中添加以下内容：

```html
<a class="carousel-control left" data-slide="prev" href="#carousel2">
	<span class="glyphicon glyphicon-chevron-left"></span>
</a>
<a class="carousel-control right" data-slide="next" href="#carousel2">
	<span class="glyphicon glyphicon-chevron-right"></span>
</a>
```

上述代码中的两个 `<a>` 元素，分别表示向左滑动和向右滑动。

* 为作为“前进和后退”功能的 `<a>` 元素添加 `carousel-control` 样式，根据向左和向右分别添加 `left` 和 `right` 样式。
* 通过设置属性 `data-silde` 为 `prev` 或 `next` 实现向左或向右切换效果。
* 并且属性 `href` 必须使用锚点指向作为轮播的容器元素。

### 4）带序号提示器的轮播

序号提示器功能，就是向 `.carousel` 元素中添加 无序列表。

* 为 `<ul>` 元素添加 `carousel-indicators` 样式。
* 为 `<li>` 元素添加属性 `data-target`，值指定为轮播容器元素的id。
* 为 `<li>` 元素添加属性 `data-slide-to`，值指定对应的数值（`0`表示第一个，`1`表示第二个，以此类推）

> **值得注意的是：**序号提示器的数量必须与轮播项目的数量一致。

```html
<div class="container">
    <div class="carousel slide" data-ride="carousel" id="carousel3">
        <ol class="carousel-indicators">
            <li data-target="#carousel3" data-slide-to="0" class="active"></li>
            <li data-target="#carousel3" data-slide-to="1"></li>
        </ol>
        <div class="carousel-inner">
            <div class="item active">
                <img src="imgs/3.png">
            </div>
            <div class="item">
                <img src="imgs/4.png">
            </div>
        </div>
    </div>
</div>
```