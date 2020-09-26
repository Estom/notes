# 阶梯图示例

阶梯图例子：

![阶梯图示例图例](https://matplotlib.org/_images/sphx_glr_step_demo_001.png)

```python
import numpy as np
from numpy import ma
import matplotlib.pyplot as plt

x = np.arange(1, 7, 0.4)
y0 = np.sin(x)
y = y0.copy() + 2.5

plt.step(x, y, label='pre (default)')

y -= 0.5
plt.step(x, y, where='mid', label='mid')

y -= 0.5
plt.step(x, y, where='post', label='post')

y = ma.masked_where((y0 > -0.15) & (y0 < 0.15), y - 0.5)
plt.step(x, y, label='masked (pre)')

plt.legend()

plt.xlim(0, 7)
plt.ylim(-0.5, 4)

plt.show()
```

## 下载这个示例

- [下载python源码: step_demo.py](https://matplotlib.org/_downloads/step_demo.py)
- [下载Jupyter notebook: step_demo.ipynb](https://matplotlib.org/_downloads/step_demo.ipynb)