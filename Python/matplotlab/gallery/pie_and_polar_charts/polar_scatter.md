# 极轴上的散点图

在这个例子中，尺寸径向增加，颜色随角度增加（只是为了验证符号是否正确分散）。

```python
import numpy as np
import matplotlib.pyplot as plt


# Fixing random state for reproducibility
np.random.seed(19680801)

# Compute areas and colors
N = 150
r = 2 * np.random.rand(N)
theta = 2 * np.pi * np.random.rand(N)
area = 200 * r**2
colors = theta

fig = plt.figure()
ax = fig.add_subplot(111, projection='polar')
c = ax.scatter(theta, r, c=colors, s=area, cmap='hsv', alpha=0.75)
```

![极轴上的散点图示例](https://matplotlib.org/_images/sphx_glr_polar_scatter_001.png)

## 极轴上的散点图，具有偏移原点

与先前图的主要区别在于原点半径的配置，产生环。 此外，θ零位置设置为旋转图。

```python
fig = plt.figure()
ax = fig.add_subplot(111, polar=True)
c = ax.scatter(theta, r, c=colors, s=area, cmap='hsv', alpha=0.75)

ax.set_rorigin(-2.5)
ax.set_theta_zero_location('W', offset=10)
```

![极轴上的散点图2](https://matplotlib.org/_images/sphx_glr_polar_scatter_002.png)

## 极轴上的散点图局限于扇区

与之前的图表的主要区别在于theta开始和结束限制的配置，产生扇区而不是整圆。

```python
fig = plt.figure()
ax = fig.add_subplot(111, polar=True)
c = ax.scatter(theta, r, c=colors, s=area, cmap='hsv', alpha=0.75)

ax.set_thetamin(45)
ax.set_thetamax(135)

plt.show()
```

![极轴上的散点图示例3](https://matplotlib.org/_images/sphx_glr_polar_scatter_003.png)

### 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.scatter
matplotlib.pyplot.scatter
matplotlib.projections.polar
matplotlib.projections.polar.PolarAxes.set_rorigin
matplotlib.projections.polar.PolarAxes.set_theta_zero_location
matplotlib.projections.polar.PolarAxes.set_thetamin
matplotlib.projections.polar.PolarAxes.set_thetamax
```

## 下载这个示例
            
- [下载python源码: polar_scatter.py](https://matplotlib.org/_downloads/polar_scatter.py)
- [下载Jupyter notebook: polar_scatter.ipynb](https://matplotlib.org/_downloads/polar_scatter.ipynb)