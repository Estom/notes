# 带有图例的散点图

还演示了如何通过给alpha值介于0和1之间来调整标记的透明度。

![带有图例的散点图示例](https://matplotlib.org/_images/sphx_glr_scatter_with_legend_001.png)

```python
import matplotlib.pyplot as plt
from numpy.random import rand


fig, ax = plt.subplots()
for color in ['red', 'green', 'blue']:
    n = 750
    x, y = rand(2, n)
    scale = 200.0 * rand(n)
    ax.scatter(x, y, c=color, s=scale, label=color,
               alpha=0.3, edgecolors='none')

ax.legend()
ax.grid(True)

plt.show()
```

## 下载这个示例

- [下载python源码: scatter_with_legend.py](https://matplotlib.org/_downloads/scatter_with_legend.py)
- [下载Jupyter notebook: scatter_with_legend.ipynb](https://matplotlib.org/_downloads/scatter_with_legend.ipynb)
