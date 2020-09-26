# 演示在3D中绘制轮廓（水平）曲线

这类似于2D中的等高线图，除了f（x，y）= c曲线绘制在平面z = c上。

![演示在3D中绘制轮廓（水平）曲线示例](https://matplotlib.org/_images/sphx_glr_contour3d_001.png)

```python
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
from matplotlib import cm

fig = plt.figure()
ax = fig.gca(projection='3d')
X, Y, Z = axes3d.get_test_data(0.05)

# Plot contour curves
cset = ax.contour(X, Y, Z, cmap=cm.coolwarm)

ax.clabel(cset, fontsize=9, inline=1)

plt.show()
```

## 下载这个示例
            
- [下载python源码: contour3d.py](https://matplotlib.org/_downloads/contour3d.py)
- [下载Jupyter notebook: contour3d.ipynb](https://matplotlib.org/_downloads/contour3d.ipynb)