# 英寸和厘米

该示例说明了使用绘图函数的xunits和yunits参数将默认x和y单位（ax1）覆盖为英寸和厘米的功能。 请注意，应用转换以获取正确单位的数字。

此示例需要[basic_units.py](https://matplotlib.org/_downloads/3a73b4cd6e12aa53ff277b1b80d631c1/basic_units.py)

![英寸和厘米示例](https://matplotlib.org/_images/sphx_glr_units_sample_001.png)

```python
from basic_units import cm, inch
import matplotlib.pyplot as plt
import numpy as np

cms = cm * np.arange(0, 10, 2)

fig, axs = plt.subplots(2, 2)

axs[0, 0].plot(cms, cms)

axs[0, 1].plot(cms, cms, xunits=cm, yunits=inch)

axs[1, 0].plot(cms, cms, xunits=inch, yunits=cm)
axs[1, 0].set_xlim(3, 6)  # scalars are interpreted in current units

axs[1, 1].plot(cms, cms, xunits=inch, yunits=inch)
axs[1, 1].set_xlim(3*cm, 6*cm)  # cm are converted to inches

plt.show()
```

## 下载这个示例
            
- [下载python源码: units_sample.py](https://matplotlib.org/_downloads/units_sample.py)
- [下载Jupyter notebook: units_sample.ipynb](https://matplotlib.org/_downloads/units_sample.ipynb)