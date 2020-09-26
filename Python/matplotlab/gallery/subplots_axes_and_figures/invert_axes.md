# 反转轴

可以通过翻转轴限制的法线顺序来使用递减轴。

![反转轴示例](https://matplotlib.org/_images/sphx_glr_invert_axes_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

t = np.arange(0.01, 5.0, 0.01)
s = np.exp(-t)
plt.plot(t, s)

plt.xlim(5, 0)  # decreasing time

plt.xlabel('decreasing time (s)')
plt.ylabel('voltage (mV)')
plt.title('Should be growing...')
plt.grid(True)

plt.show()
```

## 下载这个示例
            
- [下载python源码: invert_axes.py](https://matplotlib.org/_downloads/invert_axes.py)
- [下载Jupyter notebook: invert_axes.ipynb](https://matplotlib.org/_downloads/invert_axes.ipynb)