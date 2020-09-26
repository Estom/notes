# 绘制不同比例

在同一轴上的两个图样，具有不同的左右比例。

诀窍是使用共享同一x轴的两个不同的轴。您可以根据需要使用单独的 [matplotlib.ticker](https://matplotlib.org/api/ticker_api.html#module-matplotlib.ticker) 格式化程序和定位器，因为这两个轴是独立的。

这些轴是通过调用 [Axes.twinx()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.twinx.html#matplotlib.axes.Axes.twinx) 方法生成的。同样，[Axes.twiny()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.twiny.html#matplotlib.axes.Axes.twiny) 可用于生成共享y轴但具有不同顶部和底部比例的轴。

```python
import numpy as np
import matplotlib.pyplot as plt

# Create some mock data
t = np.arange(0.01, 10.0, 0.01)
data1 = np.exp(t)
data2 = np.sin(2 * np.pi * t)

fig, ax1 = plt.subplots()

color = 'tab:red'
ax1.set_xlabel('time (s)')
ax1.set_ylabel('exp', color=color)
ax1.plot(t, data1, color=color)
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis

color = 'tab:blue'
ax2.set_ylabel('sin', color=color)  # we already handled the x-label with ax1
ax2.plot(t, data2, color=color)
ax2.tick_params(axis='y', labelcolor=color)

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()
```

![绘制不同尺度示例](https://matplotlib.org/_images/sphx_glr_two_scales_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.twinx
matplotlib.axes.Axes.twiny
matplotlib.axes.Axes.tick_params
```

## 下载这个示例
            
- [下载python源码: two_scales.py](https://matplotlib.org/_downloads/two_scales.py)
- [下载Jupyter notebook: two_scales.ipynb](https://matplotlib.org/_downloads/two_scales.ipynb)