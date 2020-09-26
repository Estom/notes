# 3D线框图

线框图的一个非常基本的演示。

![3D线框图示例](https://matplotlib.org/_images/sphx_glr_wire3d_001.png)

```python
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Grab some test data.
X, Y, Z = axes3d.get_test_data(0.05)

# Plot a basic wireframe.
ax.plot_wireframe(X, Y, Z, rstride=10, cstride=10)

plt.show()
```

## 下载这个示例
            
- [下载python源码: wire3d.py](https://matplotlib.org/_downloads/wire3d.py)
- [下载Jupyter notebook: wire3d.ipynb](https://matplotlib.org/_downloads/wire3d.ipynb)