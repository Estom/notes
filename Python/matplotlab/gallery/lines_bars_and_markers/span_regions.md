# 使用span_where

说明一些用于逻辑掩码为True的阴影区域的辅助函数。

请参考 [matplotlib.collections.BrokenBarHCollection.span_where()](https://matplotlib.org/api/collections_api.html#matplotlib.collections.BrokenBarHCollection.span_where)

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.collections as collections


t = np.arange(0.0, 2, 0.01)
s1 = np.sin(2*np.pi*t)
s2 = 1.2*np.sin(4*np.pi*t)


fig, ax = plt.subplots()
ax.set_title('using span_where')
ax.plot(t, s1, color='black')
ax.axhline(0, color='black', lw=2)

collection = collections.BrokenBarHCollection.span_where(
    t, ymin=0, ymax=1, where=s1 > 0, facecolor='green', alpha=0.5)
ax.add_collection(collection)

collection = collections.BrokenBarHCollection.span_where(
    t, ymin=-1, ymax=0, where=s1 < 0, facecolor='red', alpha=0.5)
ax.add_collection(collection)


plt.show()
```

![使用span_where示例](https://matplotlib.org/_images/sphx_glr_span_regions_001.png)


## 参考

本例中显示了下列函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.collections.BrokenBarHCollection
matplotlib.collections.BrokenBarHCollection.span_where
matplotlib.axes.Axes.add_collection
matplotlib.axes.Axes.axhline
```

## 下载这个示例

- [下载python源码: span_regions.py](https://matplotlib.org/_downloads/span_regions.py)
- [下载Jupyter notebook: span_regions.ipynb](https://matplotlib.org/_downloads/span_regions.ipynb)