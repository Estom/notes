## 字体图标

Bootstrap 使用的字体图标是来自 Glyphicions Halflings 提供的。**在使用的时候，需要遵守以下几点规则：**

* 图标使用的 class 不能与其他组件的 class 混合使用。换言之，图标的 class 必须被定义在 span 元素上。
* 图标使用的 class 具有一个基类和一个修饰类。基类（class）统一为 `.glyphicon`，修饰类（class）为 `.glyphicon-*-*`或`.glyphicon-*`。
* 只对内容为空的元素起作用（图标使用的 class 只能应用在不包含任何文本内容或子元素的元素上）。

```html
<div class="container">
    <p class="text-danger">
        <span class="glyphicon glyphicon-warning-sign"></span>
        <span class="glyphicon glyphicon-alert"></span>
        警告：您的浏览器版本太低了!
    </p>
    <button class="btn btn-success" type="button">
        <span class="glyphicon glyphicon-apple"></span>
        删除
    </button>
        <button class="btn btn-danger" type="button">
        <span class="glyphicon glyphicon-arrow-left"></span>
    </button>
    <button class="btn btn-default" type="button">
        <span class="glyphicon glyphicon-star"></span>
    </button>
        <a class="btn btn-info" href="#">
        <span class="glyphicon glyphicon-play"></span>
    </a>
</div>
```

## 下拉菜单

### 1）基本样式

Bootstrap 提供的下拉菜单并不是 HTML 默认的 `<select>` 元素，而且利用一组 HTML 元素组合而成。

* `<div>`元素作为容器元素
* `<button>`或`<a>`元素作为下拉菜单的提示项。

	作为下拉菜单的提示项，Bootstrap 默认显示的是按钮样式（也就是需要设置 `class` 为 `btn btn-*`）。

	按钮在被点击后，会提供不同的样式效果。如果想改变这样的样式，需要添加样式`dropdown-toggle`。

	通过为下拉菜单的提示项设置属性 `data-toggle=dropdown` ，实现下拉菜单的动态显示。（此内容会在 **组件** 详细讲解）

* 无序列表作为下拉菜单的列表项。

#### a. 向下弹出

为作为下拉菜单的容器元素设置样式`dropdown`即可。

```html
<div class="container">
    <div class="dropdown">
        <button class="btn btn-default" data-toggle="dropdown">
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

#### b. 向上弹出

为作为下拉菜单的容器元素设置样式`dropup`即可。

```html
<div class="container">
    <div class="dropup">
        <button class="btn btn-default" data-toggle="dropdown">
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

### 2）标题

可以为作为下拉菜单的列表项中，添加 `class` 为 `dropdown-header` 的 `<li>` 元素作为标题，表示一组动作。

```html
<div class="container">
    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            Dropdown
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li class="dropdown-header">Dropdown header</li>
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li class="dropdown-header">Dropdown header</li>
            <li><a href="#">Separated link</a></li>
        </ul>
    </div>
</div>
```

### 3）分割线

可以为作为下来菜单的列表项中，添加 `class` 为 `divider` 的 `<li>` 元素作为分割线，表示将多个选项进行分组。

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
            <li class="divider"></li>
            <li><a href="#">Separated link</a></li>
        </ul>
    </div>
</div>
```

### 4）禁用项

为下拉菜单中的 `<li>` 元素添加 `.disabled` 类，从而禁用相应的菜单项。

```html
<div class="container">
    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            Dropdown
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="#">Regular link</a></li>
            <li class="disabled"><a href="#">Disabled link</a></li>
            <li><a href="#">Another link</a></li>
        </ul>
    </div>
</div>
```

## 按钮组

### 1）基本按钮组

通过按钮组容器把一组按钮放在同一组里，为按钮组容器设置 `class` 为 `btn-group`。

```html
<div class="container">
    <div class="btn-group">
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-ok-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-remove-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-pencil"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-check"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-question-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-edit"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-search"></span>
        </a>
    </div>
</div>
```

### 2）不同布局

#### a. 两端对齐

让一组按钮拉长为相同的尺寸，填满父元素的宽度。为按钮组容器添加样式 `btn-group-justified`。

```html
<div class="container">
    <div class="btn-group btn-group-justified">
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-ok-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-remove-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-pencil"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-check"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-question-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-edit"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-search"></span>
        </a>
    </div>
</div>
```

#### b. 垂直排列

让一组按钮垂直堆叠排列显示而不是水平排列，为按钮组容器设置 `class` 为 `btn-group-vertical`。

```html
<div class="container">
    <div class="btn-group-vertical">
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-ok-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-remove-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-pencil"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-check"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-question-sign"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-edit"></span>
        </a>
        <a class="btn btn-info" href="#">
            <span class="glyphicon glyphicon-search"></span>
        </a>
    </div>
</div>
```

### 3）尺寸

只要给 .btn-group 加上 .btn-group-* 类，就省去为按钮组中的每个按钮都赋予尺寸类。

Bootstrap 提供了以下几种尺寸：

| class 名称 | 描述 |
| --- | --- |
| btn-group-lg | 大 |
| btn-group-sm | 小 |
| btn-group-xs | 很小 |

> 除上述尺寸外，Bootstrap 还提供一种默认尺寸（无需设置）。

```html
<div class="container">
    <div class="btn-group btn-group-lg">
        <a class="btn btn-info" href="#">Left</a>
        <a class="btn btn-info" href="#">Middle</a>
        <a class="btn btn-info" href="#">Right</a>
    </div>
    <div class="btn-group">
        <a class="btn btn-info" href="#">Left</a>
        <a class="btn btn-info" href="#">Middle</a>
        <a class="btn btn-info" href="#">Right</a>
    </div>
    <div class="btn-group btn-group-sm">
        <a class="btn btn-info" href="#">Left</a>
        <a class="btn btn-info" href="#">Middle</a>
        <a class="btn btn-info" href="#">Right</a>
    </div>
    <div class="btn-group btn-group-xs">
        <a class="btn btn-info" href="#">Left</a>
        <a class="btn btn-info" href="#">Middle</a>
        <a class="btn btn-info" href="#">Right</a>
    </div>
</div>
```

### 4）按钮工具栏

把一组 `<div class="btn-group">` 组合包裹在一个 `<div class="btn-toolbar">` 中就可以做成更复杂的组件。

```html
<div class="container">
    <div class="btn-toolbar">
        <div class="btn-group">
            <a class="btn btn-info" href="#">
                <span class="glyphicon glyphicon-ok-sign"></span>
            </a>
            <a class="btn btn-info" href="#">
                <span class="glyphicon glyphicon-remove-sign"></span>
            </a>
            <a class="btn btn-info" href="#">
                <span class="glyphicon glyphicon-pencil"></span>
            </a>
        </div>
        <div class="btn-group">
            <a class="btn btn-info" href="#">
                <span class="glyphicon glyphicon-check"></span>
            </a>
            <a class="btn btn-info" href="#">
                <span class="glyphicon glyphicon-question-sign"></span>
            </a>
        </div>
        <div class="btn-group">
            <a class="btn btn-info" href="#">
                <span class="glyphicon glyphicon-edit"></span>
            </a>
            <a class="btn btn-info" href="#">
                <span class="glyphicon glyphicon-search"></span>
            </a>
        </div>
    </div>
</div>
```

### 5）嵌套下拉菜单

想要把下拉菜单混合到一系列按钮中，只须把 .btn-group 放入另一个 .btn-group 中。

```html
<div class="container">
    <div class="btn-group">
        <button type="button" class="btn btn-default">1</button>
        <button type="button" class="btn btn-default">2</button>

        <div class="btn-group" role="group">
            <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                Dropdown
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a href="#">Dropdown link</a></li>
                <li><a href="#">Dropdown link</a></li>
            </ul>
        </div>
    </div>
</div>
```

## 警告框

警告框组件通过提供一些灵活的预定义消息，为常见的用户动作提供反馈消息。

### 1）基本警告框

Bootstrap 的警告框样式由 `.alert` 和 4 个修饰`class`组成。4 个修饰`class`表示不同的警告信息。

| class 名称 | 描述 |
| --- | --- |
| alert-success | 成功 |
| alert-info | 信息 |
| alert-warning | 警告 |
| alert-danger | 危险 |

```html
<div class="container">
    <div class="alert alert-danger">
        <span class="glyphicon glyphicon-alert"></span>
        您的浏览器禁用了Cookie！本站的部分功能无法启用！
    </div>
    <div class="alert alert-info">
        <span class="glyphicon glyphicon-alert"></span>
        没有更多数据可供加载了！
    </div>

    <div class="alert alert-warning">
        <span class="glyphicon glyphicon-alert"></span>
        您的浏览器OUT啦！请使用更新版本的浏览器!
    </div>

    <div class="alert alert-success">
        <span class="glyphicon glyphicon-alert"></span>
        您已经登录了！无需再次登录！
    </div>
</div>
```

### 2）可关闭的警告框

为警告框添加一个可选的 .alert-dismissible 类和一个关闭按钮。

```html
<div class="container">
    <div class="alert alert-success alert-dismissible">
        <!--.close元素必须是alert的第一个子元素-->
        <span data-dismiss="alert" class="close">&times;</span>
        <span class="glyphicon glyphicon-alert"></span>
        您已经登录了！无需再次登录！
    </div>
</div>
```

### 3）警告框中的链接

用 .alert-link 工具类，可以为链接设置与当前警告框相符的颜色。

```html
<div class="container">
    <div class="alert alert-warning">
        <span class="glyphicon glyphicon-alert"></span>
        您的浏览器OUT啦！请使用更新版本的<a href="#" class="alert-link">浏览器</a>!
    </div>
</div>
```

## 导航

Bootstrap 中的导航组件都依赖同一个 .nav 类。

### 1）两种导航样式

Bootstrap 提供标签页主要利用的是 **无序列表** 元素。

#### a. 标签页式导航

标签页式导航，就是为作为标签页的`<ul>`元素添加 class 为 .nav-tab 的样式。

> **需要注意的是：**
> 
> * .nav-tabs 类依赖 .nav 基类。
> * 默认被点击的样式为 `active`。
> * 实现动态切换效果，需要为作为导航项的元素设置 `data-toggle` 为 `tab`。（具体内容会在 **组件** 详细讲解）

```html
<div class="container">
    <h3>标签页式导航</h3>
    <ul class="nav nav-tabs">
        <li data-toggle="tab" class="active"><a href="#">Home</a></li>
        <li data-toggle="tab"><a href="#">Profile</a></li>
        <li data-toggle="tab"><a href="#">Messages</a></li>
    </ul>
</div>
```

#### b. 胶囊式标导航

胶囊式导航，就是为作为标签页的`<ul>`元素添加 class 为 .nav-pills 的样式。

##### 水平方向

胶囊式导航的默认方向，就是水平方向。

```html
<div class="container">
    <h3>胶囊式导航</h3>
    <ul class="nav nav-pills">
        <li data-toggle="tab" class="active"><a href="#">Home</a></li>
        <li data-toggle="tab"><a href="#">Profile</a></li>
        <li data-toggle="tab"><a href="#">Messages</a></li>
    </ul>
</div>
```

##### 垂直方向

想要将胶囊式导航设置为垂直方向，只需为作为标签页的`<ul>`元素添加 class 为 `.nav-stacked` 的样式。

```html
<div class="container">
    <h3>垂直方向的胶囊式导航</h3>
    <ul class="nav nav-pills nav-stacked">
        <li data-toggle="tab" class="active"><a href="#">Home</a></li>
        <li data-toggle="tab"><a href="#">Profile</a></li>
        <li data-toggle="tab"><a href="#">Messages</a></li>
    </ul>
</div>
```

### 2）两端对齐

在大于 768px 的屏幕上，通过 `.nav-justified` 类可以很容易的让标签页或胶囊式导航呈现出同等宽度。在小屏幕上，导航链接以垂直方向呈现。

```html
<div class="container">
    <ul class="nav nav-tabs nav-justified">
        <li data-toggle="tab" class="active"><a href="#">Home</a></li>
        <li data-toggle="tab"><a href="#">Profile</a></li>
        <li data-toggle="tab"><a href="#">Messages</a></li>
    </ul>
    <ul class="nav nav-pills nav-justified">
        <li data-toggle="tab" class="active"><a href="#">Home</a></li>
        <li data-toggle="tab"><a href="#">Profile</a></li>
        <li data-toggle="tab"><a href="#">Messages</a></li>
    </ul>
</div>
```

### 3）嵌套下拉菜单

导航中也可以嵌入下拉菜单。

```html
<div class="container">
    <ul class="nav nav-pills">
        <li data-toggle="tab" class="active"><a href="#">Home</a></li>
        <li data-toggle="tab"><a href="#">Help</a></li>
        <li data-toggle="tab" class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown">
                Dropdown
                <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
                <li><a href="#">Action</a></li>
                <li><a href="#">Another action</a></li>
                <li><a href="#">Something else here</a></li>
                <li><a href="#">Separated link</a></li>
            </ul>
        </li>
    </ul>
</div>
```

## 导航条

导航条是在应用或网站中作为导航页头的响应式基础组件。

### 1）导航条样式

Bootstrap 提供的导航条使用 HTML5 的语义化元素 `<nav>` 作为容器元素，并为该元素设置 `class` 为 `.navbar`。

#### a. 默认样式的导航条

默认样式的导航条，需要为作为容器元素的 `<nav>` 元素，添加 `.navbar-default` 样式。

```html
<div class="container">
    <nav class="navbar navbar-default">
        <!-- 导航条组件 -->
    </nav>
</div>
```

#### b. 反色的导航条

通过添加 .navbar-inverse 类可以改变导航条的外观。

```html
<div class="container">
    <nav class="navbar navbar-inverse">
        <!-- 导航条组件 -->
    </nav>
</div>
```

### 2）导航条组件

#### a. 品牌图标

一般在导航条添加网站的名称或图标，使用 `<a>` 元素，并且为其设置 `class` 为 `.navbar-brand`。

```html
<div class="container">
    <nav class="navbar navbar-default">
        <a class="navbar-brand" href="#">
            <img src="imgs/logo.png" alt="Brand" width="20">
        </a>
    </nav>
</div>
```

> **需要注意的是：**
> 
> * `.navbar-brand`样式设置的高度为 50px，并且内边距为 15px。所以，如果使用图标的话，一定设置图标的高度为 20px。

#### b. 表单

在导航条添加表单的话，需要为 `<form>` 元素设置 `class` 为 `navbar-form`。表单内组件可以呈现很好的垂直对齐，并且较窄的宽度中呈现折叠状态。

```html
<div class="container">
    <nav class="navbar navbar-default">
        <form class="navbar-form">
            <div class="form-group">
                <input type="text" class="form-control" placeholder="Search">
            </div>
            <button type="submit" class="btn btn-default">Submit</button>
        </form>
    </nav>
</div>
```

#### c. 按钮

如果要在导航条中添加非表单内的按钮时，需要为其添加 `navbar-btn` 样式，使之在导航条中垂直居中。

```html
<div class="container">
    <nav class="navbar navbar-default">
        <button class="btn btn-default navbar-btn">Sign in</button>
    </nav>
</div>
```

#### d. 文本

在导航条中包含普通的文本内容，需要使用 `<p>` 元素，并且为其设置 `class` 为 `navbar-text`，使其具有正确的行距和颜色。

```html
<div class="container">
    <nav class="navbar navbar-default">
        <p class="navbar-text">Signed in as Mark Otto</p>
    </nav>
</div>
```

#### e. 导航

在导航条中最主要的功能就是集成导航，需要为作为导航的 `<ul>` 元素设置 `class` 为 `navbar-nav`。

```html
<div class="container">
    <nav class="navbar navbar-default">
       <ul class="nav navbar-nav">
            <li data-toggle="tab" class="active"><a href="#">Home</a></li>
            <li data-toggle="tab"><a href="#">Profile</a></li>
            <li data-toggle="tab"><a href="#">Messages</a></li>
        </ul>
    </nav>
</div>
```

#### f. 组件排列

通过添加 .navbar-left 和 .navbar-right 工具类让导航链接、表单、按钮或文本对齐。

```html
<div class="container">
    <nav class="navbar navbar-default">
        <ul class="nav navbar-nav navbar-left">
            <li data-toggle="tab" class="active"><a href="#">Home</a></li>
            <li data-toggle="tab"><a href="#">Profile</a></li>
            <li data-toggle="tab"><a href="#">Messages</a></li>
        </ul>
        <form class="navbar-form navbar-right">
            <div class="form-group">
                <input type="text" class="form-control" placeholder="Search">
            </div>
            <button type="submit" class="btn btn-default">Submit</button>
        </form>
    </nav>
</div>
```

### 3）固定的导航条

固定的导航条不会随着页面滚动而消失。

#### a. 固定在顶部

为 `<nav>` 元素添加 `.navbar-fixed-top` 类可以让导航条固定在顶部，并且导航条的宽度与页面宽度一致。

```html
<div class="container">
    <nav class="navbar navbar-default navbar-fixed-top">
        <!-- 导航条组件 -->
    </nav>
</div>
```

#### b. 固定在底部

为 `<nav>` 元素添加 `.navbar-fixed-bottom` 类可以让导航条固定在底部，并且导航条的宽度与页面宽度一致。

```html
<div class="container">
    <nav class="navbar navbar-default navbar-fixed-bottom">
        <!-- 导航条组件 -->
    </nav>
</div>
```

### 4）响应式导航条

Bootstrap 以 768px 宽度为分界点，分别进行设置导航条的内容及样式。

| class 名称 | 描述 |
| --- | --- |
| navbar-header | 针对宽度小于 768px 的屏幕 |
| navbar-collapse | 针对宽度大于等于 768px 的屏幕 |

##### 针对小于 768px 屏幕的导航条

* 使用 `<div>` 作为容器元素，并为其设置 `class` 为 `navbar-header`。
* 一般使用 `<button>` 或 `<a>` 元素，并设置 `class` 为 `navbar-toggle`。
* 通过为 `<button>` 或 `<a>` 元素设置属性 `data-toggle` 为 `collapse`，实现点击交互效果。
* 通过为 `<button>` 或 `<a>` 元素设置属性 `data-target` 为 对应菜单容器元素的 `id` 属性值。
* 在 `<button>` 或 `<a>` 元素内添加三个 `<span class="icon-bar"></span>` 元素（汉堡包按钮样式）。

```html
<div class="container">
    <nav class="nav navbar-default">
        <div class="navbar-header">
            <button class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
        </div>
        <!-- 导航条组件 -->
    </nav>
</div>
```

##### 针对大于等于 768px 屏幕的导航条

使用 `<div>` 作为容器元素，并为其设置 `class` 为 `collapse navbar-collapse` 和 `id` 属性（**用于与针对小于 768px 屏幕的`button`元素的`data-target`属性值对应。**）。

```html
<div class="container">
    <nav class="nav navbar-default">
        <!-- 针对宽度小于 768px 的汉堡包按钮 -->
        <div class="collapse navbar-collapse" id="navbar-collapse">
            <ul class="nav navbar-nav">
                <li data-toggle="tab" class="active"><a href="#">Home</a></li>
                <li data-toggle="tab"><a href="#">Profile</a></li>
                <li data-toggle="tab"><a href="#">Messages</a></li>
            </ul>
        </div>
    </nav>
</div>
```

## 媒体对象

Bootstrap 媒体对象常用于用户的评论、帖子或商品列表。

* 使用 `<div>` 作为媒体对象的容器元素，并设置 `class` 为 `.media` 。
* 媒体对象提供左（`media-left`）、主体（`media-body`）和右（`media-right`）三种结构。
* 设置垂直方向的上（`media-top`）、中（`media-middle`）和下（`media-bottom`）三种。
* 如果使用图片的话，需要设置为`media-object`。

```html
<div class="container">
    <h3>左中结构</h3>
    <div class="media">
        <div class="media-left">
            <a href="#">
                <img src="imgs/1.jpg" class="media-object">
            </a>
        </div>
        <div class="media-body">
            <h4>Media heading</h4>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Beatae debitis dicta repellat repellendus vel? Ab assumenda, doloribus eaque enim iure mollitia, non officia recusandae repellat reprehenderit repudiandae sunt velit, veritatis?</p>
        </div>
    </div>
    <hr>
    <h3>中右结构</h3>
    <div class="media">
        <div class="media-body media-middle">
            <h4>Media heading</h4>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Beatae debitis dicta repellat repellendus vel? Ab assumenda, doloribus eaque enim iure mollitia, non officia recusandae repellat reprehenderit repudiandae sunt velit, veritatis?</p>
        </div>
        <div class="media-right">
            <a href="#">
                <img src="imgs/1.jpg" class="media-object">
            </a>
        </div>
    </div>
    <hr>
    <h3>左中右结构</h3>
    <div class="media">
        <div class="media-left">
            <a href="#">
                <img src="imgs/1.jpg" class="media-object">
            </a>
        </div>
        <div class="media-body media-bottom">
            <h4>Media heading</h4>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Beatae debitis dicta repellat repellendus vel? Ab assumenda, doloribus eaque enim iure mollitia, non officia recusandae repellat reprehenderit repudiandae sunt velit, veritatis?</p>
        </div>
        <div class="media-right">
            <a href="#">
                <img src="imgs/1.jpg" class="media-object">
            </a>
        </div>
    </div>
</div>
```

## 列表组

### 1）基本列表组

默认的列表组使用无序列表实现。

`<ul>` 元素作为列表组的容器元素，并为其设置 `class` 为 `list-group`。`<li>` 元素作为列表组的列表项，并为其设置 `class` 为 `list-group-item`。

也可以将 `<ul>` 元素替换为 `<div>` 元素，将 `<li>` 元素替换为 `<button>` 或 `<a>` 元素。

```html
<div class="container">
    <ul class="list-group">
        <li class="list-group-item">Cras justo odio</li>
        <li class="list-group-item">Dapibus ac facilisis in</li>
        <li class="list-group-item">Morbi leo risus</li>
        <li class="list-group-item">Porta ac consectetur ac</li>
        <li class="list-group-item">Vestibulum at eros</li>
    </ul>
</div>
```

### 2）徽章

给链接、导航等元素嵌套 `<span class="badge">` 元素，可以很醒目的展示新的或未读的信息条目。

```html
<div class="container">
    <ul class="list-group">
        <li class="list-group-item">
            <span class="badge">14</span>
            Cras justo odio
        </li>
        <li class="list-group-item">
            <span class="badge">2</span>
            Dapibus ac facilisis in
        </li>
        <li class="list-group-item">Morbi leo risus</li>
    </ul>
</div>
```

## 路径导航

在一个带有层次的导航结构中标明当前页面的位置。

```html
<div class="container">
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li><a href="#">Library</a></li>
        <li class="active">Data</li>
    </ol>
</div>
```

## 标签

为具有特定含义的文本设置为标签样式。标签具有一个基类（`label`）和一个修饰类（`label-*`），修饰类预定义以下几种 `class` 即可改变标签的外观。

| class 名称 | 描述 |
| --- | --- |
| label-default | 默认样式 |
| label-primary | 首选项样式 |
| label-success | 成功样式 |
| label-info | 信息样式 |
| label-warning | 警告样式 |
| label-danger | 危险样式 |

```html
<div class="container">
    <span class="label label-default">Default</span>
    <span class="label label-primary">Primary</span>
    <span class="label label-success">Success</span>
    <span class="label label-info">Info</span>
    <span class="label label-warning">Warning</span>
    <span class="label label-danger">Danger</span>
</div>
```

## Well

把 Well 用在元素上，能有嵌入（inset）的简单效果。一般用于文章的导读等功能。

Well 由一个基类（`well`）和一个修饰类（`well-*`）组成。

| class 名称 | 描述 |
| --- | --- |
| well-lg | 大边距样式 |
| well-sm | 小边距样式 |

```html
<div class="container">
    <div class="well">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Animi commodi, corporis debitis doloremque harum illo ipsam ipsum itaque labore minima non obcaecati qui quis quos recusandae reiciendis sunt unde ut.</div>
    <div class="well well-lg">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Accusamus ad assumenda atque beatae debitis ducimus esse explicabo fuga, id ipsum maiores nobis non odio pariatur quae quos rerum sequi voluptas.</div>
</div>
```

## 巨幕

这是一个轻量、灵活的组件，它能延伸至整个浏览器视口来展示网站上的关键内容。

```html
<div class="container">
    <div class="jumbotron">
        <h1>Hello, world!</h1>
        <p>This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.</p>
        <p><a class="btn btn-primary btn-lg" href="#" role="button">Learn more</a></p>
    </div>
</div>
```

## 页头

页头组件能够为 h1 标签增加适当的空间，并且与页面的其他部分形成一定的分隔。

```html
<div class="page-header">
  <h1>Example page header <small>Subtext for header</small></h1>
</div>
```

## 分页

### 1）分页

Bootstrap 提供的分页由以下两组元素组成：

* `<nav>`元素作为分页的容器元素。
* 使用无序列表作为分页的成员元素，并为 `<ul>` 元素设置 `class` 为 `pagination`。

```html
<div class="container">
    <nav>
        <ul class="pagination">
            <li>
                <a href="#" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            <li><a href="#">1</a></li>
            <li><a href="#">2</a></li>
            <li><a href="#">3</a></li>
            <li><a href="#">4</a></li>
            <li><a href="#">5</a></li>
            <li>
                <a href="#" aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
        </ul>
    </nav>
</div>
```

另外，通过为 `<ul>` 元素添加 `.pagination-lg` 或 `.pagination-sm` 类提供了额外可供选择的尺寸。

### 2）翻页

用简单的标记和样式，就能做个上一页和下一页的简单翻页。用在像博客和杂志这样的简单站点上效果会很好。

```html
<div class="container">
    <nav>
        <ul class="pager">
            <li><a href="#">Previous</a></li>
            <li><a href="#">Next</a></li>
        </ul>
    </nav>
</div>
```