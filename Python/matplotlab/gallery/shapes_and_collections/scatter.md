# 散点图

此示例展示了一个简单的散点图。

```python
import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)


N = 50
x = np.random.rand(N)
y = np.random.rand(N)
colors = np.random.rand(N)
area = (30 * np.random.rand(N))**2  # 0 to 15 point radii

plt.scatter(x, y, s=area, c=colors, alpha=0.5)
plt.show()
```

![散点图示例](https://matplotlib.org/_images/sphx_glr_scatter_001.png)

## 参考

此示例中显示了以下函数和方法的用法：

```python
import matplotlib

matplotlib.axes.Axes.scatter
matplotlib.pyplot.scatter
```

## 下载这个示例
            
- [下载python源码: scatter.py](https://matplotlib.org/_downloads/scatter.py)
- [下载Jupyter notebook: scatter.ipynb](https://matplotlib.org/_downloads/scatter.ipynb)