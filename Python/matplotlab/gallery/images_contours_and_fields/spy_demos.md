# Spy 演示

绘制数组的稀疏模式。

```python
import matplotlib.pyplot as plt
import numpy as np

fig, axs = plt.subplots(2, 2)
ax1 = axs[0, 0]
ax2 = axs[0, 1]
ax3 = axs[1, 0]
ax4 = axs[1, 1]

x = np.random.randn(20, 20)
x[5, :] = 0.
x[:, 12] = 0.

ax1.spy(x, markersize=5)
ax2.spy(x, precision=0.1, markersize=5)

ax3.spy(x)
ax4.spy(x, precision=0.1)

plt.show()
```

![Spy 演示](https://matplotlib.org/_images/sphx_glr_spy_demos_001.png)

## 参考

此示例中显示了以下函数，方法和类的使用：

```python
import matplotlib
matplotlib.axes.Axes.spy
matplotlib.pyplot.spy
```

## 下载这个示例

- [下载python源码: spy_demos.py](https://matplotlib.org/_downloads/spy_demos.py)
- [下载Jupyter notebook: spy_demos.ipynb](https://matplotlib.org/_downloads/spy_demos.ipynb)