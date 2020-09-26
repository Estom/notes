# Boxplot 演示

boxplot 的代码示例。

```python
import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)

# fake up some data
spread = np.random.rand(50) * 100
center = np.ones(25) * 50
flier_high = np.random.rand(10) * 100 + 100
flier_low = np.random.rand(10) * -100
data = np.concatenate((spread, center, flier_high, flier_low))
```

```python
fig1, ax1 = plt.subplots()
ax1.set_title('Basic Plot')
ax1.boxplot(data)
```

![Boxplot示例](https://matplotlib.org/_images/sphx_glr_boxplot_demo_pyplot_001.png)

```python
fig2, ax2 = plt.subplots()
ax2.set_title('Notched boxes')
ax2.boxplot(data, notch=True)
```

![Boxplot示例2](https://matplotlib.org/_images/sphx_glr_boxplot_demo_pyplot_002.png)

```python
green_diamond = dict(markerfacecolor='g', marker='D')
fig3, ax3 = plt.subplots()
ax3.set_title('Changed Outlier Symbols')
ax3.boxplot(data, flierprops=green_diamond)
```

![Boxplot示例3](https://matplotlib.org/_images/sphx_glr_boxplot_demo_pyplot_003.png)

```python
fig4, ax4 = plt.subplots()
ax4.set_title('Hide Outlier Points')
ax4.boxplot(data, showfliers=False)
```

![Boxplot示例4](https://matplotlib.org/_images/sphx_glr_boxplot_demo_pyplot_004.png)

```python
red_square = dict(markerfacecolor='r', marker='s')
fig5, ax5 = plt.subplots()
ax5.set_title('Horizontal Boxes')
ax5.boxplot(data, vert=False, flierprops=red_square)
```

![Boxplot示例5](https://matplotlib.org/_images/sphx_glr_boxplot_demo_pyplot_005.png)

```python
fig6, ax6 = plt.subplots()
ax6.set_title('Shorter Whisker Length')
ax6.boxplot(data, flierprops=red_square, vert=False, whis=0.75)
```

![Boxplot示例6](https://matplotlib.org/_images/sphx_glr_boxplot_demo_pyplot_006.png)

模拟一些更多的数据。

```python
spread = np.random.rand(50) * 100
center = np.ones(25) * 40
flier_high = np.random.rand(10) * 100 + 100
flier_low = np.random.rand(10) * -100
d2 = np.concatenate((spread, center, flier_high, flier_low))
data.shape = (-1, 1)
d2.shape = (-1, 1)
```

仅当所有列的长度相同时，才能生成二维数组。 如果不是，则使用列表。 这实际上更有效，因为boxplot无论如何都会在内部将2-D数组转换为向量列表。

```python
data = [data, d2, d2[::2,0]]
fig7, ax7 = plt.subplots()
ax7.set_title('Multiple Samples with Different sizes')
ax7.boxplot(data)

plt.show()
```

![Boxplot示例7](https://matplotlib.org/_images/sphx_glr_boxplot_demo_pyplot_007.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.boxplot
matplotlib.pyplot.boxplot
```

## 下载这个示例
            
- [下载python源码: boxplot_demo_pyplot.py](https://matplotlib.org/_downloads/boxplot_demo_pyplot.py)
- [下载Jupyter notebook: boxplot_demo_pyplot.ipynb](https://matplotlib.org/_downloads/boxplot_demo_pyplot.ipynb)