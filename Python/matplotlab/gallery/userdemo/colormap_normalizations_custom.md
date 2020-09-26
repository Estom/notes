# 色彩映射标准化自定义

演示使用规范以非线性方式将颜色映射映射到数据上。

![色彩映射标准化自定义示例](https://matplotlib.org/_images/sphx_glr_colormap_normalizations_custom_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors

N = 100
'''
Custom Norm: An example with a customized normalization.  This one
uses the example above, and normalizes the negative data differently
from the positive.
'''
X, Y = np.mgrid[-3:3:complex(0, N), -2:2:complex(0, N)]
Z1 = np.exp(-X**2 - Y**2)
Z2 = np.exp(-(X - 1)**2 - (Y - 1)**2)
Z = (Z1 - Z2) * 2


# Example of making your own norm.  Also see matplotlib.colors.
# From Joe Kington: This one gives two different linear ramps:
class MidpointNormalize(colors.Normalize):
    def __init__(self, vmin=None, vmax=None, midpoint=None, clip=False):
        self.midpoint = midpoint
        colors.Normalize.__init__(self, vmin, vmax, clip)

    def __call__(self, value, clip=None):
        # I'm ignoring masked values and all kinds of edge cases to make a
        # simple example...
        x, y = [self.vmin, self.midpoint, self.vmax], [0, 0.5, 1]
        return np.ma.masked_array(np.interp(value, x, y))


#####
fig, ax = plt.subplots(2, 1)

pcm = ax[0].pcolormesh(X, Y, Z,
                       norm=MidpointNormalize(midpoint=0.),
                       cmap='RdBu_r')
fig.colorbar(pcm, ax=ax[0], extend='both')

pcm = ax[1].pcolormesh(X, Y, Z, cmap='RdBu_r', vmin=-np.max(Z))
fig.colorbar(pcm, ax=ax[1], extend='both')

plt.show()
```

## 下载这个示例
            
- [下载python源码: colormap_normalizations_custom.py](https://matplotlib.org/_downloads/colormap_normalizations_custom.py)
- [下载Jupyter notebook: colormap_normalizations_custom.ipynb](https://matplotlib.org/_downloads/colormap_normalizations_custom.ipynb)