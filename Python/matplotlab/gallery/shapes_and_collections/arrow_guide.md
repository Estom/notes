# 箭头指南

向图表添加箭头图像。

箭头通常用于注释图表。本教程介绍如何绘制在绘图上的数据限制发生更改时表现不同的箭头。通常，绘图上的点可以固定在“数据空间”或“显示空间”中。当数据限制被改变时，数据空间中绘制的东西会移动 - 散点图中的点就是一个例子。当数据限制被改变时，在显示空间中绘制的东西保持静止 - 例如图形标题或轴标签。

箭头由头部（可能是尾部）和在起点和终点之间绘制的杆组成，从现在开始称为“锚点”。 这里我们展示了绘制箭头的三个用例，具体取决于是否需要在数据或显示空间中修复头部或锚点：

1. 头部形状固定在显示空间中，锚点固定在数据空间中。
1. 头部形状和锚点固定在展示空间中。
1. 再数据空间中固定的整个图像补丁的程序

下面依次介绍每个用例。

```python
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
x_tail = 0.1
y_tail = 0.1
x_head = 0.9
y_head = 0.9
dx = x_head - x_tail
dy = y_head - y_tail
```

## 头部形状固定在显示空间中，锚点固定在数据空间中

如果要注释绘图，并且如果平移或缩放绘图，则不希望箭头更改形状或位置，这非常有用。请注意，当轴限制发生变化时。

在这种情况下，我们使用 [patches.FancyArrowPatch](https://matplotlib.org/api/_as_gen/matplotlib.patches.FancyArrowPatch.html#matplotlib.patches.FancyArrowPatch)。

请注意，更改轴限制时，箭头形状保持不变，但锚点会移动。

```python
fig, axs = plt.subplots(nrows=2)
arrow = mpatches.FancyArrowPatch((x_tail, y_tail), (dx, dy),
                                 mutation_scale=100)
axs[0].add_patch(arrow)

arrow = mpatches.FancyArrowPatch((x_tail, y_tail), (dx, dy),
                                 mutation_scale=100)
axs[1].add_patch(arrow)
axs[1].set_xlim(0, 2)
axs[1].set_ylim(0, 2)
```

![箭头指南示例](https://matplotlib.org/_images/sphx_glr_arrow_guide_001.png)

## 头部形状和锚点固定在展示空间中

如果要注释绘图，并且如果平移或缩放绘图，则不希望箭头更改形状或位置，这非常有用。

在这种情况下，我们使用 [patches.FancyArrowPatch](https://matplotlib.org/api/_as_gen/matplotlib.patches.FancyArrowPatch.html#matplotlib.patches.FancyArrowPatch) ，并传递关键字参数transform = ax.transAxes，其中ax是我们添加补丁的轴。

请注意，更改轴限制时，箭头形状和位置保持不变。

```python
fig, axs = plt.subplots(nrows=2)
arrow = mpatches.FancyArrowPatch((x_tail, y_tail), (dx, dy),
                                 mutation_scale=100,
                                 transform=axs[0].transAxes)
axs[0].add_patch(arrow)

arrow = mpatches.FancyArrowPatch((x_tail, y_tail), (dx, dy),
                                 mutation_scale=100,
                                 transform=axs[1].transAxes)
axs[1].add_patch(arrow)
axs[1].set_xlim(0, 2)
axs[1].set_ylim(0, 2)
```

![箭头指南2](https://matplotlib.org/_images/sphx_glr_arrow_guide_002.png)

## 头部形状和锚点固定在数据空间中

在这种情况下，我们使用 [patches.Arrow](https://matplotlib.org/api/_as_gen/matplotlib.patches.Arrow.html#matplotlib.patches.Arrow)

请注意，更改轴限制时，箭头形状和位置会发生变化。

```python
fig, axs = plt.subplots(nrows=2)

arrow = mpatches.Arrow(x_tail, y_tail, dx, dy)
axs[0].add_patch(arrow)

arrow = mpatches.Arrow(x_tail, y_tail, dx, dy)
axs[1].add_patch(arrow)
axs[1].set_xlim(0, 2)
axs[1].set_ylim(0, 2)
```

![箭头指南3](https://matplotlib.org/_images/sphx_glr_arrow_guide_003.png)

```python
plt.show()
```

## 下载这个示例
            
- [下载python源码: arrow_guide.py](https://matplotlib.org/_downloads/arrow_guide.py)
- [下载Jupyter notebook: arrow_guide.ipynb](https://matplotlib.org/_downloads/arrow_guide.ipynb)