# 使用约束布局调整轴的大小

约束布局尝试调整图中子图的大小，以使轴对象和轴上的标签之间不会重叠。

有关详细信息，请参阅 [“约束布局指南”](https://matplotlib.org/tutorials/intermediate/constrainedlayout_guide.html)；有关替代方法，请参阅 [“严格布局”](https://matplotlib.org/tutorials/intermediate/tight_layout_guide.html) 指南。

```python
import matplotlib.pyplot as plt
import itertools
import warnings


def example_plot(ax):
    ax.plot([1, 2])
    ax.set_xlabel('x-label', fontsize=12)
    ax.set_ylabel('y-label', fontsize=12)
    ax.set_title('Title', fontsize=14)
```

如果我们不使用constrained_layout，则标签会重叠轴

```python
fig, axs = plt.subplots(nrows=2, ncols=2, constrained_layout=False)

for ax in axs.flatten():
    example_plot(ax)
```

![约束布局示例](https://matplotlib.org/_images/sphx_glr_demo_constrained_layout_001.png)

添加 ``constrained_layout = True`` 会自动调整。

```python
fig, axs = plt.subplots(nrows=2, ncols=2, constrained_layout=True)

for ax in axs.flatten():
    example_plot(ax)
```

![约束布局示例2](https://matplotlib.org/_images/sphx_glr_demo_constrained_layout_002.png)

下面是使用嵌套gridspecs的更复杂的示例。

```python
fig = plt.figure(constrained_layout=True)

import matplotlib.gridspec as gridspec

gs0 = gridspec.GridSpec(1, 2, figure=fig)

gs1 = gridspec.GridSpecFromSubplotSpec(3, 1, subplot_spec=gs0[0])
for n in range(3):
    ax = fig.add_subplot(gs1[n])
    example_plot(ax)


gs2 = gridspec.GridSpecFromSubplotSpec(2, 1, subplot_spec=gs0[1])
for n in range(2):
    ax = fig.add_subplot(gs2[n])
    example_plot(ax)

plt.show()
```

![约束布局示例3](https://matplotlib.org/_images/sphx_glr_demo_constrained_layout_003.png)

## 参考

此示例中显示了以下函数和方法的用法：

```python
import matplotlib
matplotlib.gridspec.GridSpec
matplotlib.gridspec.GridSpecFromSubplotSpec
```

## 下载这个示例
            
- [下载python源码: demo_constrained_layout.py](https://matplotlib.org/_downloads/demo_constrained_layout.py)
- [下载Jupyter notebook: demo_constrained_layout.ipynb](https://matplotlib.org/_downloads/demo_constrained_layout.ipynb)