# 创建相邻的子图

要创建共享公共轴（可视化）的图，可以将子图之间的hspace设置为零。 在创建子图时传递sharex = True将自动关闭除底部轴上的所有x刻度和标签。

在此示例中，绘图共享一个公共x轴，但您可以遵循相同的逻辑来提供公共y轴。

![](https://matplotlib.org/_images/sphx_glr_ganged_plots_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

t = np.arange(0.0, 2.0, 0.01)

s1 = np.sin(2 * np.pi * t)
s2 = np.exp(-t)
s3 = s1 * s2

fig, axs = plt.subplots(3, 1, sharex=True)
# Remove horizontal space between axes
fig.subplots_adjust(hspace=0)

# Plot each graph, and manually set the y tick values
axs[0].plot(t, s1)
axs[0].set_yticks(np.arange(-0.9, 1.0, 0.4))
axs[0].set_ylim(-1, 1)

axs[1].plot(t, s2)
axs[1].set_yticks(np.arange(0.1, 1.0, 0.2))
axs[1].set_ylim(0, 1)

axs[2].plot(t, s3)
axs[2].set_yticks(np.arange(-0.9, 1.0, 0.4))
axs[2].set_ylim(-1, 1)

plt.show()
```

## 下载这个示例
            
- [下载python源码: ganged_plots.py](https://matplotlib.org/_downloads/ganged_plots.py)
- [下载Jupyter notebook: ganged_plots.ipynb](https://matplotlib.org/_downloads/ganged_plots.ipynb)