# 极轴上的饼图

极轴上的饼状条形图演示。

```python
import numpy as np
import matplotlib.pyplot as plt


# Fixing random state for reproducibility
np.random.seed(19680801)

# Compute pie slices
N = 20
theta = np.linspace(0.0, 2 * np.pi, N, endpoint=False)
radii = 10 * np.random.rand(N)
width = np.pi / 4 * np.random.rand(N)

ax = plt.subplot(111, projection='polar')
bars = ax.bar(theta, radii, width=width, bottom=0.0)

# Use custom colors and opacity
for r, bar in zip(radii, bars):
    bar.set_facecolor(plt.cm.viridis(r / 10.))
    bar.set_alpha(0.5)

plt.show()
```

![极轴上的饼图示例](https://matplotlib.org/_images/sphx_glr_polar_bar_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.bar
matplotlib.pyplot.bar
matplotlib.projections.polar
```

## 下载这个示例
            
- [下载python源码: polar_bar.py](https://matplotlib.org/_downloads/polar_bar.py)
- [下载Jupyter notebook: polar_bar.ipynb](https://matplotlib.org/_downloads/polar_bar.ipynb)