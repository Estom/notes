# 将轮廓轮廓投影到图形上

演示显示3D表面，同时还将轮廓“轮廓”投影到图形的“墙壁”上。

有关填充版本，请参见contourf3d_demo2。

![将轮廓轮廓投影到图形上](https://matplotlib.org/_images/sphx_glr_contour3d_3_001.png)

```python
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
from matplotlib import cm

fig = plt.figure()
ax = fig.gca(projection='3d')
X, Y, Z = axes3d.get_test_data(0.05)

# Plot the 3D surface
ax.plot_surface(X, Y, Z, rstride=8, cstride=8, alpha=0.3)

# Plot projections of the contours for each dimension.  By choosing offsets
# that match the appropriate axes limits, the projected contours will sit on
# the 'walls' of the graph
cset = ax.contour(X, Y, Z, zdir='z', offset=-100, cmap=cm.coolwarm)
cset = ax.contour(X, Y, Z, zdir='x', offset=-40, cmap=cm.coolwarm)
cset = ax.contour(X, Y, Z, zdir='y', offset=40, cmap=cm.coolwarm)

ax.set_xlim(-40, 40)
ax.set_ylim(-40, 40)
ax.set_zlim(-100, 100)

ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

plt.show()
```

## 下载这个示例
            
- [下载python源码: contour3d_3.py](https://matplotlib.org/_downloads/contour3d_3.py)
- [下载Jupyter notebook: contour3d_3.ipynb](https://matplotlib.org/_downloads/contour3d_3.ipynb)