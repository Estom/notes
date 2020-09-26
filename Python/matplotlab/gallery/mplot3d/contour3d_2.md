# 演示使用extend3d选项在3D中绘制轮廓（水平）曲线

contour3d_demo示例的这种修改使用extend3d = True将曲线垂直扩展为“ribbon”。

![演示使用extend3d选项在3D中绘制轮廓（水平）曲线示例](https://matplotlib.org/_images/sphx_glr_contour3d_2_001.png)

```python
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
from matplotlib import cm

fig = plt.figure()
ax = fig.gca(projection='3d')
X, Y, Z = axes3d.get_test_data(0.05)

cset = ax.contour(X, Y, Z, extend3d=True, cmap=cm.coolwarm)

ax.clabel(cset, fontsize=9, inline=1)

plt.show()
```

## 下载这个示例
            
- [下载python源码: contour3d_2.py](https://matplotlib.org/_downloads/contour3d_2.py)
- [下载Jupyter notebook: contour3d_2.ipynb](https://matplotlib.org/_downloads/contour3d_2.ipynb)