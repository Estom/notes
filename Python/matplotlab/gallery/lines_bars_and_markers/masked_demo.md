# 遮盖示例

绘制带有点的线条。

这通常与gappy数据一起使用，以打破数据空白处的界限。

![遮盖示例1](https://matplotlib.org/_images/sphx_glr_masked_demo_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

x = np.arange(0, 2*np.pi, 0.02)
y = np.sin(x)
y1 = np.sin(2*x)
y2 = np.sin(3*x)
ym1 = np.ma.masked_where(y1 > 0.5, y1)
ym2 = np.ma.masked_where(y2 < -0.5, y2)

lines = plt.plot(x, y, x, ym1, x, ym2, 'o')
plt.setp(lines[0], linewidth=4)
plt.setp(lines[1], linewidth=2)
plt.setp(lines[2], markersize=10)

plt.legend(('No mask', 'Masked if > 0.5', 'Masked if < -0.5'),
           loc='upper right')
plt.title('Masked line demo')
plt.show()
```

## 下载这个示例

- [下载python源码: masked_demo.py](https://matplotlib.org/_downloads/masked_demo.py)
- [下载Jupyter notebook: masked_demo.ipynb](https://matplotlib.org/_downloads/masked_demo.ipynb)