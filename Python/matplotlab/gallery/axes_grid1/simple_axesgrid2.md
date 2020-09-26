# 简单的轴线网格2

![简单的轴线网格2](https://matplotlib.org/_images/sphx_glr_simple_axesgrid2_001.png)

```python
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import ImageGrid


def get_demo_image():
    import numpy as np
    from matplotlib.cbook import get_sample_data
    f = get_sample_data("axes_grid/bivariate_normal.npy", asfileobj=False)
    z = np.load(f)
    # z is a numpy array of 15x15
    return z, (-3, 4, -4, 3)

F = plt.figure(1, (5.5, 3.5))
grid = ImageGrid(F, 111,  # similar to subplot(111)
                 nrows_ncols=(1, 3),
                 axes_pad=0.1,
                 add_all=True,
                 label_mode="L",
                 )

Z, extent = get_demo_image()  # demo image

im1 = Z
im2 = Z[:, :10]
im3 = Z[:, 10:]
vmin, vmax = Z.min(), Z.max()
for i, im in enumerate([im1, im2, im3]):
    ax = grid[i]
    ax.imshow(im, origin="lower", vmin=vmin,
              vmax=vmax, interpolation="nearest")

plt.show()
```

## 下载这个示例
            
- [下载python源码: simple_axesgrid2.py](https://matplotlib.org/_downloads/simple_axesgrid2.py)
- [下载Jupyter notebook: simple_axesgrid2.ipynb](https://matplotlib.org/_downloads/simple_axesgrid2.ipynb)