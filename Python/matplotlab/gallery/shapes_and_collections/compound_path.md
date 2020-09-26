# 复合路径

制作复合路径 - 在这种情况下是两个简单的多边形，一个矩形和一个三角形。使用 ``CLOSEPOLY`` 和 ``MOVETO`` 作为复合路径的不同部分。

```python
import numpy as np
from matplotlib.path import Path
from matplotlib.patches import PathPatch
import matplotlib.pyplot as plt


vertices = []
codes = []

codes = [Path.MOVETO] + [Path.LINETO]*3 + [Path.CLOSEPOLY]
vertices = [(1, 1), (1, 2), (2, 2), (2, 1), (0, 0)]

codes += [Path.MOVETO] + [Path.LINETO]*2 + [Path.CLOSEPOLY]
vertices += [(4, 4), (5, 5), (5, 4), (0, 0)]

vertices = np.array(vertices, float)
path = Path(vertices, codes)

pathpatch = PathPatch(path, facecolor='None', edgecolor='green')

fig, ax = plt.subplots()
ax.add_patch(pathpatch)
ax.set_title('A compound path')

ax.autoscale_view()

plt.show()
```

![复合路径示例](https://matplotlib.org/_images/sphx_glr_compound_path_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.path
matplotlib.path.Path
matplotlib.patches
matplotlib.patches.PathPatch
matplotlib.axes.Axes.add_patch
matplotlib.axes.Axes.autoscale_view
```

## 下载这个示例
            
- [下载python源码: compound_path.py](https://matplotlib.org/_downloads/compound_path.py)
- [下载Jupyter notebook: compound_path.ipynb](https://matplotlib.org/_downloads/compound_path.ipynb)