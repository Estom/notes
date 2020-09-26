# 锚定Box04

![锚定Box04示例](https://matplotlib.org/_images/sphx_glr_anchored_box04_001.png)

```python
from matplotlib.patches import Ellipse
import matplotlib.pyplot as plt
from matplotlib.offsetbox import (AnchoredOffsetbox, DrawingArea, HPacker,
                                  TextArea)


fig, ax = plt.subplots(figsize=(3, 3))

box1 = TextArea(" Test : ", textprops=dict(color="k"))

box2 = DrawingArea(60, 20, 0, 0)
el1 = Ellipse((10, 10), width=16, height=5, angle=30, fc="r")
el2 = Ellipse((30, 10), width=16, height=5, angle=170, fc="g")
el3 = Ellipse((50, 10), width=16, height=5, angle=230, fc="b")
box2.add_artist(el1)
box2.add_artist(el2)
box2.add_artist(el3)

box = HPacker(children=[box1, box2],
              align="center",
              pad=0, sep=5)

anchored_box = AnchoredOffsetbox(loc='lower left',
                                 child=box, pad=0.,
                                 frameon=True,
                                 bbox_to_anchor=(0., 1.02),
                                 bbox_transform=ax.transAxes,
                                 borderpad=0.,
                                 )

ax.add_artist(anchored_box)

fig.subplots_adjust(top=0.8)
plt.show()
```

## 下载这个示例
            
- [下载python源码: anchored_box04.py](https://matplotlib.org/_downloads/anchored_box04.py)
- [下载Jupyter notebook: anchored_box04.ipynb](https://matplotlib.org/_downloads/anchored_box04.ipynb)