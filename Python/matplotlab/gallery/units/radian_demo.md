# 弧度刻度

使用basic_units模型示例包中的弧度绘图。

此示例显示单元类如何确定刻度定位，格式设置和轴标记。

此示例需要[basic_units.py](https://matplotlib.org/_downloads/3a73b4cd6e12aa53ff277b1b80d631c1/basic_units.py)

![弧度刻度示例](https://matplotlib.org/_images/sphx_glr_radian_demo_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

from basic_units import radians, degrees, cos

x = [val*radians for val in np.arange(0, 15, 0.01)]

fig, axs = plt.subplots(2)

axs[0].plot(x, cos(x), xunits=radians)
axs[1].plot(x, cos(x), xunits=degrees)

fig.tight_layout()
plt.show()
```

## 下载这个示例
            
- [下载python源码: radian_demo.py](https://matplotlib.org/_downloads/radian_demo.py)
- [下载Jupyter notebook: radian_demo.ipynb](https://matplotlib.org/_downloads/radian_demo.ipynb)