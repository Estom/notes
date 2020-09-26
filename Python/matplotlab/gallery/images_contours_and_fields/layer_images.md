# 图层图像

使用Alpha混合将图像层叠在彼此之上

```python
import matplotlib.pyplot as plt
import numpy as np


def func3(x, y):
    return (1 - x / 2 + x**5 + y**3) * np.exp(-(x**2 + y**2))


# make these smaller to increase the resolution
dx, dy = 0.05, 0.05

x = np.arange(-3.0, 3.0, dx)
y = np.arange(-3.0, 3.0, dy)
X, Y = np.meshgrid(x, y)

# when layering multiple images, the images need to have the same
# extent.  This does not mean they need to have the same shape, but
# they both need to render to the same coordinate system determined by
# xmin, xmax, ymin, ymax.  Note if you use different interpolations
# for the images their apparent extent could be different due to
# interpolation edge effects

extent = np.min(x), np.max(x), np.min(y), np.max(y)
fig = plt.figure(frameon=False)

Z1 = np.add.outer(range(8), range(8)) % 2  # chessboard
im1 = plt.imshow(Z1, cmap=plt.cm.gray, interpolation='nearest',
                 extent=extent)

Z2 = func3(X, Y)

im2 = plt.imshow(Z2, cmap=plt.cm.viridis, alpha=.9, interpolation='bilinear',
                 extent=extent)

plt.show()
```

![图层图像示例](https://matplotlib.org/_images/sphx_glr_layer_images_001.png)

## 参考

此示例中显示了以下函数和方法的用法：

```python
import matplotlib
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
```

## 下载这个示例

- [下载python源码: layer_images.py](https://matplotlib.org/_downloads/layer_images.py)
- [下载Jupyter notebook: layer_images.ipynb](https://matplotlib.org/_downloads/layer_images.ipynb)