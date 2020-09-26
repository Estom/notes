# 三维曲面(颜色贴图)

演示绘制使用coolwarm颜色贴图着色的3D表面。 使用antialiased = False使表面变得不透明。

还演示了使用LinearLocator和z轴刻度标签的自定义格式。

![三维曲面(颜色贴图)示例](https://matplotlib.org/_images/sphx_glr_surface3d_001.png)

```python
# This import registers the 3D projection, but is otherwise unused.
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import

import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import numpy as np


fig = plt.figure()
ax = fig.gca(projection='3d')

# Make data.
X = np.arange(-5, 5, 0.25)
Y = np.arange(-5, 5, 0.25)
X, Y = np.meshgrid(X, Y)
R = np.sqrt(X**2 + Y**2)
Z = np.sin(R)

# Plot the surface.
surf = ax.plot_surface(X, Y, Z, cmap=cm.coolwarm,
                       linewidth=0, antialiased=False)

# Customize the z axis.
ax.set_zlim(-1.01, 1.01)
ax.zaxis.set_major_locator(LinearLocator(10))
ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))

# Add a color bar which maps values to colors.
fig.colorbar(surf, shrink=0.5, aspect=5)

plt.show()
```

## 下载这个示例
            
- [下载python源码: surface3d.py](https://matplotlib.org/_downloads/surface3d.py)
- [下载Jupyter notebook: surface3d.ipynb](https://matplotlib.org/_downloads/surface3d.ipynb)