# 多重图像

用单一的彩色地图、标准和颜色条制作一组图像。

```python
from matplotlib import colors
import matplotlib.pyplot as plt
import numpy as np

np.random.seed(19680801)
Nr = 3
Nc = 2
cmap = "cool"

fig, axs = plt.subplots(Nr, Nc)
fig.suptitle('Multiple images')

images = []
for i in range(Nr):
    for j in range(Nc):
        # Generate data with a range that varies from one plot to the next.
        data = ((1 + i + j) / 10) * np.random.rand(10, 20) * 1e-6
        images.append(axs[i, j].imshow(data, cmap=cmap))
        axs[i, j].label_outer()

# Find the min and max of all colors for use in setting the color scale.
vmin = min(image.get_array().min() for image in images)
vmax = max(image.get_array().max() for image in images)
norm = colors.Normalize(vmin=vmin, vmax=vmax)
for im in images:
    im.set_norm(norm)

fig.colorbar(images[0], ax=axs, orientation='horizontal', fraction=.1)


# Make images respond to changes in the norm of other images (e.g. via the
# "edit axis, curves and images parameters" GUI on Qt), but be careful not to
# recurse infinitely!
def update(changed_image):
    for im in images:
        if (changed_image.get_cmap() != im.get_cmap()
                or changed_image.get_clim() != im.get_clim()):
            im.set_cmap(changed_image.get_cmap())
            im.set_clim(changed_image.get_clim())


for im in images:
    im.callbacksSM.connect('changed', update)

plt.show()
```

![多重图像示例](https://matplotlib.org/_images/sphx_glr_multi_image_001.png)

## 参考

本例中显示了以下函数、方法和类的使用：

```python
import matplotlib
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
matplotlib.figure.Figure.colorbar
matplotlib.pyplot.colorbar
matplotlib.colors.Normalize
matplotlib.cm.ScalarMappable.set_cmap
matplotlib.cm.ScalarMappable.set_norm
matplotlib.cm.ScalarMappable.set_clim
matplotlib.cbook.CallbackRegistry.connect
```

## 下载这个示例

- [下载python源码: multi_image.py](https://matplotlib.org/_downloads/multi_image.py)
- [下载Jupyter notebook: multi_image.ipynb](https://matplotlib.org/_downloads/multi_image.ipynb)
