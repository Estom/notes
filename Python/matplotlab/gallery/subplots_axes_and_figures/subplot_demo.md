# 基本子图演示

演示有两个子图。有关更多选项，请参阅[子图演示](https://matplotlib.org/gallery/subplots_axes_and_figures/subplots_demo.html)。

![基本子图演示](https://matplotlib.org/_images/sphx_glr_subplot_demo_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

# Data for plotting
x1 = np.linspace(0.0, 5.0)
x2 = np.linspace(0.0, 2.0)
y1 = np.cos(2 * np.pi * x1) * np.exp(-x1)
y2 = np.cos(2 * np.pi * x2)

# Create two subplots sharing y axis
fig, (ax1, ax2) = plt.subplots(2, sharey=True)

ax1.plot(x1, y1, 'ko-')
ax1.set(title='A tale of 2 subplots', ylabel='Damped oscillation')

ax2.plot(x2, y2, 'r.-')
ax2.set(xlabel='time (s)', ylabel='Undamped')

plt.show()
```

## 下载这个示例
            
- [下载python源码: subplot_demo.py](https://matplotlib.org/_downloads/subplot_demo.py)
- [下载Jupyter notebook: subplot_demo.ipynb](https://matplotlib.org/_downloads/subplot_demo.ipynb)