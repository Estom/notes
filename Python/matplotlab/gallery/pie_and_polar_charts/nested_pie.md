# 嵌套饼图

以下示例显示了在Matplotlib中构建嵌套饼图的两种方法。 这些图表通常被称为空心饼图图表。

```python
import matplotlib.pyplot as plt
import numpy as np
```

构建饼图最简单的方法是使用饼图方法[（pie method)](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.pie.html#matplotlib.axes.Axes.pie)。

在这种情况下，pie获取与组中的计数相对应的值。我们将首先生成一些假数据，对应三组。在内圈中，我们将每个数字视为属于自己的组。 在外圈，我们将它们绘制为原始3组的成员。

空心饼图形状的效果是通过``wedgeprops``参数设置馅饼楔形的``宽度``来实现的。

```python
fig, ax = plt.subplots()

size = 0.3
vals = np.array([[60., 32.], [37., 40.], [29., 10.]])

cmap = plt.get_cmap("tab20c")
outer_colors = cmap(np.arange(3)*4)
inner_colors = cmap(np.array([1, 2, 5, 6, 9, 10]))

ax.pie(vals.sum(axis=1), radius=1, colors=outer_colors,
       wedgeprops=dict(width=size, edgecolor='w'))

ax.pie(vals.flatten(), radius=1-size, colors=inner_colors,
       wedgeprops=dict(width=size, edgecolor='w'))

ax.set(aspect="equal", title='Pie plot with `ax.pie`')
plt.show()
```

![嵌套饼图示例](https://matplotlib.org/_images/sphx_glr_nested_pie_001.png)

但是，您可以通过在具有极坐标系的轴上使用条形图来完成相同的输出。 这可以为绘图的精确设计提供更大的灵活性。

在这种情况下，我们需要将条形图的x值映射到圆的弧度。这些值的累积和用作条的边。

```python
fig, ax = plt.subplots(subplot_kw=dict(polar=True))

size = 0.3
vals = np.array([[60., 32.], [37., 40.], [29., 10.]])
#normalize vals to 2 pi
valsnorm = vals/np.sum(vals)*2*np.pi
#obtain the ordinates of the bar edges
valsleft = np.cumsum(np.append(0, valsnorm.flatten()[:-1])).reshape(vals.shape)

cmap = plt.get_cmap("tab20c")
outer_colors = cmap(np.arange(3)*4)
inner_colors = cmap(np.array([1, 2, 5, 6, 9, 10]))

ax.bar(x=valsleft[:, 0],
       width=valsnorm.sum(axis=1), bottom=1-size, height=size,
       color=outer_colors, edgecolor='w', linewidth=1, align="edge")

ax.bar(x=valsleft.flatten(),
       width=valsnorm.flatten(), bottom=1-2*size, height=size,
       color=inner_colors, edgecolor='w', linewidth=1, align="edge")

ax.set(title="Pie plot with `ax.bar` and polar coordinates")
ax.set_axis_off()
plt.show()
```

![嵌套饼图示例2](https://matplotlib.org/_images/sphx_glr_nested_pie_002.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.pie
matplotlib.pyplot.pie
matplotlib.axes.Axes.bar
matplotlib.pyplot.bar
matplotlib.projections.polar
matplotlib.axes.Axes.set
matplotlib.axes.Axes.set_axis_off
```

## 下载这个示例
            
- [下载python源码: nested_pie.py](https://matplotlib.org/_downloads/nested_pie.py)
- [下载Jupyter notebook: nested_pie.ipynb](https://matplotlib.org/_downloads/nested_pie.ipynb)