# 星标记散点图

创建多个具有不同星号符号的散点图。

![星标记散点图示例](https://matplotlib.org/_images/sphx_glr_scatter_star_poly_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)


x = np.random.rand(10)
y = np.random.rand(10)
z = np.sqrt(x**2 + y**2)

plt.subplot(321)
plt.scatter(x, y, s=80, c=z, marker=">")

plt.subplot(322)
plt.scatter(x, y, s=80, c=z, marker=(5, 0))

verts = np.array([[-1, -1], [1, -1], [1, 1], [-1, -1]])
plt.subplot(323)
plt.scatter(x, y, s=80, c=z, marker=verts)

plt.subplot(324)
plt.scatter(x, y, s=80, c=z, marker=(5, 1))

plt.subplot(325)
plt.scatter(x, y, s=80, c=z, marker='+')

plt.subplot(326)
plt.scatter(x, y, s=80, c=z, marker=(5, 2))

plt.show()
```

## 下载这个示例

- [下载python源码: scatter_star_poly.py](https://matplotlib.org/_downloads/scatter_star_poly.py)
- [下载Jupyter notebook: scatter_star_poly.ipynb](https://matplotlib.org/_downloads/scatter_star_poly.ipynb)