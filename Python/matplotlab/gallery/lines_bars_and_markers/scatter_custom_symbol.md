# 散点图自定义符号

在散点图中创建自定义椭圆符号。

![散点图自定义符号示例](https://matplotlib.org/_images/sphx_glr_scatter_custom_symbol_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

# unit area ellipse
rx, ry = 3., 1.
area = rx * ry * np.pi
theta = np.arange(0, 2 * np.pi + 0.01, 0.1)
verts = np.column_stack([rx / area * np.cos(theta), ry / area * np.sin(theta)])

x, y, s, c = np.random.rand(4, 30)
s *= 10**2.

fig, ax = plt.subplots()
ax.scatter(x, y, s, c, marker=verts)

plt.show()
```

## 下载这个示例

- [下载python源码: scatter_custom_symbol.py](https://matplotlib.org/_downloads/scatter_custom_symbol.py)
- [下载Jupyter notebook: scatter_custom_symbol.ipynb](https://matplotlib.org/_downloads/scatter_custom_symbol.ipynb)