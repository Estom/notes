# 轴线属性

您可以调整轴的刻度和网格属性。

![轴线属性示例](https://matplotlib.org/_images/sphx_glr_axes_props_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

t = np.arange(0.0, 2.0, 0.01)
s = np.sin(2 * np.pi * t)

fig, ax = plt.subplots()
ax.plot(t, s)

ax.grid(True, linestyle='-.')
ax.tick_params(labelcolor='r', labelsize='medium', width=3)

plt.show()
```

## 下载这个示例

- [下载python源码: axes_props.py](https://matplotlib.org/_downloads/axes_props.py)
- [下载Jupyter notebook: axes_props.ipynb](https://matplotlib.org/_downloads/axes_props.ipynb)