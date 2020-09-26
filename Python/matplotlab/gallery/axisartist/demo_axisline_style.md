# 轴线样式

此示例显示了轴样式的一些配置。

![轴线样式示例](https://matplotlib.org/_images/sphx_glr_demo_axisline_style_001.png)

```python
from mpl_toolkits.axisartist.axislines import SubplotZero
import matplotlib.pyplot as plt
import numpy as np

if 1:
    fig = plt.figure(1)
    ax = SubplotZero(fig, 111)
    fig.add_subplot(ax)

    for direction in ["xzero", "yzero"]:
        # adds arrows at the ends of each axis
        ax.axis[direction].set_axisline_style("-|>")

        # adds X and Y-axis from the origin
        ax.axis[direction].set_visible(True)

    for direction in ["left", "right", "bottom", "top"]:
        # hides borders
        ax.axis[direction].set_visible(False)

    x = np.linspace(-0.5, 1., 100)
    ax.plot(x, np.sin(x*np.pi))

    plt.show()
```

## 下载这个示例
            
- [下载python源码: demo_axisline_style.py](https://matplotlib.org/_downloads/demo_axisline_style.py)
- [下载Jupyter notebook: demo_axisline_style.ipynb](https://matplotlib.org/_downloads/demo_axisline_style.ipynb)