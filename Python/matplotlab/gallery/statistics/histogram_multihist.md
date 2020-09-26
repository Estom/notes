# 使用多个数据集演示直方图(hist)函数

绘制具有多个样本集的直方图并演示：

- 使用带有多个样本集的图例
- 堆积图
- 没有填充的步进曲线
- 不同样本量的数据集

选择不同的存储量和大小会显著影响直方图的形状。Astropy文档有很多关于如何选择这些参数的部分: http://docs.astropy.org/en/stable/visualization/histogram.html


![多个数据集演示直方图](https://matplotlib.org/_images/sphx_glr_histogram_multihist_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(19680801)

n_bins = 10
x = np.random.randn(1000, 3)

fig, axes = plt.subplots(nrows=2, ncols=2)
ax0, ax1, ax2, ax3 = axes.flatten()

colors = ['red', 'tan', 'lime']
ax0.hist(x, n_bins, density=True, histtype='bar', color=colors, label=colors)
ax0.legend(prop={'size': 10})
ax0.set_title('bars with legend')

ax1.hist(x, n_bins, density=True, histtype='bar', stacked=True)
ax1.set_title('stacked bar')

ax2.hist(x, n_bins, histtype='step', stacked=True, fill=False)
ax2.set_title('stack step (unfilled)')

# Make a multiple-histogram of data-sets with different length.
x_multi = [np.random.randn(n) for n in [10000, 5000, 2000]]
ax3.hist(x_multi, n_bins, histtype='bar')
ax3.set_title('different sample sizes')

fig.tight_layout()
plt.show()
```

## 下载这个示例
            
- [下载python源码: histogram_multihist.py](https://matplotlib.org/_downloads/histogram_multihist.py)
- [下载Jupyter notebook: histogram_multihist.ipynb](https://matplotlib.org/_downloads/histogram_multihist.ipynb)