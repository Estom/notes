# 嵌套的Gridspecs

GridSpec可以嵌套，因此来自父GridSpec的子图可以设置嵌套的子图网格的位置。

![嵌套的Gridspecs示例](https://matplotlib.org/_images/sphx_glr_gridspec_nested_001.png)

```python
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec


def format_axes(fig):
    for i, ax in enumerate(fig.axes):
        ax.text(0.5, 0.5, "ax%d" % (i+1), va="center", ha="center")
        ax.tick_params(labelbottom=False, labelleft=False)


# gridspec inside gridspec
f = plt.figure()

gs0 = gridspec.GridSpec(1, 2, figure=f)

gs00 = gridspec.GridSpecFromSubplotSpec(3, 3, subplot_spec=gs0[0])

ax1 = plt.Subplot(f, gs00[:-1, :])
f.add_subplot(ax1)
ax2 = plt.Subplot(f, gs00[-1, :-1])
f.add_subplot(ax2)
ax3 = plt.Subplot(f, gs00[-1, -1])
f.add_subplot(ax3)


gs01 = gridspec.GridSpecFromSubplotSpec(3, 3, subplot_spec=gs0[1])

ax4 = plt.Subplot(f, gs01[:, :-1])
f.add_subplot(ax4)
ax5 = plt.Subplot(f, gs01[:-1, -1])
f.add_subplot(ax5)
ax6 = plt.Subplot(f, gs01[-1, -1])
f.add_subplot(ax6)

plt.suptitle("GridSpec Inside GridSpec")
format_axes(f)

plt.show()
```

## 下载这个示例
            
- [下载python源码: gridspec_nested.py](https://matplotlib.org/_downloads/gridspec_nested.py)
- [下载Jupyter notebook: gridspec_nested.ipynb](https://matplotlib.org/_downloads/gridspec_nested.ipynb)