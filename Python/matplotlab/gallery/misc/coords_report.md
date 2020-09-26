# 坐标报告

覆盖coords的默认报告。

![坐标报告示例](https://matplotlib.org/_images/sphx_glr_coords_report_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np


def millions(x):
    return '$%1.1fM' % (x*1e-6)


# Fixing random state for reproducibility
np.random.seed(19680801)

x = np.random.rand(20)
y = 1e7*np.random.rand(20)

fig, ax = plt.subplots()
ax.fmt_ydata = millions
plt.plot(x, y, 'o')

plt.show()
```

## 下载这个示例
            
- [下载python源码: coords_report.py](https://matplotlib.org/_downloads/coords_report.py)
- [下载Jupyter notebook: coords_report.ipynb](https://matplotlib.org/_downloads/coords_report.ipynb)