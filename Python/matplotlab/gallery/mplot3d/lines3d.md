# 参数曲线

此示例演示了如何在3D中绘制参数曲线。

![参数曲线示例](https://matplotlib.org/_images/sphx_glr_lines3d_001.png)

```python
# This import registers the 3D projection, but is otherwise unused.
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import

import numpy as np
import matplotlib.pyplot as plt


plt.rcParams['legend.fontsize'] = 10

fig = plt.figure()
ax = fig.gca(projection='3d')

# Prepare arrays x, y, z
theta = np.linspace(-4 * np.pi, 4 * np.pi, 100)
z = np.linspace(-2, 2, 100)
r = z**2 + 1
x = r * np.sin(theta)
y = r * np.cos(theta)

ax.plot(x, y, z, label='parametric curve')
ax.legend()

plt.show()
```

## 下载这个示例
            
- [下载python源码: lines3d.py](https://matplotlib.org/_downloads/lines3d.py)
- [下载Jupyter notebook: lines3d.ipynb](https://matplotlib.org/_downloads/lines3d.ipynb)