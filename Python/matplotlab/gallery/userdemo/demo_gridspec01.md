# Gridspec演示01

![Gridspec演示01](https://matplotlib.org/_images/sphx_glr_demo_gridspec01_000.png)

```python
import matplotlib.pyplot as plt


def make_ticklabels_invisible(fig):
    for i, ax in enumerate(fig.axes):
        ax.text(0.5, 0.5, "ax%d" % (i+1), va="center", ha="center")
        ax.tick_params(labelbottom=False, labelleft=False)


fig = plt.figure(0)
ax1 = plt.subplot2grid((3, 3), (0, 0), colspan=3)
ax2 = plt.subplot2grid((3, 3), (1, 0), colspan=2)
ax3 = plt.subplot2grid((3, 3), (1, 2), rowspan=2)
ax4 = plt.subplot2grid((3, 3), (2, 0))
ax5 = plt.subplot2grid((3, 3), (2, 1))

fig.suptitle("subplot2grid")
make_ticklabels_invisible(fig)

plt.show()
```

## 下载这个示例
            
- [下载python源码: demo_gridspec01.py](https://matplotlib.org/_downloads/demo_gridspec01.py)
- [下载Jupyter notebook: demo_gridspec01.ipynb](https://matplotlib.org/_downloads/demo_gridspec01.ipynb)