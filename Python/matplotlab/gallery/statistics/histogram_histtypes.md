# 演示直方图函数的不同histtype设置

- 具有颜色填充的步进曲线的直方图。
- 具有自定义和不相等的箱宽度的直方图。

选择不同的存储量和大小会显著影响直方图的形状。Astropy文档有很多关于如何选择这些参数的部分: http://docs.astropy.org/en/stable/visualization/histogram.html

![不同histtype设置示例](https://matplotlib.org/_images/sphx_glr_histogram_histtypes_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(19680801)

mu = 200
sigma = 25
x = np.random.normal(mu, sigma, size=100)

fig, (ax0, ax1) = plt.subplots(ncols=2, figsize=(8, 4))

ax0.hist(x, 20, density=True, histtype='stepfilled', facecolor='g', alpha=0.75)
ax0.set_title('stepfilled')

# Create a histogram by providing the bin edges (unequally spaced).
bins = [100, 150, 180, 195, 205, 220, 250, 300]
ax1.hist(x, bins, density=True, histtype='bar', rwidth=0.8)
ax1.set_title('unequal bins')

fig.tight_layout()
plt.show()
```

## 下载这个示例
            
- [下载python源码: histogram_histtypes.py](https://matplotlib.org/_downloads/histogram_histtypes.py)
- [下载Jupyter notebook: histogram_histtypes.ipynb](https://matplotlib.org/_downloads/histogram_histtypes.ipynb)