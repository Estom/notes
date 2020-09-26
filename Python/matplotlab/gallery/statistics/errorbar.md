# 误差条形图功能

这展示了误差条形图功能的最基本用法。在这种情况下，为x方向和y方向的误差提供常数值。

![误差条形图示例](https://matplotlib.org/_images/sphx_glr_errorbar_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

# example data
x = np.arange(0.1, 4, 0.5)
y = np.exp(-x)

fig, ax = plt.subplots()
ax.errorbar(x, y, xerr=0.2, yerr=0.4)
plt.show()
```

## 下载这个示例
            
- [下载python源码: errorbar.py](https://matplotlib.org/_downloads/errorbar.py)
- [下载Jupyter notebook: errorbar.ipynb](https://matplotlib.org/_downloads/errorbar.ipynb)