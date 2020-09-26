# 并排生成多个直方图

此示例沿范畴x轴绘制不同样本的水平直方图。此外，直方图被绘制成与它们的x位置对称，从而使它们与小提琴图非常相似。

为了使这个高度专门化的绘制，我们不能使用标准的 ``hist`` 方法。相反，我们使用 ``barh`` 直接绘制水平线。通过 ``np.histogram`` 函数计算棒材的垂直位置和长度。使用相同的范围(最小和最大值)和存储箱数量计算所有采样的直方图，以便每个采样的存储箱位于相同的垂直位置。

选择不同的存储量和大小会显著影响直方图的形状。Astropy文档有很多关于如何选择这些参数的部分: http://docs.astropy.org/en/stable/visualization/histogram.html

![并排生成多个直方图示例](https://matplotlib.org/_images/sphx_glr_multiple_histograms_side_by_side_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(19680801)
number_of_bins = 20

# An example of three data sets to compare
number_of_data_points = 387
labels = ["A", "B", "C"]
data_sets = [np.random.normal(0, 1, number_of_data_points),
             np.random.normal(6, 1, number_of_data_points),
             np.random.normal(-3, 1, number_of_data_points)]

# Computed quantities to aid plotting
hist_range = (np.min(data_sets), np.max(data_sets))
binned_data_sets = [
    np.histogram(d, range=hist_range, bins=number_of_bins)[0]
    for d in data_sets
]
binned_maximums = np.max(binned_data_sets, axis=1)
x_locations = np.arange(0, sum(binned_maximums), np.max(binned_maximums))

# The bin_edges are the same for all of the histograms
bin_edges = np.linspace(hist_range[0], hist_range[1], number_of_bins + 1)
centers = 0.5 * (bin_edges + np.roll(bin_edges, 1))[:-1]
heights = np.diff(bin_edges)

# Cycle through and plot each histogram
fig, ax = plt.subplots()
for x_loc, binned_data in zip(x_locations, binned_data_sets):
    lefts = x_loc - 0.5 * binned_data
    ax.barh(centers, binned_data, height=heights, left=lefts)

ax.set_xticks(x_locations)
ax.set_xticklabels(labels)

ax.set_ylabel("Data values")
ax.set_xlabel("Data sets")

plt.show()
```

## 下载这个示例
            
- [下载python源码: multiple_histograms_side_by_side.py](https://matplotlib.org/_downloads/multiple_histograms_side_by_side.py)
- [下载Jupyter notebook: multiple_histograms_side_by_side.ipynb](https://matplotlib.org/_downloads/multiple_histograms_side_by_side.ipynb)