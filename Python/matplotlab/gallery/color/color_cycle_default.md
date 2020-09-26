# 默认属性循环中的颜色

显示默认prop_cycle中的颜色，该颜色是从[rc参数](https://matplotlib.org/tutorials/introductory/customizing.html)中获取的。

```python
import numpy as np
import matplotlib.pyplot as plt


prop_cycle = plt.rcParams['axes.prop_cycle']
colors = prop_cycle.by_key()['color']

lwbase = plt.rcParams['lines.linewidth']
thin = lwbase / 2
thick = lwbase * 3

fig, axs = plt.subplots(nrows=2, ncols=2, sharex=True, sharey=True)
for icol in range(2):
    if icol == 0:
        lwx, lwy = thin, lwbase
    else:
        lwx, lwy = lwbase, thick
    for irow in range(2):
        for i, color in enumerate(colors):
            axs[irow, icol].axhline(i, color=color, lw=lwx)
            axs[irow, icol].axvline(i, color=color, lw=lwy)

    axs[1, icol].set_facecolor('k')
    axs[1, icol].xaxis.set_ticks(np.arange(0, 10, 2))
    axs[0, icol].set_title('line widths (pts): %g, %g' % (lwx, lwy),
                           fontsize='medium')

for irow in range(2):
    axs[irow, 0].yaxis.set_ticks(np.arange(0, 10, 2))

fig.suptitle('Colors in the default prop_cycle', fontsize='large')

plt.show()
```

![默认属性循环中的颜色示例](https://matplotlib.org/_images/sphx_glr_color_cycle_default_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.axhline
matplotlib.axes.Axes.axvline
matplotlib.pyplot.axhline
matplotlib.pyplot.axvline
matplotlib.axes.Axes.set_facecolor
matplotlib.figure.Figure.suptitle
```

## 下载这个示例
            
- [下载python源码: color_cycle_default.py](https://matplotlib.org/_downloads/color_cycle_default.py)
- [下载Jupyter notebook: color_cycle_default.ipynb](https://matplotlib.org/_downloads/color_cycle_default.ipynb)