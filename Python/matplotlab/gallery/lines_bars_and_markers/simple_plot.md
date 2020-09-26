# 简单图例

创建一个简单的图。

```python
import matplotlib
import matplotlib.pyplot as plt
import numpy as np

# Data for plotting
t = np.arange(0.0, 2.0, 0.01)
s = 1 + np.sin(2 * np.pi * t)

fig, ax = plt.subplots()
ax.plot(t, s)

ax.set(xlabel='time (s)', ylabel='voltage (mV)',
       title='About as simple as it gets, folks')
ax.grid()

fig.savefig("test.png")
plt.show()
```

![简单图例](https://matplotlib.org/_images/sphx_glr_simple_plot_001.png)

## 参考

下面的示例演示了以下函数和方法的使用：

```python
matplotlib.axes.Axes.plot
matplotlib.pyplot.plot
matplotlib.pyplot.subplots
matplotlib.figure.Figure.savefig
```

## 下载这个示例

- [下载python源码: simple_plot.py](https://matplotlib.org/_downloads/simple_plot.py)
- [下载Jupyter notebook: simple_plot.ipynb](https://matplotlib.org/_downloads/simple_plot.ipynb)