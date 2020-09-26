# 光标

![光标示例](https://matplotlib.org/_images/sphx_glr_cursor_001.png)

```python
from matplotlib.widgets import Cursor
import numpy as np
import matplotlib.pyplot as plt


# Fixing random state for reproducibility
np.random.seed(19680801)

fig = plt.figure(figsize=(8, 6))
ax = fig.add_subplot(111, facecolor='#FFFFCC')

x, y = 4*(np.random.rand(2, 100) - .5)
ax.plot(x, y, 'o')
ax.set_xlim(-2, 2)
ax.set_ylim(-2, 2)

# Set useblit=True on most backends for enhanced performance.
cursor = Cursor(ax, useblit=True, color='red', linewidth=2)

plt.show()
```

## 下载这个示例
            
- [下载python源码: cursor.py](https://matplotlib.org/_downloads/cursor.py)
- [下载Jupyter notebook: cursor.ipynb](https://matplotlib.org/_downloads/cursor.ipynb)