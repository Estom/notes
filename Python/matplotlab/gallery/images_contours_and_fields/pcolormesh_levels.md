# pcolormesh

演示如何组合Normalization和Colormap实例以在[pcolor()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.pcolor.html#matplotlib.axes.Axes.pcolor)，[pcolormesh()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.pcolormesh.html#matplotlib.axes.Axes.pcolormesh)和[imshow()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.imshow.html#matplotlib.axes.Axes.imshow)类型图中绘制“级别”，其方式与contour / contourf的levels关键字参数类似。

```python
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator
import numpy as np


# make these smaller to increase the resolution
dx, dy = 0.05, 0.05

# generate 2 2d grids for the x & y bounds
y, x = np.mgrid[slice(1, 5 + dy, dy),
                slice(1, 5 + dx, dx)]

z = np.sin(x)**10 + np.cos(10 + y*x) * np.cos(x)

# x and y are bounds, so z should be the value *inside* those bounds.
# Therefore, remove the last value from the z array.
z = z[:-1, :-1]
levels = MaxNLocator(nbins=15).tick_values(z.min(), z.max())


# pick the desired colormap, sensible levels, and define a normalization
# instance which takes data values and translates those into levels.
cmap = plt.get_cmap('PiYG')
norm = BoundaryNorm(levels, ncolors=cmap.N, clip=True)

fig, (ax0, ax1) = plt.subplots(nrows=2)

im = ax0.pcolormesh(x, y, z, cmap=cmap, norm=norm)
fig.colorbar(im, ax=ax0)
ax0.set_title('pcolormesh with levels')


# contours are *point* based plots, so convert our bound into point
# centers
cf = ax1.contourf(x[:-1, :-1] + dx/2.,
                  y[:-1, :-1] + dy/2., z, levels=levels,
                  cmap=cmap)
fig.colorbar(cf, ax=ax1)
ax1.set_title('contourf with levels')

# adjust spacing between subplots so `ax1` title and `ax0` tick labels
# don't overlap
fig.tight_layout()

plt.show()
```

![pcolormesh示例](https://matplotlib.org/_images/sphx_glr_pcolormesh_levels_001.png)

## 参考

下面的示例演示了以下函数和方法的使用：

```python
matplotlib.axes.Axes.pcolormesh
matplotlib.pyplot.pcolormesh
matplotlib.axes.Axes.contourf
matplotlib.pyplot.contourf
matplotlib.figure.Figure.colorbar
matplotlib.pyplot.colorbar
matplotlib.colors.BoundaryNorm
matplotlib.ticker.MaxNLocator
```

## 下载这个示例

- [下载python源码: pcolormesh_levels.py](https://matplotlib.org/_downloads/pcolormesh_levels.py)
- [下载Jupyter notebook: pcolormesh_levels.ipynb](https://matplotlib.org/_downloads/pcolormesh_levels.ipynb)