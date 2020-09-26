# 使用预定义标签的图例

使用图定义图例标签。

```python
import numpy as np
import matplotlib.pyplot as plt

# Make some fake data.
a = b = np.arange(0, 3, .02)
c = np.exp(a)
d = c[::-1]

# Create plots with pre-defined labels.
fig, ax = plt.subplots()
ax.plot(a, c, 'k--', label='Model length')
ax.plot(a, d, 'k:', label='Data length')
ax.plot(a, c + d, 'k', label='Total message length')

legend = ax.legend(loc='upper center', shadow=True, fontsize='x-large')

# Put a nicer background color on the legend.
legend.get_frame().set_facecolor('C0')

plt.show()
```

![预定义标签的示例](https://matplotlib.org/_images/sphx_glr_legend_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.plot
matplotlib.pyplot.plot
matplotlib.axes.Axes.legend
matplotlib.pyplot.legend
```

## 下载这个示例
            
- [下载python源码: legend.py](https://matplotlib.org/_downloads/legend.py)
- [下载Jupyter notebook: legend.ipynb](https://matplotlib.org/_downloads/legend.ipynb)