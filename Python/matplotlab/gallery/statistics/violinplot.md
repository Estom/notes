# 小提琴图基础

小提琴图类似于直方图和箱形图，因为它们显示了样本概率分布的抽象表示。小提琴图使用核密度估计（KDE）来计算样本的经验分布，而不是显示属于分类或顺序统计的数据点的计数。该计算由几个参数控制。此示例演示如何修改评估KDE的点数 ``(points)`` 以及如何修改KDE ``（bw_method）`` 的带宽。

有关小提琴图和KDE的更多信息，请参阅scikit-learn文档
有一个很棒的部分：http://scikit-learn.org/stable/modules/density.html

![小提琴图基础示例](https://matplotlib.org/_images/sphx_glr_violinplot_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)


# fake data
fs = 10  # fontsize
pos = [1, 2, 4, 5, 7, 8]
data = [np.random.normal(0, std, size=100) for std in pos]

fig, axes = plt.subplots(nrows=2, ncols=3, figsize=(6, 6))

axes[0, 0].violinplot(data, pos, points=20, widths=0.3,
                      showmeans=True, showextrema=True, showmedians=True)
axes[0, 0].set_title('Custom violinplot 1', fontsize=fs)

axes[0, 1].violinplot(data, pos, points=40, widths=0.5,
                      showmeans=True, showextrema=True, showmedians=True,
                      bw_method='silverman')
axes[0, 1].set_title('Custom violinplot 2', fontsize=fs)

axes[0, 2].violinplot(data, pos, points=60, widths=0.7, showmeans=True,
                      showextrema=True, showmedians=True, bw_method=0.5)
axes[0, 2].set_title('Custom violinplot 3', fontsize=fs)

axes[1, 0].violinplot(data, pos, points=80, vert=False, widths=0.7,
                      showmeans=True, showextrema=True, showmedians=True)
axes[1, 0].set_title('Custom violinplot 4', fontsize=fs)

axes[1, 1].violinplot(data, pos, points=100, vert=False, widths=0.9,
                      showmeans=True, showextrema=True, showmedians=True,
                      bw_method='silverman')
axes[1, 1].set_title('Custom violinplot 5', fontsize=fs)

axes[1, 2].violinplot(data, pos, points=200, vert=False, widths=1.1,
                      showmeans=True, showextrema=True, showmedians=True,
                      bw_method=0.5)
axes[1, 2].set_title('Custom violinplot 6', fontsize=fs)

for ax in axes.flatten():
    ax.set_yticklabels([])

fig.suptitle("Violin Plotting Examples")
fig.subplots_adjust(hspace=0.4)
plt.show()
```

## 下载这个示例
            
- [下载python源码: violinplot.py](https://matplotlib.org/_downloads/violinplot.py)
- [下载Jupyter notebook: violinplot.ipynb](https://matplotlib.org/_downloads/violinplot.ipynb)