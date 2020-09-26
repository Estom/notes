# 直方图(hist)函数的几个特性演示

除基本直方图外，此演示还显示了一些可选功能：

- 设置数据箱的数量。
- ``标准化``标志，用于标准化箱高度，使直方图的积分为1.得到的直方图是概率密度函数的近似值。
- 设置条形的面部颜色。
- 设置不透明度（alpha值）。

选择不同的存储量和大小会显著影响直方图的形状。Astropy文档有很多关于如何选择这些参数的部分。

```python
import matplotlib
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(19680801)

# example data
mu = 100  # mean of distribution
sigma = 15  # standard deviation of distribution
x = mu + sigma * np.random.randn(437)

num_bins = 50

fig, ax = plt.subplots()

# the histogram of the data
n, bins, patches = ax.hist(x, num_bins, density=1)

# add a 'best fit' line
y = ((1 / (np.sqrt(2 * np.pi) * sigma)) *
     np.exp(-0.5 * (1 / sigma * (bins - mu))**2))
ax.plot(bins, y, '--')
ax.set_xlabel('Smarts')
ax.set_ylabel('Probability density')
ax.set_title(r'Histogram of IQ: $\mu=100$, $\sigma=15$')

# Tweak spacing to prevent clipping of ylabel
fig.tight_layout()
plt.show()
```

![直方图特性演示](https://matplotlib.org/_images/sphx_glr_histogram_features_001.png)

## 参考

此示例显示了以下函数和方法的使用：

```python
matplotlib.axes.Axes.hist
matplotlib.axes.Axes.set_title
matplotlib.axes.Axes.set_xlabel
matplotlib.axes.Axes.set_ylabel
```

## 下载这个示例
            
- [下载python源码: histogram_features.py](https://matplotlib.org/_downloads/histogram_features.py)
- [下载Jupyter notebook: histogram_features.ipynb](https://matplotlib.org/_downloads/histogram_features.ipynb)