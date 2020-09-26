# 插补示例

![插补示例图](https://matplotlib.org/_images/sphx_glr_interp_demo_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 2 * np.pi, 20)
y = np.sin(x)
yp = None
xi = np.linspace(x[0], x[-1], 100)
yi = np.interp(xi, x, y, yp)

fig, ax = plt.subplots()
ax.plot(x, y, 'o', xi, yi, '.')
plt.show()
```

## 下载这个示例

- [下载python源码: interp_demo.py](https://matplotlib.org/_downloads/interp_demo.py)
- [下载Jupyter notebook: interp_demo.ipynb](https://matplotlib.org/_downloads/interp_demo.ipynb)