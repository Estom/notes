# 箱形图与小提琴图对比

请注意，尽管小提琴图与Tukey（1977）的箱形图密切相关，但它们还添加了有用的信息，例如样本数据的分布（密度轨迹）。

默认情况下，箱形图显示1.5 *四分位数范围之外的数据点作为晶须上方或下方的异常值，而小提琴图则显示数据的整个范围。

关于箱形图及其历史的一般参考可以在这里找到：http://vita.had.co.nz/papers/boxplots.pdf

小提琴图需要 matplotlib >= 1.4。

有关小提琴绘制的更多信息，scikit-learn文档有一个很棒的部分：http://scikit-learn.org/stable/modules/density.html

![箱形图与小提琴图对比示例](https://matplotlib.org/_images/sphx_glr_boxplot_vs_violin_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(9, 4))

# Fixing random state for reproducibility
np.random.seed(19680801)


# generate some random test data
all_data = [np.random.normal(0, std, 100) for std in range(6, 10)]

# plot violin plot
axes[0].violinplot(all_data,
                   showmeans=False,
                   showmedians=True)
axes[0].set_title('Violin plot')

# plot box plot
axes[1].boxplot(all_data)
axes[1].set_title('Box plot')

# adding horizontal grid lines
for ax in axes:
    ax.yaxis.grid(True)
    ax.set_xticks([y + 1 for y in range(len(all_data))])
    ax.set_xlabel('Four separate samples')
    ax.set_ylabel('Observed values')

# add x-tick labels
plt.setp(axes, xticks=[y + 1 for y in range(len(all_data))],
         xticklabels=['x1', 'x2', 'x3', 'x4'])
plt.show()
```

## 下载这个示例
            
- [下载python源码: boxplot_vs_violin.py](https://matplotlib.org/_downloads/boxplot_vs_violin.py)
- [下载Jupyter notebook: boxplot_vs_violin.ipynb](https://matplotlib.org/_downloads/boxplot_vs_violin.ipynb)