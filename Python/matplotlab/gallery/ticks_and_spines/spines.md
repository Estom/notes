# Spines图

这个演示比较：

 - 正常轴，四边都有spine;
 - 仅在左侧和底部有spine的轴;
 - 使用自定义边界限制spine范围的轴。

![Spines图示例](https://matplotlib.org/_images/sphx_glr_spines_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt


x = np.linspace(0, 2 * np.pi, 100)
y = 2 * np.sin(x)

fig, (ax0, ax1, ax2) = plt.subplots(nrows=3)

ax0.plot(x, y)
ax0.set_title('normal spines')

ax1.plot(x, y)
ax1.set_title('bottom-left spines')

# Hide the right and top spines
ax1.spines['right'].set_visible(False)
ax1.spines['top'].set_visible(False)
# Only show ticks on the left and bottom spines
ax1.yaxis.set_ticks_position('left')
ax1.xaxis.set_ticks_position('bottom')

ax2.plot(x, y)

# Only draw spine between the y-ticks
ax2.spines['left'].set_bounds(-1, 1)
# Hide the right and top spines
ax2.spines['right'].set_visible(False)
ax2.spines['top'].set_visible(False)
# Only show ticks on the left and bottom spines
ax2.yaxis.set_ticks_position('left')
ax2.xaxis.set_ticks_position('bottom')

# Tweak spacing between subplots to prevent labels from overlapping
plt.subplots_adjust(hspace=0.5)
plt.show()
```

## 下载这个示例
            
- [下载python源码: spines.py](https://matplotlib.org/_downloads/spines.py)
- [下载Jupyter notebook: spines.ipynb](https://matplotlib.org/_downloads/spines.ipynb)