# 拉弧测试

拉弧测试示例。

![拉弧测试图示](https://matplotlib.org/_images/sphx_glr_arctest_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np


def f(t):
    'A damped exponential'
    s1 = np.cos(2 * np.pi * t)
    e1 = np.exp(-t)
    return s1 * e1


t1 = np.arange(0.0, 5.0, .2)

l = plt.plot(t1, f(t1), 'ro')
plt.setp(l, markersize=30)
plt.setp(l, markerfacecolor='C0')

plt.show()
```

## 下载这个示例

- [下载python源码: arctest.py](https://matplotlib.org/_downloads/arctest.py)
- [下载Jupyter notebook: arctest.ipynb](https://matplotlib.org/_downloads/arctest.ipynb)