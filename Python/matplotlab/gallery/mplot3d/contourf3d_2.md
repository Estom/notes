# 将填充轮廓投影到图形上

演示显示3D表面，同时还将填充的轮廓“轮廓”投影到图形的“墙壁”上。

有关未填充的版本，请参见contour3d_demo2。

![将填充轮廓投影到图形上](https://matplotlib.org/_images/sphx_glr_contourf3d_2_0011.png)

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
cset = ax.contourf(X, Y, Z, zdir='z', offset=-100, cmap=cm.coolwarm)
cset = ax.contourf(X, Y, Z, zdir='x', offset=-40, cmap=cm.coolwarm)
cset = ax.contourf(X, Y, Z, zdir='y', offset=40, cmap=cm.coolwarm)

ax.set_xlim(-40, 40)
ax.set_ylim(-40, 40)
ax.set_zlim(-100, 100)

ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

plt.show()
```

## 下载这个示例
            
- [下载python源码: contourf3d_2.py](https://matplotlib.org/_downloads/contourf3d_2.py)
- [下载Jupyter notebook: contourf3d_2.ipynb](https://matplotlib.org/_downloads/contourf3d_2.ipynb)