# 多个子图

带有多个子图的简单演示。

![多个子图](https://matplotlib.org/_images/sphx_glr_subplot_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt


x1 = np.linspace(0.0, 5.0)
x2 = np.linspace(0.0, 2.0)

y1 = np.cos(2 * np.pi * x1) * np.exp(-x1)
y2 = np.cos(2 * np.pi * x2)

plt.subplot(2, 1, 1)
plt.plot(x1, y1, 'o-')
plt.title('A tale of 2 subplots')
plt.ylabel('Damped oscillation')

plt.subplot(2, 1, 2)
plt.plot(x2, y2, '.-')
plt.xlabel('time (s)')
plt.ylabel('Undamped')

plt.show()
```

## 下载这个示例
            
- [下载python源码: subplot.py](https://matplotlib.org/_downloads/subplot.py)
- [下载Jupyter notebook: subplot.ipynb](https://matplotlib.org/_downloads/subplot.ipynb)