jQuery UI 能做的事可谓是包罗万象。实际上，jQuery UI 在某种意义上并不是插件，而是一个完整的插件库。

jQuery UI 中主要包含以下几个功能:

- Effect（效果）
- Interactions（交互组件）
- Widget（部件）
- 此外，还为jQuery和核心动画提供了很多高级效果。


## Effect（效果）

### animate() 方法

文档在引入核心效果文件的情况下，扩展的 `.animate()` 方法可接受另外一些样式属性。

扩展后 animate 方法接受以下属性:

- backgroundColor
- borderBottomColor
- borderLeftColor
- borderRightColor
- borderTopColor
- Color
- outlineColor

```javascript
var state = true;
$( "#button" ).click(function() {
	if ( state ) {
		$( "#effect" ).animate({
			backgroundColor: "#aa0000",
			color: "#fff",
			width: 500
		}, 1000 );
	} else {
		$( "#effect" ).animate({
			backgroundColor: "#fff",
			color: "#000",
			width: 240
		}, 1000 );
	}
	state = !state;
});
```

### effect() 方法

```javascript
function runEffect() {
	var selectedEffect = $( "#effectTypes" ).val();

	var options = {};
	if ( selectedEffect === "scale" ) {
		options = { percent: 0 };
	} else if ( selectedEffect === "transfer" ) {
		options = { to: "#button", className: "ui-effects-transfer" };
	} else if ( selectedEffect === "size" ) {
		options = { to: { width: 200, height: 60 } };
	}

	$( "#effect" ).effect( selectedEffect, options, 500, callback );
};

function callback() {
	setTimeout(function() {
		$( "#effect" ).removeAttr( "style" ).hide().fadeIn();
	}, 1000 );
};

$( "#button" ).click(function() {
	runEffect();
	return false;
});
```

## Interactions（交互组件）

### Draggable Widget

Draggable Widget 允许使用鼠标移动元素。

```javascript
<div id="draggable" class="ui-widget-content">
	<p>Drag me around</p>
</div>

<script>
	$( "#draggable" ).draggable();
</script>
```

draggable()的事件:
	
- start：当拖动开始时触发。
- drag：当鼠标在拖动过程中移动时触发。
- stop：当拖动停止时触发。

```javascript
<div id="draggable" class="ui-widget ui-widget-content">

    <p>Drag me to trigger the chain of events.</p>

    <ul class="ui-helper-reset">
        <li id="event-start" class="ui-state-default ui-corner-all"><span class="ui-icon ui-icon-play"></span>"start" invoked <span class="count">0</span>x</li>
        <li id="event-drag" class="ui-state-default ui-corner-all"><span class="ui-icon ui-icon-arrow-4"></span>"drag" invoked <span class="count">0</span>x</li>
        <li id="event-stop" class="ui-state-default ui-corner-all"><span class="ui-icon ui-icon-stop"></span>"stop" invoked <span class="count">0</span>x</li>
    </ul>
</div>

<script>
    var $start_counter = $( "#event-start" ),
            $drag_counter = $( "#event-drag" ),
            $stop_counter = $( "#event-stop" ),
            counts = [ 0, 0, 0 ];

    $( "#draggable" ).draggable({
        start: function() {
            counts[ 0 ]++;
            updateCounterStatus( $start_counter, counts[ 0 ] );
        },
        drag: function() {
            counts[ 1 ]++;
            updateCounterStatus( $drag_counter, counts[ 1 ] );
        },
        stop: function() {
            counts[ 2 ]++;
            updateCounterStatus( $stop_counter, counts[ 2 ] );
        }
    });

    function updateCounterStatus( $event_counter, new_count ) {
        // first update the status visually...
        if ( !$event_counter.hasClass( "ui-state-hover" ) ) {
            $event_counter.addClass( "ui-state-hover" )
                    .siblings().removeClass( "ui-state-hover" );
        }
        // ...then update the numbers
        $( "span.count", $event_counter ).text( new_count );
    }
</script>
```

draggable() 的选项:

- axis：设置只能在x轴或y轴方向拖动。
- containment：设置在某个区域内拖动。
- cursor：设置拖动时鼠标的样式。
- cursorAt：设置鼠标的相对定位。
- handle：设置指定元素触发鼠标按下事件才能拖动。
- cancel：防止在指定元素上拖动。
- revert：当停止拖动时，元素是否被重置到初始位置。
- snap：拖动元素是否吸附在其他元素。
- snapMode：设置拖动元素在指定元素的哪个边缘。
	- snap设置为true时该选项有效。
	- 可选值 - inner|outer|both

```javascript
<div id="draggable1" class="draggable ui-widget-content">
    <p>I can be dragged only vertically</p>
</div>

<div id="draggable2" class="draggable ui-widget-content">
    <p>I can be dragged only horizontally</p>
</div>

<div id="draggable4" class="draggable ui-widget-content">
    <p>I will always stick to the center (relative to the mouse)</p>
</div>

<div id="draggable5" class="draggable ui-widget-content">
    <p class="ui-widget-header">I can be dragged only by this handle</p>
</div>

<div id="draggable6" class="draggable ui-widget-content">
    <p>You can drag me around&hellip;</p>
    <p class="ui-widget-header">&hellip;but you can't drag me by this handle.</p>
</div>

<div id="draggable7" class="draggable ui-widget-content">
    <p>Revert the original</p>
</div>

<div id="draggable8" class="draggable ui-widget-content">
    <p>Default (snap: true), snaps to all other draggable elements</p>
</div>

<div id="draggable9" class="draggable ui-widget-content">
    <p>I only snap to the outer edges of the big box</p>
</div>

<div id="containment-wrapper" class="draggable">
    <div id="draggable3" class="draggable ui-widget-content">
        <p>I'm contained within the box</p>
    </div>
</div>

<script>
    $( "#draggable1" ).draggable({ axis: "y" });
    $( "#draggable2" ).draggable({ axis: "x" });
    $( "#draggable3" ).draggable({ containment: "#containment-wrapper" });
    $( "#draggable4" ).draggable({ cursor: "move", cursorAt: { top: 56, left: 56 } });
    $( "#draggable5" ).draggable({ handle: "p" });
    $( "#draggable6" ).draggable({ cancel: "p.ui-widget-header" });
    $( "#draggable7" ).draggable({ revert: true });
    $( "#draggable8" ).draggable({ snap: true });
    $( "#draggable9" ).draggable({ snap: "#containment-wrapper", snapMode: "outer" });
</script>
```

### Droppable Widget

Droppable Widget 为可拖拽小部件创建目标。

droppable() 的事件:

- drop：该事件在被允许拖放的元素覆盖时触发。

droppable() 的选项:

- accept：指定可拖动的元素可被接受。
- activeClass：被允许拖放的元素覆盖时，改变样式。
- hoverClass：被允许拖放的元素悬停时，改变样式。

```javascript
<div id="draggable-nonvalid" class="ui-widget-content">
    <p>I'm draggable but can't be dropped</p>
</div>

<div id="draggable" class="ui-widget-content">
    <p>Drag me to my target</p>
</div>

<div id="droppable" class="ui-widget-header">
    <p>Drop here</p>
</div>
<script>
    $( "#draggable, #draggable-nonvalid" ).draggable();

    $( "#droppable" ).droppable({
        accept: "#draggable",
        activeClass: "ui-state-hover",
        hoverClass: "ui-state-active",
        drop: function( event, ui ) {
            $( this )
                    .addClass( "ui-state-highlight" )
                    .find( "p" )
                    .html( "Dropped!" );
        }
    });
</script>
```

### Resizeable Widget

Resizeable Widget 使用鼠标改变元素的尺寸。

```javascript
<div id="resizable" class="ui-widget-content">
    <h3 class="ui-widget-header">Resizable</h3>
</div>
<script>
    $( "#resizable" ).resizable();
</script>
```

### Sortable Widget

Sortable Widget 使用鼠标调整列表中或者网格中元素的排序。

```javascript
<ul id="sortable">
    <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 1</li>
    <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 2</li>
    <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 3</li>
    <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 4</li>
    <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 5</li>
    <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 6</li>
    <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 7</li>
</ul>
<script>
    $( "#sortable" ).sortable();
</script>
```

## Widget（部件）

### Accordion Widget

Accordion Widget 把一对标题和内容面板转换成折叠面板。

```javascript
<div id="accordion">
    <h3>Section 1</h3>
    <div>
        <p>
            Mauris mauris ante, blandit et, ultrices a, suscipit eget, quam. Integer
            ut neque. Vivamus nisi metus, molestie vel, gravida in, condimentum sit
            amet, nunc. Nam a nibh. Donec suscipit eros. Nam mi. Proin viverra leo ut
            odio. Curabitur malesuada. Vestibulum a velit eu ante scelerisque vulputate.
        </p>
    </div>
    <h3>Section 2</h3>
    <div>
        <p>
            Sed non urna. Donec et ante. Phasellus eu ligula. Vestibulum sit amet
            purus. Vivamus hendrerit, dolor at aliquet laoreet, mauris turpis porttitor
            velit, faucibus interdum tellus libero ac justo. Vivamus non quam. In
            suscipit faucibus urna.
        </p>
    </div>
    <h3>Section 3</h3>
    <div>
        <p>
            Nam enim risus, molestie et, porta ac, aliquam ac, risus. Quisque lobortis.
            Phasellus pellentesque purus in massa. Aenean in pede. Phasellus ac libero
            ac tellus pellentesque semper. Sed ac felis. Sed commodo, magna quis
            lacinia ornare, quam ante aliquam nisi, eu iaculis leo purus venenatis dui.
        </p>
        <ul>
            <li>List item one</li>
            <li>List item two</li>
            <li>List item three</li>
        </ul>
    </div>
    <h3>Section 4</h3>
    <div>
        <p>
            Cras dictum. Pellentesque habitant morbi tristique senectus et netus
            et malesuada fames ac turpis egestas. Vestibulum ante ipsum primis in
            faucibus orci luctus et ultrices posuere cubilia Curae; Aenean lacinia
            mauris vel est.
        </p>
        <p>
            Suspendisse eu nisl. Nullam ut libero. Integer dignissim consequat lectus.
            Class aptent taciti sociosqu ad litora torquent per conubia nostra, per
            inceptos himenaeos.
        </p>
    </div>
</div>

<script>
    $( "#accordion" ).accordion();
</script>
```

> **值得注意的是:**
> 
> - 使用`<div>`元素作为折叠面板的容器。
> - 使用`<h3>`元素作为折叠面板的标题。
> - 使用`<div>`元素作为折叠面板的内容。

### Autocomplete Widget

Autocomplete Widget 自动完成功能根据用户输入值进行搜索和过滤，让用户快速找到并从预设值列表中选择。

```javascript
<div class="ui-widget">
    <label for="tags">Tags: </label>
    <input id="tags">
</div>
<script>
    var availableTags = [
        "ActionScript",
        "AppleScript",
        "Asp",
        "BASIC",
        "C",
        "C++",
        "Clojure",
        "COBOL",
        "ColdFusion",
        "Erlang",
        "Fortran",
        "Groovy",
        "Haskell",
        "Java",
        "JavaScript",
        "Lisp",
        "Perl",
        "PHP",
        "Python",
        "Ruby",
        "Scala",
        "Scheme"
    ];
    $( "#tags" ).autocomplete({
        source: availableTags
    });
</script>
```

### Datepicker Widget

Datepicker Widget 从弹出框或在线日历选择一个日期。

```javascript
<p>Date: <input type="text" id="datepicker"></p>
<script>
    $( "#datepicker" ).datepicker();
</script>
```

### Dialog Widget

Dialog Widget 在一个交互覆盖层中打开内容。

- 基本对话框示例

```javascript
<div id="dialog" title="Basic dialog">
    <p>This is the default dialog which is useful for displaying information. The dialog window can be moved, resized and closed with the 'x' icon.</p>
</div>
<script>
    $( "#dialog" ).dialog();
</script>
```

- 模式对话框示例

```javascript
<div id="dialog-modal" title="Basic modal dialog">
    <p>Adding the modal overlay screen makes the dialog look more prominent because it dims out the page content.</p>
</div>
<script>
    $( "#dialog-modal" ).dialog({
        modal: true
    });
</script>
```

- 操作对话框示例

```javascript
<div id="dialog" title="Basic dialog">
    <p>This is an animated dialog which is useful for displaying information. The dialog window can be moved, resized and closed with the 'x' icon.</p>
</div>

<button id="opener">Open Dialog</button>

<script>
    $( "#dialog" ).dialog({
        autoOpen: false,
        show: {
            effect: "blind",
            duration: 1000
        },
        hide: {
            effect: "explode",
            duration: 1000
        },
        buttons : {
            "OK": function() {
                $( this ).dialog( "close" );
            },
            Cancel: function() {
                $( this ).dialog( "close" );
            }
        }
    });

    $( "#opener" ).button().click(function() {
        $( "#dialog" ).dialog( "open" );
    });
</script>
```

### Tabs Widget

Tabs Widget 是一种多面板的单内容区，每个面板与列表中的标题相关。

```javascript
<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Nunc tincidunt</a></li>
        <li><a href="#tabs-2">Proin dolor</a></li>
        <li><a href="#tabs-3">Aenean lacinia</a></li>
    </ul>
    <div id="tabs-1">
        <p>Proin elit arcu, rutrum commodo, vehicula tempus, commodo a, risus. Curabitur nec arcu. Donec sollicitudin mi sit amet mauris. Nam elementum quam ullamcorper ante. Etiam aliquet massa et lorem. Mauris dapibus lacus auctor risus. Aenean tempor ullamcorper leo. Vivamus sed magna quis ligula eleifend adipiscing. Duis orci. Aliquam sodales tortor vitae ipsum. Aliquam nulla. Duis aliquam molestie erat. Ut et mauris vel pede varius sollicitudin. Sed ut dolor nec orci tincidunt interdum. Phasellus ipsum. Nunc tristique tempus lectus.</p>
    </div>
    <div id="tabs-2">
        <p>Morbi tincidunt, dui sit amet facilisis feugiat, odio metus gravida ante, ut pharetra massa metus id nunc. Duis scelerisque molestie turpis. Sed fringilla, massa eget luctus malesuada, metus eros molestie lectus, ut tempus eros massa ut dolor. Aenean aliquet fringilla sem. Suspendisse sed ligula in ligula suscipit aliquam. Praesent in eros vestibulum mi adipiscing adipiscing. Morbi facilisis. Curabitur ornare consequat nunc. Aenean vel metus. Ut posuere viverra nulla. Aliquam erat volutpat. Pellentesque convallis. Maecenas feugiat, tellus pellentesque pretium posuere, felis lorem euismod felis, eu ornare leo nisi vel felis. Mauris consectetur tortor et purus.</p>
    </div>
    <div id="tabs-3">
        <p>Mauris eleifend est et turpis. Duis id erat. Suspendisse potenti. Aliquam vulputate, pede vel vehicula accumsan, mi neque rutrum erat, eu congue orci lorem eget lorem. Vestibulum non ante. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Fusce sodales. Quisque eu urna vel enim commodo pellentesque. Praesent eu risus hendrerit ligula tempus pretium. Curabitur lorem enim, pretium nec, feugiat nec, luctus a, lacus.</p>
        <p>Duis cursus. Maecenas ligula eros, blandit nec, pharetra at, semper at, magna. Nullam ac lacus. Nulla facilisi. Praesent viverra justo vitae neque. Praesent blandit adipiscing velit. Suspendisse potenti. Donec mattis, pede vel pharetra blandit, magna ligula faucibus eros, id euismod lacus dolor eget odio. Nam scelerisque. Donec non libero sed nulla mattis commodo. Ut sagittis. Donec nisi lectus, feugiat porttitor, tempor ac, tempor vitae, pede. Aenean vehicula velit eu tellus interdum rutrum. Maecenas commodo. Pellentesque nec elit. Fusce in lacus. Vivamus a libero vitae lectus hendrerit hendrerit.</p>
    </div>
</div>
<script>
    $( "#tabs" ).tabs();
</script>
```

### Tooltip Widget

Tooltip Widget 可自定义的、可主题化的工具提示框，替代原生的工具提示框。

```javascript
<p>
    <label for="age">Your age:</label>
    <input id="age" title="We ask for your age only for statistical purposes.">
</p>
<script>
    $( document ).tooltip();
</script>
```

### Menu Widget

Menu Widget 带有鼠标和键盘交互的用于导航的可主题化菜单。

- 禁用页面中默认的鼠标右键功能。

```javascript
$(document).contextmenu(function (event) {
	event.preventDefault();
});
```

- 自定义鼠标右键菜单。

```javascript
$(document).mousedown(function (event) {
	if(event.button == 2){
		$( "#menu").removeAttr("style").menu().position({
			my: "left top",
			at: "left top",
			of : event,
			collision: "fit"
		});
	}
});
```