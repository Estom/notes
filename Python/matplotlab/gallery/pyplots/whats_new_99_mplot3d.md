# 0.99版本新增Mplot3d对象

创建3D曲面图。

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D

X = np.arange(-5, 5, 0.25)
Y = np.arange(-5, 5, 0.25)
X, Y = np.meshgrid(X, Y)
R = np.sqrt(X**2 + Y**2)
Z = np.sin(R)

fig = plt.figure()
ax = Axes3D(fig)
ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap=cm.viridis)

plt.show()
```

![3D曲面图示例](https://matplotlib.org/_images/sphx_glr_whats_new_99_mplot3d_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import mpl_toolkits
mpl_toolkits.mplot3d.Axes3D
mpl_toolkits.mplot3d.Axes3D.plot_surface
```

## 下载这个示例
            
- [下载python源码: whats_new_99_mplot3d.py](https://matplotlib.org/_downloads/whats_new_99_mplot3d.py)
- [下载Jupyter notebook: whats_new_99_mplot3d.ipynb](https://matplotlib.org/_downloads/whats_new_99_mplot3d.ipynb)