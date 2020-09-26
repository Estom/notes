# 误差条形图中的上限和下限

在matplotlib中，误差条可以有“限制”。对误差线应用限制实质上使误差单向。因此，可以分别通过``uplims``，``lolims``，``xuplims``和``xlolims``参数在y方向和x方向上应用上限和下限。 这些参数可以是标量或布尔数组。 

例如，如果``xlolims``为``True``，则``x-error``条形将仅从数据扩展到递增值。如果``uplims``是一个填充了``False``的数组，除了第4和第7个值之外，所有y误差条都是双向的，除了第4和第7个条形，它们将从数据延伸到减小的y值。

![条形图限制示例](https://matplotlib.org/_images/sphx_glr_errorbar_limits_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

# example data
x = np.array([0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0])
y = np.exp(-x)
xerr = 0.1
yerr = 0.2

# lower & upper limits of the error
lolims = np.array([0, 0, 1, 0, 1, 0, 0, 0, 1, 0], dtype=bool)
uplims = np.array([0, 1, 0, 0, 0, 1, 0, 0, 0, 1], dtype=bool)
ls = 'dotted'

fig, ax = plt.subplots(figsize=(7, 4))

# standard error bars
ax.errorbar(x, y, xerr=xerr, yerr=yerr, linestyle=ls)

# including upper limits
ax.errorbar(x, y + 0.5, xerr=xerr, yerr=yerr, uplims=uplims,
            linestyle=ls)

# including lower limits
ax.errorbar(x, y + 1.0, xerr=xerr, yerr=yerr, lolims=lolims,
            linestyle=ls)

# including upper and lower limits
ax.errorbar(x, y + 1.5, xerr=xerr, yerr=yerr,
            lolims=lolims, uplims=uplims,
            marker='o', markersize=8,
            linestyle=ls)

# Plot a series with lower and upper limits in both x & y
# constant x-error with varying y-error
xerr = 0.2
yerr = np.zeros_like(x) + 0.2
yerr[[3, 6]] = 0.3

# mock up some limits by modifying previous data
xlolims = lolims
xuplims = uplims
lolims = np.zeros(x.shape)
uplims = np.zeros(x.shape)
lolims[[6]] = True  # only limited at this index
uplims[[3]] = True  # only limited at this index

# do the plotting
ax.errorbar(x, y + 2.1, xerr=xerr, yerr=yerr,
            xlolims=xlolims, xuplims=xuplims,
            uplims=uplims, lolims=lolims,
            marker='o', markersize=8,
            linestyle='none')

# tidy up the figure
ax.set_xlim((0, 5.5))
ax.set_title('Errorbar upper and lower limits')
plt.show()
```

## 下载这个示例
            
- [下载python源码: errorbar_limits.py](https://matplotlib.org/_downloads/errorbar_limits.py)
- [下载Jupyter notebook: errorbar_limits.ipynb](https://matplotlib.org/_downloads/errorbar_limits.ipynb)