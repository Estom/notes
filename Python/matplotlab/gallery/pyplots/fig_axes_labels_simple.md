# 简单的图轴标记

标记图的轴。

```python
import numpy as np
import matplotlib.pyplot as plt

fig = plt.figure()
fig.subplots_adjust(top=0.8)
ax1 = fig.add_subplot(211)
ax1.set_ylabel('volts')
ax1.set_title('a sine wave')

t = np.arange(0.0, 1.0, 0.01)
s = np.sin(2*np.pi*t)
line, = ax1.plot(t, s, color='blue', lw=2)

# Fixing random state for reproducibility
np.random.seed(19680801)

ax2 = fig.add_axes([0.15, 0.1, 0.7, 0.3])
n, bins, patches = ax2.hist(np.random.randn(1000), 50,
    facecolor='yellow', edgecolor='yellow')
ax2.set_xlabel('time (s)')

plt.show()
```

![简单的图轴标记示例](https://matplotlib.org/_images/sphx_glr_fig_axes_labels_simple_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.set_xlabel
matplotlib.axes.Axes.set_ylabel
matplotlib.axes.Axes.set_title
matplotlib.axes.Axes.plot
matplotlib.axes.Axes.hist
matplotlib.figure.Figure.add_axes
```

## 下载这个示例
            
- [下载python源码: fig_axes_labels_simple.py](https://matplotlib.org/_downloads/fig_axes_labels_simple.py)
- [下载Jupyter notebook: fig_axes_labels_simple.ipynb](https://matplotlib.org/_downloads/fig_axes_labels_simple.ipynb)

