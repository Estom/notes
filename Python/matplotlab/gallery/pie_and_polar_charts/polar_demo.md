# 极轴上绘制线段

在极轴上绘制线图的演示。

```python
import numpy as np
import matplotlib.pyplot as plt


r = np.arange(0, 2, 0.01)
theta = 2 * np.pi * r

ax = plt.subplot(111, projection='polar')
ax.plot(theta, r)
ax.set_rmax(2)
ax.set_rticks([0.5, 1, 1.5, 2])  # Less radial ticks
ax.set_rlabel_position(-22.5)  # Move radial labels away from plotted line
ax.grid(True)

ax.set_title("A line plot on a polar axis", va='bottom')
plt.show()
```

![极轴上绘制线段示例](https://matplotlib.org/_images/sphx_glr_polar_demo_001.png)

## 参考

本示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.plot
matplotlib.projections.polar
matplotlib.projections.polar.PolarAxes
matplotlib.projections.polar.PolarAxes.set_rticks
matplotlib.projections.polar.PolarAxes.set_rmax
matplotlib.projections.polar.PolarAxes.set_rlabel_position
```

## 下载这个示例
            
- [下载python源码: polar_demo.py](https://matplotlib.org/_downloads/polar_demo.py)
- [下载Jupyter notebook: polar_demo.ipynb](https://matplotlib.org/_downloads/polar_demo.ipynb)