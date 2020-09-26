# 0.99版本新增Spines对象

```python
import matplotlib.pyplot as plt
import numpy as np


def adjust_spines(ax,spines):
    for loc, spine in ax.spines.items():
        if loc in spines:
            spine.set_position(('outward',10)) # outward by 10 points
        else:
            spine.set_color('none') # don't draw spine

    # turn off ticks where there is no spine
    if 'left' in spines:
        ax.yaxis.set_ticks_position('left')
    else:
        # no yaxis ticks
        ax.yaxis.set_ticks([])

    if 'bottom' in spines:
        ax.xaxis.set_ticks_position('bottom')
    else:
        # no xaxis ticks
        ax.xaxis.set_ticks([])

fig = plt.figure()

x = np.linspace(0,2*np.pi,100)
y = 2*np.sin(x)

ax = fig.add_subplot(2,2,1)
ax.plot(x,y)
adjust_spines(ax,['left'])

ax = fig.add_subplot(2,2,2)
ax.plot(x,y)
adjust_spines(ax,[])

ax = fig.add_subplot(2,2,3)
ax.plot(x,y)
adjust_spines(ax,['left','bottom'])

ax = fig.add_subplot(2,2,4)
ax.plot(x,y)
adjust_spines(ax,['bottom'])

plt.show()
```

![Spines对象绘图示例](https://matplotlib.org/_images/sphx_glr_whats_new_99_spines_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axis.Axis.set_ticks
matplotlib.axis.XAxis.set_ticks_position
matplotlib.axis.YAxis.set_ticks_position
matplotlib.spines
matplotlib.spines.Spine
matplotlib.spines.Spine.set_color
matplotlib.spines.Spine.set_position
```

## 下载这个示例
            
- [下载python源码: whats_new_99_spines.py](https://matplotlib.org/_downloads/whats_new_99_spines.py)
- [下载Jupyter notebook: whats_new_99_spines.ipynb](https://matplotlib.org/_downloads/whats_new_99_spines.ipynb)