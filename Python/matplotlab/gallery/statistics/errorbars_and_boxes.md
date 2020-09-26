# 使用PatchCollection在误差图中创建箱型图

在这个例子中，我们通过在x方向和y方向上添加由条形极限定义的矩形块来拼写一个非常标准的误差条形图。为此，我们必须编写自己的自定义函数 ``make_error_boxes``。仔细检查此函数将揭示matplotlib编写函数的首选模式：

1. an Axes object is passed directly to the function
1. the function operates on the Axes methods directly, not through the ``pyplot`` interface
1. plotting kwargs that could be abbreviated are spelled out for better code readability in the future (for example we use ``facecolor`` instead of fc)
1. the artists returned by the Axes plotting methods are then returned by the function so that, if desired, their styles can be modified later outside of the function (they are not modified in this example).

![创建箱型图示例](https://matplotlib.org/_images/sphx_glr_errorbars_and_boxes_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.collections import PatchCollection
from matplotlib.patches import Rectangle

# Number of data points
n = 5

# Dummy data
np.random.seed(19680801)
x = np.arange(0, n, 1)
y = np.random.rand(n) * 5.

# Dummy errors (above and below)
xerr = np.random.rand(2, n) + 0.1
yerr = np.random.rand(2, n) + 0.2


def make_error_boxes(ax, xdata, ydata, xerror, yerror, facecolor='r',
                     edgecolor='None', alpha=0.5):

    # Create list for all the error patches
    errorboxes = []

    # Loop over data points; create box from errors at each point
    for x, y, xe, ye in zip(xdata, ydata, xerror.T, yerror.T):
        rect = Rectangle((x - xe[0], y - ye[0]), xe.sum(), ye.sum())
        errorboxes.append(rect)

    # Create patch collection with specified colour/alpha
    pc = PatchCollection(errorboxes, facecolor=facecolor, alpha=alpha,
                         edgecolor=edgecolor)

    # Add collection to axes
    ax.add_collection(pc)

    # Plot errorbars
    artists = ax.errorbar(xdata, ydata, xerr=xerror, yerr=yerror,
                          fmt='None', ecolor='k')

    return artists


# Create figure and axes
fig, ax = plt.subplots(1)

# Call function to create error boxes
_ = make_error_boxes(ax, x, y, xerr, yerr)

plt.show()
```

## 下载这个示例
            
- [下载python源码: errorbars_and_boxes.py](https://matplotlib.org/_downloads/errorbars_and_boxes.py)
- [下载Jupyter notebook: errorbars_and_boxes.ipynb](https://matplotlib.org/_downloads/errorbars_and_boxes.ipynb)