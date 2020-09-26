# FiveThirtyEight样式表

这显示了“fivethirtyeight”样式的一个示例，它试图从FiveThirtyEight.com复制样式。

![FiveThirtyEight样式表示例](https://matplotlib.org/_images/sphx_glr_fivethirtyeight_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np


plt.style.use('fivethirtyeight')

x = np.linspace(0, 10)

# Fixing random state for reproducibility
np.random.seed(19680801)

fig, ax = plt.subplots()

ax.plot(x, np.sin(x) + x + np.random.randn(50))
ax.plot(x, np.sin(x) + 0.5 * x + np.random.randn(50))
ax.plot(x, np.sin(x) + 2 * x + np.random.randn(50))
ax.plot(x, np.sin(x) - 0.5 * x + np.random.randn(50))
ax.plot(x, np.sin(x) - 2 * x + np.random.randn(50))
ax.plot(x, np.sin(x) + np.random.randn(50))
ax.set_title("'fivethirtyeight' style sheet")

plt.show()
```

## 下载这个示例
            
- [下载python源码: fivethirtyeight.py](https://matplotlib.org/_downloads/fivethirtyeight.py)
- [下载Jupyter notebook: fivethirtyeight.ipynb](https://matplotlib.org/_downloads/fivethirtyeight.ipynb)