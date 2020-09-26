# 灰度样式表

此示例演示“灰度”样式表，该样式表将定义为rc参数的所有颜色更改为灰度。 但请注意，并非所有绘图元素都默认为rc参数定义的颜色。

![灰度样式表示例](https://matplotlib.org/_images/sphx_glr_grayscale_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)


def color_cycle_example(ax):
    L = 6
    x = np.linspace(0, L)
    ncolors = len(plt.rcParams['axes.prop_cycle'])
    shift = np.linspace(0, L, ncolors, endpoint=False)
    for s in shift:
        ax.plot(x, np.sin(x + s), 'o-')


def image_and_patch_example(ax):
    ax.imshow(np.random.random(size=(20, 20)), interpolation='none')
    c = plt.Circle((5, 5), radius=5, label='patch')
    ax.add_patch(c)


plt.style.use('grayscale')

fig, (ax1, ax2) = plt.subplots(ncols=2)
fig.suptitle("'grayscale' style sheet")

color_cycle_example(ax1)
image_and_patch_example(ax2)

plt.show()
```

## 下载这个示例
            
- [下载python源码: grayscale.py](https://matplotlib.org/_downloads/grayscale.py)
- [下载Jupyter notebook: grayscale.ipynb](https://matplotlib.org/_downloads/grayscale.ipynb)