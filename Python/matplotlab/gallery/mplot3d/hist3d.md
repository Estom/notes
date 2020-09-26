# 创建2D数据的3D直方图

将二维数据的直方图演示为3D中的条形图。

![创建2D数据的3D直方图示例](https://matplotlib.org/_images/sphx_glr_hist3d_001.png)

```python
# This import registers the 3D projection, but is otherwise unused.
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import

import matplotlib.pyplot as plt
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
x, y = np.random.rand(2, 100) * 4
hist, xedges, yedges = np.histogram2d(x, y, bins=4, range=[[0, 4], [0, 4]])

# Construct arrays for the anchor positions of the 16 bars.
xpos, ypos = np.meshgrid(xedges[:-1] + 0.25, yedges[:-1] + 0.25, indexing="ij")
xpos = xpos.ravel()
ypos = ypos.ravel()
zpos = 0

# Construct arrays with the dimensions for the 16 bars.
dx = dy = 0.5 * np.ones_like(zpos)
dz = hist.ravel()

ax.bar3d(xpos, ypos, zpos, dx, dy, dz, color='b', zsort='average')

plt.show()
```

## 下载这个示例
            
- [下载python源码: hist3d.py](https://matplotlib.org/_downloads/hist3d.py)
- [下载Jupyter notebook: hist3d.ipynb](https://matplotlib.org/_downloads/hist3d.ipynb)