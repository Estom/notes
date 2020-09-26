# 三维曲面(纯色)

使用纯色演示3D表面的基本图。

![三维曲面(纯色)示例](https://matplotlib.org/_images/sphx_glr_surface3d_2_001.png)

```python
# This import registers the 3D projection, but is otherwise unused.
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import

import matplotlib.pyplot as plt
import numpy as np


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Make data
u = np.linspace(0, 2 * np.pi, 100)
v = np.linspace(0, np.pi, 100)
x = 10 * np.outer(np.cos(u), np.sin(v))
y = 10 * np.outer(np.sin(u), np.sin(v))
z = 10 * np.outer(np.ones(np.size(u)), np.cos(v))

# Plot the surface
ax.plot_surface(x, y, z, color='b')

plt.show()
```

## 下载这个示例
            
- [下载python源码: surface3d_2.py](https://matplotlib.org/_downloads/surface3d_2.py)
- [下载Jupyter notebook: surface3d_2.ipynb](https://matplotlib.org/_downloads/surface3d_2.ipynb)