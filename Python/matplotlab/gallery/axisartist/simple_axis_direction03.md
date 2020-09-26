# 简单轴方向03

![简单轴方向03](https://matplotlib.org/_images/sphx_glr_simple_axis_direction03_001.png)

```python
import matplotlib.pyplot as plt
import mpl_toolkits.axisartist as axisartist


def setup_axes(fig, rect):
    ax = axisartist.Subplot(fig, rect)
    fig.add_subplot(ax)

    ax.set_yticks([0.2, 0.8])
    ax.set_xticks([0.2, 0.8])

    return ax


fig = plt.figure(1, figsize=(5, 2))
fig.subplots_adjust(wspace=0.4, bottom=0.3)

ax1 = setup_axes(fig, "121")
ax1.set_xlabel("X-label")
ax1.set_ylabel("Y-label")

ax1.axis[:].invert_ticklabel_direction()

ax2 = setup_axes(fig, "122")
ax2.set_xlabel("X-label")
ax2.set_ylabel("Y-label")

ax2.axis[:].major_ticks.set_tick_out(True)

plt.show()
```

## 下载这个示例
            
- [下载python源码: simple_axis_direction03.py](https://matplotlib.org/_downloads/simple_axis_direction03.py)
- [下载Jupyter notebook: simple_axis_direction03.ipynb](https://matplotlib.org/_downloads/simple_axis_direction03.ipynb)