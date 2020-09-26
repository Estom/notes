# 锚定Box02

![锚定Box02示例](https://matplotlib.org/_images/sphx_glr_anchored_box02_001.png)

```python
from matplotlib.patches import Circle
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1.anchored_artists import AnchoredDrawingArea


fig, ax = plt.subplots(figsize=(3, 3))

ada = AnchoredDrawingArea(40, 20, 0, 0,
                          loc='upper right', pad=0., frameon=False)
p1 = Circle((10, 10), 10)
ada.drawing_area.add_artist(p1)
p2 = Circle((30, 10), 5, fc="r")
ada.drawing_area.add_artist(p2)

ax.add_artist(ada)

plt.show()
```

## 下载这个示例
            
- [下载python源码: anchored_box02.py](https://matplotlib.org/_downloads/anchored_box02.py)
- [下载Jupyter notebook: anchored_box02.ipynb](https://matplotlib.org/_downloads/anchored_box02.ipynb)