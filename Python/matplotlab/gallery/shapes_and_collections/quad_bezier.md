# Bezier曲线

此示例展示 [PathPatch](https://matplotlib.org/api/_as_gen/matplotlib.patches.PathPatch.html#matplotlib.patches.PathPatch) 对象以创建Bezier多曲线路径修补程序。

```python
import matplotlib.path as mpath
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt

Path = mpath.Path

fig, ax = plt.subplots()
pp1 = mpatches.PathPatch(
    Path([(0, 0), (1, 0), (1, 1), (0, 0)],
         [Path.MOVETO, Path.CURVE3, Path.CURVE3, Path.CLOSEPOLY]),
    fc="none", transform=ax.transData)

ax.add_patch(pp1)
ax.plot([0.75], [0.25], "ro")
ax.set_title('The red point should be on the path')

plt.show()
```

![Bezier曲线示例](https://matplotlib.org/_images/sphx_glr_quad_bezier_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.path
matplotlib.path.Path
matplotlib.patches
matplotlib.patches.PathPatch
matplotlib.axes.Axes.add_patch
```

## 下载这个示例
            
- [下载python源码: quad_bezier.py](https://matplotlib.org/_downloads/quad_bezier.py)
- [下载Jupyter notebook: quad_bezier.ipynb](https://matplotlib.org/_downloads/quad_bezier.ipynb)