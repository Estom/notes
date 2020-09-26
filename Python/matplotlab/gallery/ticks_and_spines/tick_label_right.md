# 在右侧设置默认的y轴刻度标签

我们可以使用[rcParams["ytick.labelright"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams)（默认为False）和[rcParams["ytick.right"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams)（默认为False）和[rcParams["ytick.labelleft"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams)（默认为True）和 [rcParams["ytick.left"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams)（默认为True）控制轴上的刻度和标签出现的位置。这些属性也可以在.matplotlib / matplotlibrc中设置。

![在右侧设置默认的y轴刻度标签示例](https://matplotlib.org/_images/sphx_glr_tick_label_right_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

plt.rcParams['ytick.right'] = plt.rcParams['ytick.labelright'] = True
plt.rcParams['ytick.left'] = plt.rcParams['ytick.labelleft'] = False

x = np.arange(10)

fig, (ax0, ax1) = plt.subplots(2, 1, sharex=True, figsize=(6, 6))

ax0.plot(x)
ax0.yaxis.tick_left()

# use default parameter in rcParams, not calling tick_right()
ax1.plot(x)

plt.show()
```

## 下载这个示例
            
-[下载python源码: tick_label_right.py](https://matplotlib.org/_downloads/tick_label_right.py)
-[下载Jupyter notebook: tick_label_right.ipynb](https://matplotlib.org/_downloads/tick_label_right.ipynb)