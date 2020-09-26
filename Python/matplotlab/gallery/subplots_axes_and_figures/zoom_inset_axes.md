# 缩放区域嵌入轴

插入轴的示例和显示缩放位置的矩形。

```python
import matplotlib.pyplot as plt
import numpy as np


def get_demo_image():
    from matplotlib.cbook import get_sample_data
    import numpy as np
    f = get_sample_data("axes_grid/bivariate_normal.npy", asfileobj=False)
    z = np.load(f)
    # z is a numpy array of 15x15
    return z, (-3, 4, -4, 3)

fig, ax = plt.subplots(figsize=[5, 4])

# make data
Z, extent = get_demo_image()
Z2 = np.zeros([150, 150], dtype="d")
ny, nx = Z.shape
Z2[30:30 + ny, 30:30 + nx] = Z

ax.imshow(Z2, extent=extent, interpolation="nearest",
          origin="lower")

# inset axes....
axins = ax.inset_axes([0.5, 0.5, 0.47, 0.47])
axins.imshow(Z2, extent=extent, interpolation="nearest",
          origin="lower")
# sub region of the original image
x1, x2, y1, y2 = -1.5, -0.9, -2.5, -1.9
axins.set_xlim(x1, x2)
axins.set_ylim(y1, y2)
axins.set_xticklabels('')
axins.set_yticklabels('')

ax.indicate_inset_zoom(axins)

plt.show()
```

![缩放区域嵌入轴示例](https://matplotlib.org/_images/sphx_glr_zoom_inset_axes_001.png)

## 参考

此示例中显示了以下函数和方法的用法：

```python
import matplotlib
matplotlib.axes.Axes.inset_axes
matplotlib.axes.Axes.indicate_inset_zoom
matplotlib.axes.Axes.imshow
```

## 下载这个示例
            
- [下载python源码: zoom_inset_axes.py](https://matplotlib.org/_downloads/zoom_inset_axes.py)
- [下载Jupyter notebook: zoom_inset_axes.ipynb](https://matplotlib.org/_downloads/zoom_inset_axes.ipynb)