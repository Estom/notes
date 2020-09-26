# 标记路径

使用路径（[path](https://matplotlib.org/api/path_api.html#matplotlib.path.Path)）作为绘图的标记（[plot](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.plot.html#matplotlib.axes.Axes.plot)）。

```python
import matplotlib.pyplot as plt
import matplotlib.path as mpath
import numpy as np


star = mpath.Path.unit_regular_star(6)
circle = mpath.Path.unit_circle()
# concatenate the circle with an internal cutout of the star
verts = np.concatenate([circle.vertices, star.vertices[::-1, ...]])
codes = np.concatenate([circle.codes, star.codes])
cut_star = mpath.Path(verts, codes)


plt.plot(np.arange(10)**2, '--r', marker=cut_star, markersize=15)

plt.show()
```

![标记路径示例](https://matplotlib.org/_images/sphx_glr_marker_path_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.path
matplotlib.path.Path
matplotlib.path.Path.unit_regular_star
matplotlib.path.Path.unit_circle
matplotlib.axes.Axes.plot
matplotlib.pyplot.plot
```

## 下载这个示例
            
- [下载python源码: marker_path.py](https://matplotlib.org/_downloads/marker_path.py)
- [下载Jupyter notebook: marker_path.ipynb](https://matplotlib.org/_downloads/marker_path.ipynb)