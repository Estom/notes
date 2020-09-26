# 注释一个图像

此示例显示如何使用指向提供的坐标的箭头注释绘图。我们修改箭头的默认值，以“缩小”它。

有关注释功能的完整概述，另请参阅[注释教程](https://matplotlib.org/tutorials/text/annotations.html)。

```python
import numpy as np
import matplotlib.pyplot as plt

fig, ax = plt.subplots()

t = np.arange(0.0, 5.0, 0.01)
s = np.cos(2*np.pi*t)
line, = ax.plot(t, s, lw=2)

ax.annotate('local max', xy=(2, 1), xytext=(3, 1.5),
            arrowprops=dict(facecolor='black', shrink=0.05),
            )
ax.set_ylim(-2, 2)
plt.show()
```

![注释图像示例](https://matplotlib.org/_images/sphx_glr_annotation_basic_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.annotate
matplotlib.pyplot.annotate
```

## 下载这个示例
            
- [下载python源码: annotation_basic.py](https://matplotlib.org/_downloads/annotation_basic.py)
- [下载Jupyter notebook: annotation_basic.ipynb](https://matplotlib.org/_downloads/annotation_basic.ipynb)