# 在顶部设置默认的x轴刻度标签

我们可以使用 [rcParams["xtick.labeltop"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams)（默认为False）和[rcParams["xtick.top"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams)（默认为False）和[rcParams["xtick.labelbottom"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams)（默认为True）和 [rcParams["xtick.bottom"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams) （默认为True）控制轴上的刻度和标签出现的位置。

这些属性也可以在.matplotlib / matplotlibrc中设置。

![在顶部设置默认的x轴刻度标签示例](https://matplotlib.org/_images/sphx_glr_tick_xlabel_top_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np


plt.rcParams['xtick.bottom'] = plt.rcParams['xtick.labelbottom'] = False
plt.rcParams['xtick.top'] = plt.rcParams['xtick.labeltop'] = True

x = np.arange(10)

fig, ax = plt.subplots()

ax.plot(x)
ax.set_title('xlabel top')  # Note title moves to make room for ticks

plt.show()
```

## 下载这个示例
            
- [下载python源码: tick_xlabel_top.py](https://matplotlib.org/_downloads/tick_xlabel_top.py)
- [下载Jupyter notebook: tick_xlabel_top.ipynb](https://matplotlib.org/_downloads/tick_xlabel_top.ipynb)