# 使用“矩形”和“多边形”构建直方图

使用路径补丁绘制矩形。 使用大量Rectangle实例的技术或使用PolyCollections的更快方法是在我们在mpl中使用moveto / lineto，closepoly等的正确路径之前实现的。 现在我们拥有它们，我们可以使用PathCollection更有效地绘制具有同质属性的常规形状对象的集合。 这个例子创建了一个直方图 - 在开始时设置顶点数组的工作量更大，但对于大量对象来说它应该更快。

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import matplotlib.path as path

fig, ax = plt.subplots()

# Fixing random state for reproducibility
np.random.seed(19680801)


# histogram our data with numpy

data = np.random.randn(1000)
n, bins = np.histogram(data, 50)

# get the corners of the rectangles for the histogram
left = np.array(bins[:-1])
right = np.array(bins[1:])
bottom = np.zeros(len(left))
top = bottom + n


# we need a (numrects x numsides x 2) numpy array for the path helper
# function to build a compound path
XY = np.array([[left, left, right, right], [bottom, top, top, bottom]]).T

# get the Path object
barpath = path.Path.make_compound_path_from_polys(XY)

# make a patch out of it
patch = patches.PathPatch(barpath)
ax.add_patch(patch)

# update the view limits
ax.set_xlim(left[0], right[-1])
ax.set_ylim(bottom.min(), top.max())

plt.show()
```

![使用“矩形”和“多边形”构建直方图示例](https://matplotlib.org/_images/sphx_glr_histogram_path_001.png)

应该注意的是，我们可以使用顶点和代码直接创建复合路径，而不是创建三维数组并使用[make_compound_path_from_polys](https://matplotlib.org/api/path_api.html#matplotlib.path.Path.make_compound_path_from_polys)，如下所示

```python
nrects = len(left)
nverts = nrects*(1+3+1)
verts = np.zeros((nverts, 2))
codes = np.ones(nverts, int) * path.Path.LINETO
codes[0::5] = path.Path.MOVETO
codes[4::5] = path.Path.CLOSEPOLY
verts[0::5, 0] = left
verts[0::5, 1] = bottom
verts[1::5, 0] = left
verts[1::5, 1] = top
verts[2::5, 0] = right
verts[2::5, 1] = top
verts[3::5, 0] = right
verts[3::5, 1] = bottom

barpath = path.Path(verts, codes)
```

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.patches
matplotlib.patches.PathPatch
matplotlib.path
matplotlib.path.Path
matplotlib.path.Path.make_compound_path_from_polys
matplotlib.axes.Axes.add_patch
matplotlib.collections.PathCollection

# This example shows an alternative to
matplotlib.collections.PolyCollection
matplotlib.axes.Axes.hist
```

## 下载这个示例
            
- [下载python源码: histogram_path.py](https://matplotlib.org/_downloads/histogram_path.py)
- [下载Jupyter notebook: histogram_path.ipynb](https://matplotlib.org/_downloads/histogram_path.ipynb)