# 填充轮廓

contourf与轮廓的不同之处在于它创建了填充轮廓，即。 离散数量的颜色用于遮蔽域。

这类似于2D中的等高线图，除了对应于等级c的阴影区域在平面z = c上绘制图形。

![填充轮廓示例](https://matplotlib.org/_images/sphx_glr_contourf3d_001.png)

```python
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
from matplotlib import cm

fig = plt.figure()
ax = fig.gca(projection='3d')
X, Y, Z = axes3d.get_test_data(0.05)

cset = ax.contourf(X, Y, Z, cmap=cm.coolwarm)

ax.clabel(cset, fontsize=9, inline=1)

plt.show()
```

## 下载这个示例
            
- [下载python源码: contourf3d.py](https://matplotlib.org/_downloads/contourf3d.py)
- [下载Jupyter notebook: contourf3d.ipynb](https://matplotlib.org/_downloads/contourf3d.ipynb)