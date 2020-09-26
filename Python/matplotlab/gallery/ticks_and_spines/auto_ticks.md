# 自动设置记号标签

设置刻度自动放置的行为。

如果您没有明确设置刻度位置/标签，Matplotlib将尝试根据显示的数据及其限制自动选择它们。

默认情况下，这会尝试选择沿轴分布的刻度位置：

```python
import matplotlib.pyplot as plt
import numpy as np
np.random.seed(19680801)

fig, ax = plt.subplots()
dots = np.arange(10) / 100. + .03
x, y = np.meshgrid(dots, dots)
data = [x.ravel(), y.ravel()]
ax.scatter(*data, c=data[1])
```

![自动设置记号标签示例](https://matplotlib.org/_images/sphx_glr_auto_ticks_001.png)

有时选择均匀分布的刻度会产生奇怪的刻度数。 如果您希望Matplotlib保持位于圆形数字的刻度线，则可以使用以下rcParams值更改此行为：

```python
print(plt.rcParams['axes.autolimit_mode'])

# Now change this value and see the results
with plt.rc_context({'axes.autolimit_mode': 'round_numbers'}):
    fig, ax = plt.subplots()
    ax.scatter(*data, c=data[1])
```

![自动设置记号标签示例2](https://matplotlib.org/_images/sphx_glr_auto_ticks_002.png)

输出：

```python
data
```

您还可以通过轴改变数据周围轴的边距。（x，y）边距：

```python
with plt.rc_context({'axes.autolimit_mode': 'round_numbers',
                     'axes.xmargin': .8,
                     'axes.ymargin': .8}):
    fig, ax = plt.subplots()
    ax.scatter(*data, c=data[1])

plt.show()
```

![自动设置记号标签示例3](https://matplotlib.org/_images/sphx_glr_auto_ticks_003.png)

## 下载这个示例
            
- [下载python源码: auto_ticks.py](https://matplotlib.org/_downloads/auto_ticks.py)
- [下载Jupyter notebook: auto_ticks.ipynb](https://matplotlib.org/_downloads/auto_ticks.ipynb)