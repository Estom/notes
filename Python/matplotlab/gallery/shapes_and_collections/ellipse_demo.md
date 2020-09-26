# 椭圆演示

绘制多个椭圆。此处绘制单个椭圆。将其与[Ellipse集合示例](https://matplotlib.org/gallery/shapes_and_collections/ellipse_collection.html)进行比较。

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Ellipse

NUM = 250

ells = [Ellipse(xy=np.random.rand(2) * 10,
                width=np.random.rand(), height=np.random.rand(),
                angle=np.random.rand() * 360)
        for i in range(NUM)]

fig, ax = plt.subplots(subplot_kw={'aspect': 'equal'})
for e in ells:
    ax.add_artist(e)
    e.set_clip_box(ax.bbox)
    e.set_alpha(np.random.rand())
    e.set_facecolor(np.random.rand(3))

ax.set_xlim(0, 10)
ax.set_ylim(0, 10)

plt.show()
```

![椭圆演示](https://matplotlib.org/_images/sphx_glr_ellipse_demo_001.png)

# 椭圆旋转

绘制许多不同角度的椭圆。

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Ellipse

delta = 45.0  # degrees

angles = np.arange(0, 360 + delta, delta)
ells = [Ellipse((1, 1), 4, 2, a) for a in angles]

a = plt.subplot(111, aspect='equal')

for e in ells:
    e.set_clip_box(a.bbox)
    e.set_alpha(0.1)
    a.add_artist(e)

plt.xlim(-2, 4)
plt.ylim(-1, 3)

plt.show()
```

![椭圆演示2](https://matplotlib.org/_images/sphx_glr_ellipse_demo_002.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.patches
matplotlib.patches.Ellipse
matplotlib.axes.Axes.add_artist
matplotlib.artist.Artist.set_clip_box
matplotlib.artist.Artist.set_alpha
matplotlib.patches.Patch.set_facecolor
```

## 下载这个示例

- [下载python源码: ellipse_demo.py](https://matplotlib.org/_downloads/ellipse_demo.py)
- [下载Jupyter notebook: ellipse_demo.ipynb](https://matplotlib.org/_downloads/ellipse_demo.ipynb)