
## 1 文本

### 1）文本对齐

通过以下文本对齐类，可以简单方便的将文字重新对齐。

| 类名 | 描述 |
| --- | --- |
| text-left | 左对齐 |
| text-center | 居中对齐 |
| text-right | 右对齐 |
| text-justify | 两端对齐，段落中超出屏幕部分文字自动换行 |
| text-nowrap | 段落中超出屏幕部分不换行 |

```html
<div class="container">
    <div class="row">
        <p class="text-left">Left aligned text.</p>
        <p class="text-center">Center aligned text.</p>
        <p class="text-right">Right aligned text.</p>
        <p class="text-justify">Justified text.</p>
        <p class="text-nowrap">No wrap text.</p>
    </div>
</div>
```

### 2）改变大小写

通过以下这几个类可以改变文本的大小写。

| 类名 | 描述 |
| --- | --- |
| text-lowercase| 小写 |
| text-uppercase| 大写 |
| text-capitalize| 首字母大写 |

```html
<div class="container">
    <div class="row">
        <p class="text-lowercase">Lowercased text.</p>
        <p class="text-uppercase">Uppercased text.</p>
        <p class="text-capitalize">Capitalized text.</p>
    </div>
</div>
```

### 3）文本颜色

Bootstrap 允许为文本设置不同颜色表示不同含义，具体如下：

| 类名 | 描述 |
| --- | --- |
| text-muted | 提示，使用浅灰色 |
| text-primary | 首选项，使用蓝色 |
| text-success | 成功，使用浅绿色 |
| text-info | 信息，使用浅蓝色 |
| text-warning | 警告，使用黄色 |
| text-danger | 危险，使用褐色 |

```html
<div class="container">
    <div class="row">
        <p class="text-muted">提示信息</p>
        <p class="text-primary">首选项</p>
        <p class="text-success">成功</p>
        <p class="text-info">信息</p>
        <p class="text-warning">警告</p>
        <p class="text-danger">危险</p>
    </div>
</div>
```
### 4）标题

```
<h1>h1. Bootstrap heading</h1>
<h2>h2. Bootstrap heading</h2>
<h3>h3. Bootstrap heading</h3>
<h4>h4. Bootstrap heading</h4>
<h5>h5. Bootstrap heading</h5>
<h6>h6. Bootstrap heading</h6>
```

### 5）内联文本元素

* mark
* del
* strong
* small
* u/s/em

## 2 列表

### 1）无序列表

```html
<div class="container">
    <div class="row">
        <ul>
            <li>苹果</li>
            <li>香蕉</li>
            <li>西瓜
                <ul>
                    <li>大兴西瓜</li>
                    <li>东北西瓜</li>
                </ul>
            </li>
            <li>芒果</li>
            <li>樱桃</li>
        </ul>
    </div>
</div>
```

### 2）有序列表

```html
<div class="container">
    <div class="row">
        <ol>
            <li>苹果</li>
            <li>香蕉</li>
            <li>西瓜
                <ol>
                    <li>大兴西瓜</li>
                    <li>东北西瓜</li>
                </ol>
            </li>
            <li>芒果</li>
            <li>樱桃</li>
        </ol>
    </div>
</div>
```

### 3）无样式列表

移除了默认的 list-style 样式和左侧外边距的一组元素（只针对直接子元素）。

```html
<div class="container">
    <div class="row">
        <ul class="list-unstyled">
            <li>苹果</li>
            <li>香蕉</li>
            <li>西瓜
                <ul>
                    <li>大兴西瓜</li>
                    <li>东北西瓜</li>
                </ul>
            </li>
            <li>芒果</li>
            <li>樱桃</li>
        </ul>
    </div>
</div>
```

### 4）内联列表

通过设置 display: inline-block; 并添加少量的内补（padding），将所有元素放置于同一行。

```html
<div class="container">
    <div class="row">
        <ul class="list-inline">
            <li>苹果</li>
            <li>香蕉</li>
            <li>西瓜
                <ul>
                    <li>大兴西瓜</li>
                    <li>东北西瓜</li>
                </ul>
            </li>
            <li>芒果</li>
            <li>樱桃</li>
        </ul>
    </div>
</div>
```

### 5）描述

#### a. 垂直排列的描述

带有描述的短语列表。

```html
<div class="container">
    <div class="row">
        <dl>
            <dt>Description lists</dt>
            <dd>A description list is perfect for defining terms.</dd>
            <dt>Euismod</dt>
            <dd>Vestibulum id ligula porta felis euismod semper eget lacinia odio sem nec elit.<br>
                Donec id elit non mi porta gravida at eget metus.</dd>
            <dt>Malesuada porta</dt>
            <dd>Etiam porta sem malesuada magna mollis euismod.</dd>
        </dl>
    </div>
</div>
```

#### b. 水平排列的描述

.dl-horizontal 可以让 <dl> 内的短语及其描述排在一行。

```html
<div class="container">
    <div class="row">
        <dl class="dl-horizontal">
            <dt>Description lists</dt>
            <dd>A description list is perfect for defining terms.</dd>
            <dt>Euismod</dt>
            <dd>Vestibulum id ligula porta felis euismod semper eget lacinia odio sem nec elit.<br>
                Donec id elit non mi porta gravida at eget metus.</dd>
            <dt>Malesuada porta</dt>
            <dd>Etiam porta sem malesuada magna mollis euismod.</dd>
        </dl>
    </div>
</div>
```

## 3 按钮

### 1）作为按钮的元素

Bootstrap 利用 `<a>`、`<button>`和`<input>`元素作为按钮样式。

```html
<div class="container">
    <div class="row">
        <a class="btn btn-default" href="#" role="button">Link</a>
        <button class="btn btn-default" type="submit">Button</button>
        <input class="btn btn-default" type="button" value="Input">
        <input class="btn btn-default" type="submit" value="Submit">
    </div>
</div>
```

> **值得注意的是：**

> 1. 导航和导航条组件只支持 `<button>` 元素。
> 2. 如果 `<a>` 元素被作为按钮使用，务必为其设置 role="button" 属性。
> 3. 建议尽可能使用 `<button>` 元素。

### 2）预定义样式

Bootstrap 为按钮预定义了很多样式，具体样式说明如下：

| 样式名称 | 描述 |
| --- | --- |
| btn-default | 默认样式 |
| btn-primary | 首选项 |
| btn-success | 成功样式 |
| btn-info | 一般信息 |
| btn-warning | 警告样式 |
| btn-danger | 危险样式 |
| btn-link | 链接样式 |

```html
<div class="container">
    <div class="row">
        <button type="button" class="btn btn-default">（默认样式）Default</button>
        <button type="button" class="btn btn-primary">（首选项）Primary</button>
        <button type="button" class="btn btn-success">（成功）Success</button>
        <button type="button" class="btn btn-info">（一般信息）Info</button>
        <button type="button" class="btn btn-warning">（警告）Warning</button>
        <button type="button" class="btn btn-danger">（危险）Danger</button>
        <button type="button" class="btn btn-link">（链接）Link</button>
    </div>
</div>
```

### 3）不同尺寸的按钮

* Bootstrap 为按钮提供了大、默认、小和很小几个尺寸。

```html
<div class="container">
   <div class="row">
        <button type="button" class="btn btn-default btn-lg">（大按钮）Large button</button>
        <button type="button" class="btn btn-default">（默认尺寸）Default button</button>
        <button type="button" class="btn btn-default">（默认尺寸）Default button</button>
        <button type="button" class="btn btn-default btn-xs">（超小尺寸）Extra small button</button>
    </div>
</div>
```

* 通过给按钮添加 .btn-block 类可以将其拉伸至父元素100%的宽度，而且按钮也变为了块级（block）元素。

```html
<div class="container">
    <div class="row">
        <button type="button" class="btn btn-default btn-lg btn-block">（块级元素）Block level button</button>
    </div>
</div>
```

### 4）按钮激活状态

为按钮元素添加 .active 类，设置其为激活状态。当按钮处于激活状态时，其表现为被按压下去（底色更深、边框夜色更深、向内投射阴影）。

```html
<div class="container">
    <div class="row">
        <button type="button" class="btn btn-default btn-lg active">Button</button>
        <a href="#" class="btn btn-default btn-lg active" role="button">Link</a>
    </div>
</div>
```

### 5）按钮禁用状态

通过为按钮的背景设置 opacity 属性就可以呈现出无法点击的效果。

* 为 `<button>` 元素添加 disabled 属性，使其表现出禁用状态。

```html
<button type="button" class="btn btn-default btn-lg" disabled="disabled">Button</button>
```

> **跨浏览器兼容性**
>
> Internet Explorer 9 及更低版本的浏览器将会把按钮中的文本绘制为灰色，并带有恶心的阴影，目前还没有解决办法。

* 为基于 `<a>` 元素创建的按钮添加 .disabled 类。

```html
<a href="#" class="btn btn-default btn-lg disabled" role="button">Link</a>
```

## 4 图片

### 1）响应式图片

通过为图片添加 .img-responsive 类可以让图片支持响应式布局。

> 如果需要让使用了 .img-responsive 类的图片水平居中，请使用 .center-block 类，不要用 .text-center。

```html
<div class="container">
    <div class="row">
        <img src="imgs/1.jpg" class="img-responsive" alt="Responsive image">
    </div>
    <div class="row">
        <img src="imgs/1.jpg" class="img-responsive center-block" alt="Responsive image">
    </div>
</div>
```

### 2）图片形状

通过为 <img> 元素添加以下相应的类，可以让图片呈现不同的形状。

| 类名 | 描述 |
| --- | --- |
| img-rounded | 圆角矩形 |
| img-circle | 圆形 |
| img-thumbnail | 矩形 |

> IE 8 不支持 CSS3 中的圆角属性。

```html
<div class="container">
    <div class="row">
        <img src="imgs/1.jpg" alt="..." class="img-rounded">
        <img src="imgs/1.jpg" alt="..." class="img-circle">
        <img src="imgs/1.jpg" alt="..." class="img-thumbnail">
    </div>
</div>
```


## 5 表格

### 1）基本表格

为任意 `<table>` 标签添加 .table 类可以为其赋予基本的样式。

```html
<div class="container">
    <div class="row">
        <table class="table">
            <thead>
            <tr>
                <th>ID</th>
                <th>名称</th>
                <th>价格</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>1</td>
                <td>书籍</td>
                <td>12.50</td>
            </tr>
            <tr>
                <td>2</td>
                <td>电视</td>
                <td>1000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
```

### 2）条纹状表格

通过 .table-striped 类可以给 `<tbody>` 之内的每一行增加斑马条纹样式。


```html
<div class="container">
    <div class="row">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>ID</th>
                <th>名称</th>
                <th>价格</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>1</td>
                <td>书籍</td>
                <td>12.50</td>
            </tr>
            <tr>
                <td>2</td>
                <td>电视</td>
                <td>1000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
```

> 条纹状表格是依赖 :nth-child CSS 选择器实现的，而这一功能不被 IE 8 支持。

### 3）带边框表格

添加 .table-bordered 类为表格和其中的每个单元格增加边框。

```html
<div class="container">
    <div class="row">
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>ID</th>
                <th>名称</th>
                <th>价格</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>1</td>
                <td>书籍</td>
                <td>12.50</td>
            </tr>
            <tr>
                <td>2</td>
                <td>电视</td>
                <td>1000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
```

### 4）鼠标悬停

通过添加 .table-hover 类可以让 `<tbody>` 中的每一行对鼠标悬停状态作出响应。

```html
<div class="container">
    <div class="row">
        <table class="table table-hover">
            <thead>
            <tr>
                <th>ID</th>
                <th>名称</th>
                <th>价格</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>1</td>
                <td>书籍</td>
                <td>12.50</td>
            </tr>
            <tr>
                <td>2</td>
                <td>电视</td>
                <td>1000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
```

### 5）紧缩表格

通过添加 .table-condensed 类可以让表格更加紧凑，单元格中的 padding 均会减半。

```html
<div class="container">
    <div class="row">
        <table class="table table-condensed">
            <thead>
            <tr>
                <th>ID</th>
                <th>名称</th>
                <th>价格</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>1</td>
                <td>书籍</td>
                <td>12.50</td>
            </tr>
            <tr>
                <td>2</td>
                <td>电视</td>
                <td>1000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            <tr>
                <td>3</td>
                <td>笔记本</td>
                <td>2000</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
```

### 6）状态类

通过这些状态类可以为行或单元格设置颜色。

| 类名 | 描述 |
| --- | --- |
| active | 鼠标悬停在行或单元格上时所设置的颜色 |
| success | 标识成功或积极的动作 |
| info | 标识普通的提示信息或动作 |
| warning | 标识警告或需要用户注意 |
| danger | 标识危险或潜在的带来负面影响的动作 | 

```html
<div class="container">
    <div class="row">
        <table class="table">
            <thead>
            <tr>
                <th>ID</th>
                <th>名称</th>
                <th>价格</th>
            </tr>
            </thead>
            <tbody>
            <tr class="active">
                <td>1</td>
                <td>书籍</td>
                <td>12.50</td>
            </tr>
            <tr class="success">
                <td>2</td>
                <td>电视</td>
                <td>1000</td>
            </tr>
            <tr>
                <td class="info">3</td>
                <td>笔记本</td>
                <td class="warning">2000</td>
            </tr>
            <tr>
                <td>3</td>
                <td class="danger">笔记本</td>
                <td>2000</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
```

> **值得注意的是：**
> 
> 这些状态类不仅可以作用于`<tr>`元素，还可以作用于`<td>`元素。

### 7）响应式表格

将任何 .table 元素包裹在 .table-responsive 元素内，即可创建响应式表格。其会在小屏幕设备上（小于768px）水平滚动。当屏幕大于 768px 宽度时，水平滚动条消失。

## 6 辅助样式

### 1）背景颜色

和文本颜色一样，Bootstrap 允许添加不同的背景颜色表示不同含义，具体如下：

| 类名 | 描述 |
| --- | --- |
| bg-primary | 首选项，使用蓝色 |
| bg-success | 成功，使用浅绿色 |
| bg-info | 信息，使用浅蓝色 |
| bg-warning | 警告，使用黄色 |
| bg-danger | 危险，使用褐色 |

```html
<div class="container">
    <div class="row">
        <p class="bg-muted">提示信息</p>
        <p class="bg-primary">首选项</p>
        <p class="bg-success">成功</p>
        <p class="bg-info">信息</p>
        <p class="bg-warning">警告</p>
        <p class="bg-danger">危险</p>
    </div>
</div>
```

### 2）浮动

#### a. 浮动

通过添加 .pull-left 或 .pull-right 类，可以将任意元素向左或向右浮动。

* CSS 代码

```css
.block1 {
	width : 300px;
	height : 200px;
	border : 1px solid black;
	background : dodgerblue;
}
.block2 {
	width : 500px;
	height : 300px;
	border : 1px solid black;
	background : yellowgreen;
}
```

* HTML 代码

```html
<div class="container">
    <div>
        <div class="block1 pull-left"></div>
        <div class="block1 pull-right"></div>
    </div>
    <div class="block2"></div>
</div>
```

#### b. 清除浮动

通过为父元素添加 .clearfix 类可以很容易地清除浮动。

* CSS 代码

```css
.block1 {
	width : 300px;
	height : 200px;
	border : 1px solid black;
	background : dodgerblue;
}
.block2 {
	width : 500px;
	height : 300px;
	border : 1px solid black;
	background : yellowgreen;
}
```

* HTML 代码

```html
<div class="container">
    <div class="clearfix">
        <div class="block1 pull-left"></div>
        <div class="block1 pull-right"></div>
    </div>
    <div class="block2"></div>
</div>
```

### 3）居中

为任意元素设置 .center-block 类让其中的内容居中。

```html
<div class="center-block"></div>
```

### 4）显示或隐藏

.show 和 .hidden 类可以强制任意元素显示或隐藏(对于屏幕阅读器也能起效)，这些类只对块级元素起作用。

另外，.invisible 类可以被用来仅仅影响元素的可见性，也就是说，元素的 display 属性不被改变，并且这个元素仍然能够影响布局。

```html
<div class="show"></div>
<div class="hidden"></div>
<div class="invisible"></div>
<div></div>
```

## 7 代码风格

三种代码风格

1. 使用`<code></code>`文本内联代码
2. 使用`<pre></pre>`多行代码注释.pre-scrollable添加代码滚动条
3. 使用`<kbd></kbd>`用户输入代码，快捷键效果
4. 使用`<var>`标记变量

<code>内敛代码</code>
<kbd>ctrl</kbd>
<pre>
a
    b
    c   d
    e
e
</pre>

