# 填充螺旋

![填充螺旋示例](https://matplotlib.org/_images/sphx_glr_fill_spiral_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

theta = np.arange(0, 8*np.pi, 0.1)
a = 1
b = .2

for dt in np.arange(0, 2*np.pi, np.pi/2.0):

    x = a*np.cos(theta + dt)*np.exp(b*theta)
    y = a*np.sin(theta + dt)*np.exp(b*theta)

    dt = dt + np.pi/4.0

    x2 = a*np.cos(theta + dt)*np.exp(b*theta)
    y2 = a*np.sin(theta + dt)*np.exp(b*theta)

    xf = np.concatenate((x, x2[::-1]))
    yf = np.concatenate((y, y2[::-1]))

    p1 = plt.fill(xf, yf)

plt.show()
```

## 下载这个示例
            
- [下载python源码: fill_spiral.py](https://matplotlib.org/_downloads/fill_spiral.py)
- [下载Jupyter notebook: fill_spiral.ipynb](https://matplotlib.org/_downloads/fill_spiral.ipynb)