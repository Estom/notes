# 简单的图轴自定义

自定义简单绘图的背景，标签和刻度。

```python
import matplotlib.pyplot as plt
```

用 ``plt.figure`` 创建一个 ``matplotlib.figure.Figure`` 实例

```python
fig = plt.figure()
rect = fig.patch # a rectangle instance
rect.set_facecolor('lightgoldenrodyellow')

ax1 = fig.add_axes([0.1, 0.3, 0.4, 0.4])
rect = ax1.patch
rect.set_facecolor('lightslategray')


for label in ax1.xaxis.get_ticklabels():
    # label is a Text instance
    label.set_color('red')
    label.set_rotation(45)
    label.set_fontsize(16)

for line in ax1.yaxis.get_ticklines():
    # line is a Line2D instance
    line.set_color('green')
    line.set_markersize(25)
    line.set_markeredgewidth(3)

plt.show()
```

![简单的图轴自定义示例](https://matplotlib.org/_images/sphx_glr_fig_axes_customize_simple_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axis.Axis.get_ticklabels
matplotlib.axis.Axis.get_ticklines
matplotlib.text.Text.set_rotation
matplotlib.text.Text.set_fontsize
matplotlib.text.Text.set_color
matplotlib.lines.Line2D
matplotlib.lines.Line2D.set_color
matplotlib.lines.Line2D.set_markersize
matplotlib.lines.Line2D.set_markeredgewidth
matplotlib.patches.Patch.set_facecolor
```

## 下载这个示例
            
- [下载python源码: fig_axes_customize_simple.py](https://matplotlib.org/_downloads/fig_axes_customize_simple.py)
- [下载Jupyter notebook: fig_axes_customize_simple.ipynb](https://matplotlib.org/_downloads/fig_axes_customize_simple.ipynb)