# 颜色映射规格化

演示使用规范以非线性方式将颜色映射映射到数据上。

![颜色映射规格化示例](https://matplotlib.org/_images/sphx_glr_colormap_normalizations_lognorm_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors

'''
Lognorm: Instead of pcolor log10(Z1) you can have colorbars that have
the exponential labels using a norm.
'''
N = 100
X, Y = np.mgrid[-3:3:complex(0, N), -2:2:complex(0, N)]

# A low hump with a spike coming out of the top right.  Needs to have
# z/colour axis on a log scale so we see both hump and spike.  linear
# scale only shows the spike.
Z = np.exp(-X**2 - Y**2)

fig, ax = plt.subplots(2, 1)

pcm = ax[0].pcolor(X, Y, Z,
                   norm=colors.LogNorm(vmin=Z.min(), vmax=Z.max()),
                   cmap='PuBu_r')
fig.colorbar(pcm, ax=ax[0], extend='max')

pcm = ax[1].pcolor(X, Y, Z, cmap='PuBu_r')
fig.colorbar(pcm, ax=ax[1], extend='max')

plt.show()
```

## 下载这个示例
            
- [下载python源码: colormap_normalizations_lognorm.py](https://matplotlib.org/_downloads/colormap_normalizations_lognorm.py)
- [下载Jupyter notebook: colormap_normalizations_lognorm.ipynb](https://matplotlib.org/_downloads/colormap_normalizations_lognorm.ipynb)