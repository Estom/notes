# 填充交叉区域

填充两条曲线之间的区域。

```python
import matplotlib.pyplot as plt
import numpy as np

x = np.arange(-5, 5, 0.01)
y1 = -5*x*x + x + 10
y2 = 5*x*x + x

fig, ax = plt.subplots()
ax.plot(x, y1, x, y2, color='black')
ax.fill_between(x, y1, y2, where=y2 >y1, facecolor='yellow', alpha=0.5)
ax.fill_between(x, y1, y2, where=y2 <=y1, facecolor='red', alpha=0.5)
ax.set_title('Fill Between')

plt.show()
```

![填充示例](https://matplotlib.org/_images/sphx_glr_whats_new_98_4_fill_between_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.fill_between
```

## 下载这个示例
            
- [下载python源码: whats_new_98_4_fill_between.py](https://matplotlib.org/_downloads/whats_new_98_4_fill_between.py)
- [下载Jupyter notebook: whats_new_98_4_fill_between.ipynb](https://matplotlib.org/_downloads/whats_new_98_4_fill_between.ipynb)