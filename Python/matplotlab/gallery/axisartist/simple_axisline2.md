# 简单的轴线2

![简单的轴线2](https://matplotlib.org/_images/sphx_glr_simple_axisline2_001.png)

```python
import matplotlib.pyplot as plt
from mpl_toolkits.axisartist.axislines import SubplotZero
import numpy as np

fig = plt.figure(1, (4, 3))

# a subplot with two additional axis, "xzero" and "yzero". "xzero" is
# y=0 line, and "yzero" is x=0 line.
ax = SubplotZero(fig, 1, 1, 1)
fig.add_subplot(ax)

# make xzero axis (horizontal axis line through y=0) visible.
ax.axis["xzero"].set_visible(True)
ax.axis["xzero"].label.set_text("Axis Zero")

# make other axis (bottom, top, right) invisible.
for n in ["bottom", "top", "right"]:
    ax.axis[n].set_visible(False)

xx = np.arange(0, 2*np.pi, 0.01)
ax.plot(xx, np.sin(xx))

plt.show()
```

## 下载这个示例
            
- [下载python源码: simple_axisline2.py](https://matplotlib.org/_downloads/simple_axisline2.py)
- [下载Jupyter notebook: simple_axisline2.ipynb](https://matplotlib.org/_downloads/simple_axisline2.ipynb)