# 共享轴限制和视图

制作共享轴的两个或更多个图是常见的，例如，两个子图以时间作为公共轴。 当您平移和缩放其中一个时，您希望另一个随身携带。 为此，matplotlib Axes支持sharex和sharey属性。创建[subplot()](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.subplot.html#matplotlib.pyplot.subplot)或[axes()](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.axes.html#matplotlib.pyplot.axes)实例时，可以传入一个关键字，指示要与之共享的轴。

![共享轴限制和视图示例](https://matplotlib.org/_images/sphx_glr_share_axis_lims_views_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

t = np.arange(0, 10, 0.01)

ax1 = plt.subplot(211)
ax1.plot(t, np.sin(2*np.pi*t))

ax2 = plt.subplot(212, sharex=ax1)
ax2.plot(t, np.sin(4*np.pi*t))

plt.show()
```

## 下载这个示例
            
- [下载python源码: share_axis_lims_views.py](https://matplotlib.org/_downloads/share_axis_lims_views.py)
- [下载Jupyter notebook: share_axis_lims_views.ipynb](https://matplotlib.org/_downloads/share_axis_lims_views.ipynb)