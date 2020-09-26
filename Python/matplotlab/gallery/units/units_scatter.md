# 单位处理

下面的示例显示了对掩码数组的单位转换的支持。

此示例需要[basic_units.py](https://matplotlib.org/_downloads/3a73b4cd6e12aa53ff277b1b80d631c1/basic_units.py)

![单位处理示例](https://matplotlib.org/_images/sphx_glr_units_scatter_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
from basic_units import secs, hertz, minutes

# create masked array
data = (1, 2, 3, 4, 5, 6, 7, 8)
mask = (1, 0, 1, 0, 0, 0, 1, 0)
xsecs = secs * np.ma.MaskedArray(data, mask, float)

fig, (ax1, ax2, ax3) = plt.subplots(nrows=3, sharex=True)
ax1.scatter(xsecs, xsecs)
ax1.yaxis.set_units(secs)
ax1.axis([0, 10, 0, 10])

ax2.scatter(xsecs, xsecs, yunits=hertz)
ax2.axis([0, 10, 0, 1])

ax3.scatter(xsecs, xsecs, yunits=hertz)
ax3.yaxis.set_units(minutes)
ax3.axis([0, 10, 0, 1])

fig.tight_layout()
plt.show()
```

## 下载这个示例
            
- [下载python源码: units_scatter.py](https://matplotlib.org/_downloads/units_scatter.py)
- [下载Jupyter notebook: units_scatter.ipynb](https://matplotlib.org/_downloads/units_scatter.ipynb)