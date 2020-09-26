# Pcolor 演示

使用[pcolor()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.pcolor.html#matplotlib.axes.Axes.pcolor)生成图像。

Pcolor允许您生成二维图像样式图。 下面我们将在Matplotlib中展示如何做到这一点。

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import LogNorm
```

## 一个简单的 pcolor 示例

```python
Z = np.random.rand(6, 10)

fig, (ax0, ax1) = plt.subplots(2, 1)

c = ax0.pcolor(Z)
ax0.set_title('default: no edges')

c = ax1.pcolor(Z, edgecolors='k', linewidths=4)
ax1.set_title('thick edges')

fig.tight_layout()
plt.show()
```

![Pcolor 演示](https://matplotlib.org/_images/sphx_glr_pcolor_demo_001.png)

## 比较pcolor与类似的功能

Demonstrates similarities between pcolor(), pcolormesh(), imshow() and pcolorfast() for drawing quadrilateral grids.

```python
# make these smaller to increase the resolution
dx, dy = 0.15, 0.05

# generate 2 2d grids for the x & y bounds
y, x = np.mgrid[slice(-3, 3 + dy, dy),
                slice(-3, 3 + dx, dx)]
z = (1 - x / 2. + x ** 5 + y ** 3) * np.exp(-x ** 2 - y ** 2)
# x and y are bounds, so z should be the value *inside* those bounds.
# Therefore, remove the last value from the z array.
z = z[:-1, :-1]
z_min, z_max = -np.abs(z).max(), np.abs(z).max()

fig, axs = plt.subplots(2, 2)

ax = axs[0, 0]
c = ax.pcolor(x, y, z, cmap='RdBu', vmin=z_min, vmax=z_max)
ax.set_title('pcolor')
# set the limits of the plot to the limits of the data
ax.axis([x.min(), x.max(), y.min(), y.max()])
fig.colorbar(c, ax=ax)

ax = axs[0, 1]
c = ax.pcolormesh(x, y, z, cmap='RdBu', vmin=z_min, vmax=z_max)
ax.set_title('pcolormesh')
# set the limits of the plot to the limits of the data
ax.axis([x.min(), x.max(), y.min(), y.max()])
fig.colorbar(c, ax=ax)

ax = axs[1, 0]
c = ax.imshow(z, cmap='RdBu', vmin=z_min, vmax=z_max,
              extent=[x.min(), x.max(), y.min(), y.max()],
              interpolation='nearest', origin='lower')
ax.set_title('image (nearest)')
fig.colorbar(c, ax=ax)

ax = axs[1, 1]
c = ax.pcolorfast(x, y, z, cmap='RdBu', vmin=z_min, vmax=z_max)
ax.set_title('pcolorfast')
fig.colorbar(c, ax=ax)

fig.tight_layout()
plt.show()
```

![Pcolor 演示2](https://matplotlib.org/_images/sphx_glr_pcolor_demo_002.png)

## Pcolor具有对数刻度

以下显示了具有对数刻度的pcolor图。

```python
N = 100
X, Y = np.mgrid[-3:3:complex(0, N), -2:2:complex(0, N)]

# A low hump with a spike coming out.
# Needs to have z/colour axis on a log scale so we see both hump and spike.
# linear scale only shows the spike.
Z1 = np.exp(-(X)**2 - (Y)**2)
Z2 = np.exp(-(X * 10)**2 - (Y * 10)**2)
Z = Z1 + 50 * Z2

fig, (ax0, ax1) = plt.subplots(2, 1)

c = ax0.pcolor(X, Y, Z,
               norm=LogNorm(vmin=Z.min(), vmax=Z.max()), cmap='PuBu_r')
fig.colorbar(c, ax=ax0)

c = ax1.pcolor(X, Y, Z, cmap='PuBu_r')
fig.colorbar(c, ax=ax1)

plt.show()
```

![Pcolor 演示3](https://matplotlib.org/_images/sphx_glr_pcolor_demo_003.png)

## 参考

本例中显示了以下函数、方法和类的使用：

```python
import matplotlib
matplotlib.axes.Axes.pcolor
matplotlib.pyplot.pcolor
matplotlib.axes.Axes.pcolormesh
matplotlib.pyplot.pcolormesh
matplotlib.axes.Axes.pcolorfast
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
matplotlib.figure.Figure.colorbar
matplotlib.pyplot.colorbar
matplotlib.colors.LogNorm
```

## 下载这个示例

- [下载python源码: pcolor_demo.py](https://matplotlib.org/_downloads/pcolor_demo.py)
- [下载Jupyter notebook: pcolor_demo.ipynb](https://matplotlib.org/_downloads/pcolor_demo.ipynb)
