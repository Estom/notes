# 绘制填充图的示例

演示填充图。

首先，用户可以使用matplotlib制作的最基本的填充图：

```python
import numpy as np
import matplotlib.pyplot as plt

x = [0, 1, 2, 1]
y = [1, 2, 1, 0]

fig, ax = plt.subplots()
ax.fill(x, y)
plt.show()
```

![绘制填充图的示例1](https://matplotlib.org/_images/sphx_glr_fill_001.png)

接下来，还有一些可选功能：

- 使用单个命令的多条曲线。
- 设置填充颜色。
- 设置不透明度（alpha值）。

```python
x = np.linspace(0, 1.5 * np.pi, 500)
y1 = np.sin(x)
y2 = np.sin(3 * x)

fig, ax = plt.subplots()

ax.fill(x, y1, 'b', x, y2, 'r', alpha=0.3)

# Outline of the region we've filled in
ax.plot(x, y1, c='b', alpha=0.8)
ax.plot(x, y2, c='r', alpha=0.8)
ax.plot([x[0], x[-1]], [y1[0], y1[-1]], c='b', alpha=0.8)
ax.plot([x[0], x[-1]], [y2[0], y2[-1]], c='r', alpha=0.8)

plt.show()
```

![绘制填充图的示例2](https://matplotlib.org/_images/sphx_glr_fill_002.png)

## 下载这个示例

- [下载python源码: fill.py](https://matplotlib.org/_downloads/fill.py)
- [下载Jupyter notebook: fill.ipynb](https://matplotlib.org/_downloads/fill.ipynb)