# 简单的轴线3

![简单的轴线3](https://matplotlib.org/_images/sphx_glr_simple_axisline3_001.png)

```python
import matplotlib.pyplot as plt
from mpl_toolkits.axisartist.axislines import Subplot

fig = plt.figure(1, (3, 3))

ax = Subplot(fig, 111)
fig.add_subplot(ax)

ax.axis["right"].set_visible(False)
ax.axis["top"].set_visible(False)

plt.show()
```

## 下载这个示例
            
- [下载python源码: simple_axisline3.py](https://matplotlib.org/_downloads/simple_axisline3.py)
- [下载Jupyter notebook: simple_axisline3.ipynb](https://matplotlib.org/_downloads/simple_axisline3.ipynb)