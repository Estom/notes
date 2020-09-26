# 注释极坐标

此示例显示如何在极坐标图上创建注释。

有关注释功能的完整概述，另请参阅[注释教程](https://matplotlib.org/tutorials/text/annotations.html)。

```python
import numpy as np
import matplotlib.pyplot as plt

fig = plt.figure()
ax = fig.add_subplot(111, polar=True)
r = np.arange(0,1,0.001)
theta = 2 * 2*np.pi * r
line, = ax.plot(theta, r, color='#ee8d18', lw=3)

ind = 800
thisr, thistheta = r[ind], theta[ind]
ax.plot([thistheta], [thisr], 'o')
ax.annotate('a polar annotation',
            xy=(thistheta, thisr),  # theta, radius
            xytext=(0.05, 0.05),    # fraction, fraction
            textcoords='figure fraction',
            arrowprops=dict(facecolor='black', shrink=0.05),
            horizontalalignment='left',
            verticalalignment='bottom',
            )
plt.show()
```

![注释极坐标](https://matplotlib.org/_images/sphx_glr_annotation_polar_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.projections.polar
matplotlib.axes.Axes.annotate
matplotlib.pyplot.annotate
```

## 下载这个示例
            
- [下载python源码: annotation_polar.py](https://matplotlib.org/_downloads/annotation_polar.py)
- [下载Jupyter notebook: annotation_polar.ipynb](https://matplotlib.org/_downloads/annotation_polar.ipynb)