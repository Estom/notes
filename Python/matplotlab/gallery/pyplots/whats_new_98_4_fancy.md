# 0.98.4版本新的炫酷特性

创建精美的盒子和箭头样式。

```python
import matplotlib.patches as mpatch
import matplotlib.pyplot as plt

figheight = 8
fig = plt.figure(1, figsize=(9, figheight), dpi=80)
fontsize = 0.4 * fig.dpi

def make_boxstyles(ax):
    styles = mpatch.BoxStyle.get_styles()

    for i, (stylename, styleclass) in enumerate(sorted(styles.items())):
        ax.text(0.5, (float(len(styles)) - 0.5 - i)/len(styles), stylename,
                  ha="center",
                  size=fontsize,
                  transform=ax.transAxes,
                  bbox=dict(boxstyle=stylename, fc="w", ec="k"))

def make_arrowstyles(ax):
    styles = mpatch.ArrowStyle.get_styles()

    ax.set_xlim(0, 4)
    ax.set_ylim(0, figheight)

    for i, (stylename, styleclass) in enumerate(sorted(styles.items())):
        y = (float(len(styles)) -0.25 - i) # /figheight
        p = mpatch.Circle((3.2, y), 0.2, fc="w")
        ax.add_patch(p)

        ax.annotate(stylename, (3.2, y),
                    (2., y),
                    #xycoords="figure fraction", textcoords="figure fraction",
                    ha="right", va="center",
                    size=fontsize,
                    arrowprops=dict(arrowstyle=stylename,
                                    patchB=p,
                                    shrinkA=5,
                                    shrinkB=5,
                                    fc="w", ec="k",
                                    connectionstyle="arc3,rad=-0.05",
                                    ),
                    bbox=dict(boxstyle="square", fc="w"))

    ax.xaxis.set_visible(False)
    ax.yaxis.set_visible(False)


ax1 = fig.add_subplot(121, frameon=False, xticks=[], yticks=[])
make_boxstyles(ax1)

ax2 = fig.add_subplot(122, frameon=False, xticks=[], yticks=[])
make_arrowstyles(ax2)


plt.show()
```

![新特性示例](https://matplotlib.org/_images/sphx_glr_whats_new_98_4_fancy_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.patches
matplotlib.patches.BoxStyle
matplotlib.patches.BoxStyle.get_styles
matplotlib.patches.ArrowStyle
matplotlib.patches.ArrowStyle.get_styles
matplotlib.axes.Axes.text
matplotlib.axes.Axes.annotate
```

## 下载这个示例
            
- [下载python源码: whats_new_98_4_fancy.py](https://matplotlib.org/_downloads/whats_new_98_4_fancy.py)
- [下载Jupyter notebook: whats_new_98_4_fancy.ipynb](https://matplotlib.org/_downloads/whats_new_98_4_fancy.ipynb)