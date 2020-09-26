# 在和Alpha之间填充

[fill_between()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.fill_between.html#matplotlib.axes.Axes.fill_between)函数在最小和最大边界之间生成阴影区域，这对于说明范围很有用。 它具有非常方便的用于将填充与逻辑范围组合的参数，例如，仅在某个阈值上填充曲线。

在最基本的层面上，``fill_between`` 可用于增强图形的视觉外观。让我们将两个财务时间图与左边的简单线图和右边的实线进行比较。

```python
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.cbook as cbook

# load up some sample financial data
with cbook.get_sample_data('goog.npz') as datafile:
    r = np.load(datafile)['price_data'].view(np.recarray)
# Matplotlib prefers datetime instead of np.datetime64.
date = r.date.astype('O')
# create two subplots with the shared x and y axes
fig, (ax1, ax2) = plt.subplots(1, 2, sharex=True, sharey=True)

pricemin = r.close.min()

ax1.plot(date, r.close, lw=2)
ax2.fill_between(date, pricemin, r.close, facecolor='blue', alpha=0.5)

for ax in ax1, ax2:
    ax.grid(True)

ax1.set_ylabel('price')
for label in ax2.get_yticklabels():
    label.set_visible(False)

fig.suptitle('Google (GOOG) daily closing price')
fig.autofmt_xdate()
```

![在和Alpha之间填充示例](https://matplotlib.org/_images/sphx_glr_fill_between_alpha_001.png)

此处不需要Alpha通道，但它可以用于软化颜色以获得更具视觉吸引力的图形。在其他示例中，正如我们将在下面看到的，alpha通道在功能上非常有用，因为阴影区域可以重叠，alpha允许您查看两者。请注意，postscript格式不支持alpha（这是postscript限制，而不是matplotlib限制），因此在使用alpha时保存PNG，PDF或SVG中的数字。

我们的下一个例子计算两个随机游走者群体，它们具有不同的正态分布的均值和标准差，从中得出步骤。我们使用共享区域绘制人口平均位置的+/-一个标准偏差。 这里的alpha通道非常有用，而不仅仅是审美。

```python
Nsteps, Nwalkers = 100, 250
t = np.arange(Nsteps)

# an (Nsteps x Nwalkers) array of random walk steps
S1 = 0.002 + 0.01*np.random.randn(Nsteps, Nwalkers)
S2 = 0.004 + 0.02*np.random.randn(Nsteps, Nwalkers)

# an (Nsteps x Nwalkers) array of random walker positions
X1 = S1.cumsum(axis=0)
X2 = S2.cumsum(axis=0)


# Nsteps length arrays empirical means and standard deviations of both
# populations over time
mu1 = X1.mean(axis=1)
sigma1 = X1.std(axis=1)
mu2 = X2.mean(axis=1)
sigma2 = X2.std(axis=1)

# plot it!
fig, ax = plt.subplots(1)
ax.plot(t, mu1, lw=2, label='mean population 1', color='blue')
ax.plot(t, mu2, lw=2, label='mean population 2', color='yellow')
ax.fill_between(t, mu1+sigma1, mu1-sigma1, facecolor='blue', alpha=0.5)
ax.fill_between(t, mu2+sigma2, mu2-sigma2, facecolor='yellow', alpha=0.5)
ax.set_title(r'random walkers empirical $\mu$ and $\pm \sigma$ interval')
ax.legend(loc='upper left')
ax.set_xlabel('num steps')
ax.set_ylabel('position')
ax.grid()
```

![在和Alpha之间填充示例2](https://matplotlib.org/_images/sphx_glr_fill_between_alpha_002.png)

where关键字参数非常便于突出显示图形的某些区域。其中布尔掩码的长度与x，ymin和ymax参数的长度相同，并且仅填充布尔掩码为True的区域。在下面的示例中，我们模拟单个随机游走者并计算人口位置的分析平均值和标准差。总体平均值显示为黑色虚线，并且与平均值的正/负一西格玛偏差显示为黄色填充区域。我们使用where掩码X> upper_bound来找到walker在一个sigma边界之上的区域，并将该区域遮蔽为蓝色。

```python
Nsteps = 500
t = np.arange(Nsteps)

mu = 0.002
sigma = 0.01

# the steps and position
S = mu + sigma*np.random.randn(Nsteps)
X = S.cumsum()

# the 1 sigma upper and lower analytic population bounds
lower_bound = mu*t - sigma*np.sqrt(t)
upper_bound = mu*t + sigma*np.sqrt(t)

fig, ax = plt.subplots(1)
ax.plot(t, X, lw=2, label='walker position', color='blue')
ax.plot(t, mu*t, lw=1, label='population mean', color='black', ls='--')
ax.fill_between(t, lower_bound, upper_bound, facecolor='yellow', alpha=0.5,
                label='1 sigma range')
ax.legend(loc='upper left')

# here we use the where argument to only fill the region where the
# walker is above the population 1 sigma boundary
ax.fill_between(t, upper_bound, X, where=X > upper_bound, facecolor='blue',
                alpha=0.5)
ax.set_xlabel('num steps')
ax.set_ylabel('position')
ax.grid()
```

![在和Alpha之间填充示例3](https://matplotlib.org/_images/sphx_glr_fill_between_alpha_003.png)

填充区域的另一个方便用途是突出显示轴的水平或垂直跨度 - 因为matplotlib具有一些辅助函数 [axhspan()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.axhspan.html#matplotlib.axes.Axes.axhspan) 和[axvspan()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.axvspan.html#matplotlib.axes.Axes.axvspan) 以及示例[axhspan Demo](https://matplotlib.org/gallery/subplots_axes_and_figures/axhspan_demo.html)。

```python
plt.show()
```

## 下载这个示例
            
- [下载python源码: fill_between_alpha.py](https://matplotlib.org/_downloads/fill_between_alpha.py)
- [下载Jupyter notebook: fill_between_alpha.ipynb](https://matplotlib.org/_downloads/fill_between_alpha.ipynb)