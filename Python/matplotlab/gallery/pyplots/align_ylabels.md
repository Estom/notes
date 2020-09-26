# 对齐y标签

这里显示了两种方法，一种是使用对 [Figure.align_ylabels](https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.align_ylabels) 的简短调用，另一种是使用手动方式来对齐标签。

```python
import numpy as np
import matplotlib.pyplot as plt


def make_plot(axs):
    box = dict(facecolor='yellow', pad=5, alpha=0.2)

    # Fixing random state for reproducibility
    np.random.seed(19680801)
    ax1 = axs[0, 0]
    ax1.plot(2000*np.random.rand(10))
    ax1.set_title('ylabels not aligned')
    ax1.set_ylabel('misaligned 1', bbox=box)
    ax1.set_ylim(0, 2000)

    ax3 = axs[1, 0]
    ax3.set_ylabel('misaligned 2', bbox=box)
    ax3.plot(np.random.rand(10))

    ax2 = axs[0, 1]
    ax2.set_title('ylabels aligned')
    ax2.plot(2000*np.random.rand(10))
    ax2.set_ylabel('aligned 1', bbox=box)
    ax2.set_ylim(0, 2000)

    ax4 = axs[1, 1]
    ax4.plot(np.random.rand(10))
    ax4.set_ylabel('aligned 2', bbox=box)


# Plot 1:
fig, axs = plt.subplots(2, 2)
fig.subplots_adjust(left=0.2, wspace=0.6)
make_plot(axs)

# just align the last column of axes:
fig.align_ylabels(axs[:, 1])
plt.show()
```

![对齐y标签示例](https://matplotlib.org/_images/sphx_glr_align_ylabels_0011.png)

> 另见 Figure.align_ylabels and Figure.align_labels for a direct method of doing the same thing. Also Aligning Labels

或者，我们可以使用y轴对象的set_label_coords方法手动在子图之间手动对齐轴标签。请注意，这需要我们知道硬编码的良好偏移值。

```python
fig, axs = plt.subplots(2, 2)
fig.subplots_adjust(left=0.2, wspace=0.6)

make_plot(axs)

labelx = -0.3  # axes coords

for j in range(2):
    axs[j, 1].yaxis.set_label_coords(labelx, 0.5)

plt.show()
```

![对齐y标签示例2](https://matplotlib.org/_images/sphx_glr_align_ylabels_002.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.figure.Figure.align_ylabels
matplotlib.axis.Axis.set_label_coords
matplotlib.axes.Axes.plot
matplotlib.pyplot.plot
matplotlib.axes.Axes.set_title
matplotlib.axes.Axes.set_ylabel
matplotlib.axes.Axes.set_ylim
```

## 下载这个示例
            
- [下载python源码: align_ylabels.py](https://matplotlib.org/_downloads/align_ylabels.py)
- [下载Jupyter notebook: align_ylabels.ipynb](https://matplotlib.org/_downloads/align_ylabels.ipynb)