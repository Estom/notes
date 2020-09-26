# 掉落的spines

从轴上偏移的spines的演示（a.k.a。“掉落的spines”）。

![掉落的spines示例](https://matplotlib.org/_images/sphx_glr_spines_dropped_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)

fig, ax = plt.subplots()

image = np.random.uniform(size=(10, 10))
ax.imshow(image, cmap=plt.cm.gray, interpolation='nearest')
ax.set_title('dropped spines')

# Move left and bottom spines outward by 10 points
ax.spines['left'].set_position(('outward', 10))
ax.spines['bottom'].set_position(('outward', 10))
# Hide the right and top spines
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
# Only show ticks on the left and bottom spines
ax.yaxis.set_ticks_position('left')
ax.xaxis.set_ticks_position('bottom')

plt.show()
```

## 下载这个示例
            
- [下载python源码: spines_dropped.py](https://matplotlib.org/_downloads/spines_dropped.py)
- [下载Jupyter notebook: spines_dropped.ipynb](https://matplotlib.org/_downloads/spines_dropped.ipynb)