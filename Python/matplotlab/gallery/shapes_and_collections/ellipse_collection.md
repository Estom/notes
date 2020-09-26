# 椭圆集合

绘制椭圆的集合。虽然使用 [EllipseCollection](https://matplotlib.org/api/collections_api.html#matplotlib.collections.EllipseCollection) 或[PathCollection](https://matplotlib.org/api/collections_api.html#matplotlib.collections.PathCollection) 同样可行，但使用[EllipseCollection](https://matplotlib.org/api/collections_api.html#matplotlib.collections.EllipseCollection) 可以实现更短的代码。

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.collections import EllipseCollection

x = np.arange(10)
y = np.arange(15)
X, Y = np.meshgrid(x, y)

XY = np.column_stack((X.ravel(), Y.ravel()))

ww = X / 10.0
hh = Y / 15.0
aa = X * 9


fig, ax = plt.subplots()

ec = EllipseCollection(ww, hh, aa, units='x', offsets=XY,
                       transOffset=ax.transData)
ec.set_array((X + Y).ravel())
ax.add_collection(ec)
ax.autoscale_view()
ax.set_xlabel('X')
ax.set_ylabel('y')
cbar = plt.colorbar(ec)
cbar.set_label('X+Y')
plt.show()
```

![椭圆集合示例](https://matplotlib.org/_images/sphx_glr_ellipse_collection_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.collections
matplotlib.collections.EllipseCollection
matplotlib.axes.Axes.add_collection
matplotlib.axes.Axes.autoscale_view
matplotlib.cm.ScalarMappable.set_array
```

## 下载这个示例
            
- [下载python源码: ellipse_collection.py](https://matplotlib.org/_downloads/ellipse_collection.py)
- [下载Jupyter notebook: ellipse_collection.ipynb](https://matplotlib.org/_downloads/ellipse_collection.ipynb)