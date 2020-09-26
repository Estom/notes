# 颜色栏刻度标签演示

为彩条生成自定义标签。

供稿人：Scott Sinclair

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm
from numpy.random import randn
```

使用垂直（默认）颜色条创建绘图

```python
fig, ax = plt.subplots()

data = np.clip(randn(250, 250), -1, 1)

cax = ax.imshow(data, interpolation='nearest', cmap=cm.coolwarm)
ax.set_title('Gaussian noise with vertical colorbar')

# Add colorbar, make sure to specify tick locations to match desired ticklabels
cbar = fig.colorbar(cax, ticks=[-1, 0, 1])
cbar.ax.set_yticklabels(['< -1', '0', '> 1'])  # vertically oriented colorbar
```

![颜色栏刻度标签示例](https://matplotlib.org/_images/sphx_glr_colorbar_tick_labelling_demo_001.png)

使用水平颜色条制作绘图

```python
fig, ax = plt.subplots()

data = np.clip(randn(250, 250), -1, 1)

cax = ax.imshow(data, interpolation='nearest', cmap=cm.afmhot)
ax.set_title('Gaussian noise with horizontal colorbar')

cbar = fig.colorbar(cax, ticks=[-1, 0, 1], orientation='horizontal')
cbar.ax.set_xticklabels(['Low', 'Medium', 'High'])  # horizontal colorbar

plt.show()
```

![颜色栏刻度标签示例2](https://matplotlib.org/_images/sphx_glr_colorbar_tick_labelling_demo_002.png)

## 下载这个示例
            
- [下载python源码: colorbar_tick_labelling_demo.py](https://matplotlib.org/_downloads/colorbar_tick_labelling_demo.py)
- [下载Jupyter notebook: colorbar_tick_labelling_demo.ipynb](https://matplotlib.org/_downloads/colorbar_tick_labelling_demo.ipynb)