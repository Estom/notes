render 使用模板进行渲染

redirect
重定向到一个新的url，也就是说我当前没有渲染的视图，我交给另外一个动作来处理，我提供动作必要的参数。所以传递参数到视图的过程绝对不应该用redirect，而是render。

redirect有多种形式。可以是绝对路径、相对路径、动作（视图）名称 + 必要的参数
