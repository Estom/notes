# 交叉和自动关联演示

使用互相关（xcorr）和自相关（acorr）图的示例。

![交叉和自动关联演示图例](https://matplotlib.org/_images/sphx_glr_xcorr_acorr_demo_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np


# Fixing random state for reproducibility
np.random.seed(19680801)


x, y = np.random.randn(2, 100)
fig, [ax1, ax2] = plt.subplots(2, 1, sharex=True)
ax1.xcorr(x, y, usevlines=True, maxlags=50, normed=True, lw=2)
ax1.grid(True)
ax1.axhline(0, color='black', lw=2)

ax2.acorr(x, usevlines=True, normed=True, maxlags=50, lw=2)
ax2.grid(True)
ax2.axhline(0, color='black', lw=2)

plt.show()
```

## 下载这个示例

- [下载python源码: xcorr_acorr_demo.py](https://matplotlib.org/_downloads/xcorr_acorr_demo.py)
- [下载Jupyter notebook: xcorr_acorr_demo.ipynb](https://matplotlib.org/_downloads/xcorr_acorr_demo.ipynb)