# 渐变条形图

![渐变条形图](https://matplotlib.org/_images/sphx_glr_gradient_bar_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

np.random.seed(19680801)

def gbar(ax, x, y, width=0.5, bottom=0):
    X = [[.6, .6], [.7, .7]]
    for left, top in zip(x, y):
        right = left + width
        ax.imshow(X, interpolation='bicubic', cmap=plt.cm.Blues,
                  extent=(left, right, bottom, top), alpha=1)


xmin, xmax = xlim = 0, 10
ymin, ymax = ylim = 0, 1

fig, ax = plt.subplots()
ax.set(xlim=xlim, ylim=ylim, autoscale_on=False)

X = [[.6, .6], [.7, .7]]
ax.imshow(X, interpolation='bicubic', cmap=plt.cm.copper,
          extent=(xmin, xmax, ymin, ymax), alpha=1)

N = 10
x = np.arange(N) + 0.25
y = np.random.rand(N)
gbar(ax, x, y, width=0.7)
ax.set_aspect('auto')
plt.show()
```

## 下载这个示例

- [下载python源码: gradient_bar.py](https://matplotlib.org/_downloads/gradient_bar.py)
- [下载Jupyter notebook: fill.ipynb](https://matplotlib.org/_downloads/fill.ipynb)