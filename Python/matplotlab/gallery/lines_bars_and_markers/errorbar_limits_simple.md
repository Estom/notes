# 绘制限制型误差条形图

误差条上的上限符号和下限符号的说明

```python
import numpy as np
import matplotlib.pyplot as plt
```

```python
fig = plt.figure(0)
x = np.arange(10.0)
y = np.sin(np.arange(10.0) / 20.0 * np.pi)

plt.errorbar(x, y, yerr=0.1)

y = np.sin(np.arange(10.0) / 20.0 * np.pi) + 1
plt.errorbar(x, y, yerr=0.1, uplims=True)

y = np.sin(np.arange(10.0) / 20.0 * np.pi) + 2
upperlimits = np.array([1, 0] * 5)
lowerlimits = np.array([0, 1] * 5)
plt.errorbar(x, y, yerr=0.1, uplims=upperlimits, lolims=lowerlimits)

plt.xlim(-1, 10)
```

![限制型误差条形图示](https://matplotlib.org/_images/sphx_glr_errorbar_limits_simple_000.png);

```python
fig = plt.figure(1)
x = np.arange(10.0) / 10.0
y = (x + 0.1)**2

plt.errorbar(x, y, xerr=0.1, xlolims=True)
y = (x + 0.1)**3

plt.errorbar(x + 0.6, y, xerr=0.1, xuplims=upperlimits, xlolims=lowerlimits)

y = (x + 0.1)**4
plt.errorbar(x + 1.2, y, xerr=0.1, xuplims=True)

plt.xlim(-0.2, 2.4)
plt.ylim(-0.1, 1.3)

plt.show()
```

![限制型误差条形图示2](https://matplotlib.org/_images/sphx_glr_errorbar_limits_simple_002.png);

## 下载这个示例

- [下载python源码: errorbar_limits_simple.py](https://matplotlib.org/_downloads/errorbar_limits_simple.py)
- [下载Jupyter notebook: errorbar_limits_simple.ipynb](https://matplotlib.org/_downloads/errorbar_limits_simple.ipynb)