# 事件处理

Matplotlib支持使用GUI中立事件模型进行[事件处理](https://matplotlib.org/users/event_handling.html)，因此您可以连接到Matplotlib事件，而无需了解Matplotlib最终将插入哪个用户界面。 这有两个好处：你编写的代码将更加可移植，Matplotlib事件就像数据坐标空间和事件发生在哪些轴之类的东西，所以你不必混淆低级转换细节来自画布空间到数据空间。还包括对象拾取示例。