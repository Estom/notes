# 旋转3D绘图

一个非常简单的旋转3D绘图动画。

有关动画3D绘图的另一个简单示例，请参阅wire3d_animation_demo。

（构建文档库时会跳过此示例，因为它有意运行需要很长时间）

```python
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# load some test data for demonstration and plot a wireframe
X, Y, Z = axes3d.get_test_data(0.1)
ax.plot_wireframe(X, Y, Z, rstride=5, cstride=5)

# rotate the axes and update
for angle in range(0, 360):
    ax.view_init(30, angle)
    plt.draw()
    plt.pause(.001)
```

## 下载这个示例
            
- [下载python源码: rotate_axes3d_sgskip.py](https://matplotlib.org/_downloads/rotate_axes3d_sgskip.py)
- [下载Jupyter notebook: rotate_axes3d_sgskip.ipynb](https://matplotlib.org/_downloads/rotate_axes3d_sgskip.ipynb)