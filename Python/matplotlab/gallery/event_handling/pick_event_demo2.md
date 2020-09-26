# 选择事件演示2

计算100个数据集的平均值和标准差（stddev），并绘制平均值vs stddev。单击其中一个mu，sigma点时，绘制生成均值和stddev的数据集中的原始数据。

![选择事件演示2](https://matplotlib.org/_images/sphx_glr_pick_event_demo2_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt


X = np.random.rand(100, 1000)
xs = np.mean(X, axis=1)
ys = np.std(X, axis=1)

fig, ax = plt.subplots()
ax.set_title('click on point to plot time series')
line, = ax.plot(xs, ys, 'o', picker=5)  # 5 points tolerance


def onpick(event):

    if event.artist != line:
        return True

    N = len(event.ind)
    if not N:
        return True

    figi, axs = plt.subplots(N, squeeze=False)
    for ax, dataind in zip(axs.flat, event.ind):
        ax.plot(X[dataind])
        ax.text(.05, .9, 'mu=%1.3f\nsigma=%1.3f' % (xs[dataind], ys[dataind]),
                transform=ax.transAxes, va='top')
        ax.set_ylim(-0.5, 1.5)
    figi.show()
    return True

fig.canvas.mpl_connect('pick_event', onpick)

plt.show()
```

## 下载这个示例
            
- [下载python源码: pick_event_demo2.py](https://matplotlib.org/_downloads/pick_event_demo2.py)
- [下载Jupyter notebook: pick_event_demo2.ipynb](https://matplotlib.org/_downloads/pick_event_demo2.ipynb)