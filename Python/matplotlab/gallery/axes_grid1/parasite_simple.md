# 简单寄生示例

![简单寄生示例](https://matplotlib.org/_images/sphx_glr_parasite_simple_001.png)

```python
from mpl_toolkits.axes_grid1 import host_subplot
import matplotlib.pyplot as plt

host = host_subplot(111)

par = host.twinx()

host.set_xlabel("Distance")
host.set_ylabel("Density")
par.set_ylabel("Temperature")

p1, = host.plot([0, 1, 2], [0, 1, 2], label="Density")
p2, = par.plot([0, 1, 2], [0, 3, 2], label="Temperature")

leg = plt.legend()

host.yaxis.get_label().set_color(p1.get_color())
leg.texts[0].set_color(p1.get_color())

par.yaxis.get_label().set_color(p2.get_color())
leg.texts[1].set_color(p2.get_color())

plt.show()
```

## 下载这个示例
            
- [下载python源码: parasite_simple.py](https://matplotlib.org/_downloads/parasite_simple.py)
- [下载Jupyter notebook: parasite_simple.ipynb](https://matplotlib.org/_downloads/parasite_simple.ipynb)