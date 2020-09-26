# 锚定Box03

![锚定Box03示例](https://matplotlib.org/_images/sphx_glr_anchored_box03_001.png)

```python
from matplotlib.patches import Ellipse
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1.anchored_artists import AnchoredAuxTransformBox


fig, ax = plt.subplots(figsize=(3, 3))

box = AnchoredAuxTransformBox(ax.transData, loc='upper left')
el = Ellipse((0, 0), width=0.1, height=0.4, angle=30)  # in data coordinates!
box.drawing_area.add_artist(el)

ax.add_artist(box)

plt.show()
```

## 下载这个示例
            
- [下载python源码: anchored_box03.py](https://matplotlib.org/_downloads/anchored_box03.py)
- [下载Jupyter notebook: anchored_box03.ipynb](https://matplotlib.org/_downloads/anchored_box03.ipynb)