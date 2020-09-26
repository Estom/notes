# 改变与盒子相交的线条的颜色

与矩形相交的线条用红色着色，而其他线条用蓝色线条留下。此示例展示了intersect_bbox函数。

![改变与盒子相交的线条的颜色示例](https://matplotlib.org/_images/sphx_glr_bbox_intersect_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.transforms import Bbox
from matplotlib.path import Path

# Fixing random state for reproducibility
np.random.seed(19680801)


left, bottom, width, height = (-1, -1, 2, 2)
rect = plt.Rectangle((left, bottom), width, height, facecolor="#aaaaaa")

fig, ax = plt.subplots()
ax.add_patch(rect)

bbox = Bbox.from_bounds(left, bottom, width, height)

for i in range(12):
    vertices = (np.random.random((2, 2)) - 0.5) * 6.0
    path = Path(vertices)
    if path.intersects_bbox(bbox):
        color = 'r'
    else:
        color = 'b'
    ax.plot(vertices[:, 0], vertices[:, 1], color=color)

plt.show()
```

## 下载这个示例
            
- [下载python源码: bbox_intersect.py](https://matplotlib.org/_downloads/bbox_intersect.py)
- [下载Jupyter notebook: bbox_intersect.ipynb](https://matplotlib.org/_downloads/bbox_intersect.ipynb)