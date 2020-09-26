# 绘制甜甜圈

Draw donuts (miam!) using [Path](https://matplotlib.org/api/path_api.html#matplotlib.path.Path)s and [PathPatches](https://matplotlib.org/api/_as_gen/matplotlib.patches.PathPatch.html#matplotlib.patches.PathPatch). This example shows the effect of the path's orientations in a compound path.

```python
import numpy as np
import matplotlib.path as mpath
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt


def wise(v):
    if v == 1:
        return "CCW"
    else:
        return "CW"


def make_circle(r):
    t = np.arange(0, np.pi * 2.0, 0.01)
    t = t.reshape((len(t), 1))
    x = r * np.cos(t)
    y = r * np.sin(t)
    return np.hstack((x, y))

Path = mpath.Path

fig, ax = plt.subplots()

inside_vertices = make_circle(0.5)
outside_vertices = make_circle(1.0)
codes = np.ones(
    len(inside_vertices), dtype=mpath.Path.code_type) * mpath.Path.LINETO
codes[0] = mpath.Path.MOVETO

for i, (inside, outside) in enumerate(((1, 1), (1, -1), (-1, 1), (-1, -1))):
    # Concatenate the inside and outside subpaths together, changing their
    # order as needed
    vertices = np.concatenate((outside_vertices[::outside],
                               inside_vertices[::inside]))
    # Shift the path
    vertices[:, 0] += i * 2.5
    # The codes will be all "LINETO" commands, except for "MOVETO"s at the
    # beginning of each subpath
    all_codes = np.concatenate((codes, codes))
    # Create the Path object
    path = mpath.Path(vertices, all_codes)
    # Add plot it
    patch = mpatches.PathPatch(path, facecolor='#885500', edgecolor='black')
    ax.add_patch(patch)

    ax.annotate("Outside %s,\nInside %s" % (wise(outside), wise(inside)),
                (i * 2.5, -1.5), va="top", ha="center")

ax.set_xlim(-2, 10)
ax.set_ylim(-3, 2)
ax.set_title('Mmm, donuts!')
ax.set_aspect(1.0)
plt.show()
```

![绘制甜甜圈示例](https://matplotlib.org/_images/sphx_glr_donut_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.path
matplotlib.path.Path
matplotlib.patches
matplotlib.patches.PathPatch
matplotlib.patches.Circle
matplotlib.axes.Axes.add_patch
matplotlib.axes.Axes.annotate
matplotlib.axes.Axes.set_aspect
matplotlib.axes.Axes.set_xlim
matplotlib.axes.Axes.set_ylim
matplotlib.axes.Axes.set_title
```

## 下载这个示例
            
- [下载python源码: donut.py](https://matplotlib.org/_downloads/donut.py)
- [下载Jupyter notebook: donut.ipynb](https://matplotlib.org/_downloads/donut.ipynb)