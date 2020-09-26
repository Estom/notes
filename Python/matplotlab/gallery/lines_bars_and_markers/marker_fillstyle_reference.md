# 标记填充样式

Matplotlib中包含的标记填充样式的参考。

另请参阅 标记填充样式 和[标记路径示例](https://matplotlib.org/gallery/shapes_and_collections/marker_path.html)。

![标记填充样式图示](https://matplotlib.org/_images/sphx_glr_marker_fillstyle_reference_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D


points = np.ones(5)  # Draw 3 points for each line
text_style = dict(horizontalalignment='right', verticalalignment='center',
                  fontsize=12, fontdict={'family': 'monospace'})
marker_style = dict(color='cornflowerblue', linestyle=':', marker='o',
                    markersize=15, markerfacecoloralt='gray')


def format_axes(ax):
    ax.margins(0.2)
    ax.set_axis_off()


fig, ax = plt.subplots()

# Plot all fill styles.
for y, fill_style in enumerate(Line2D.fillStyles):
    ax.text(-0.5, y, repr(fill_style), **text_style)
    ax.plot(y * points, fillstyle=fill_style, **marker_style)
    format_axes(ax)
    ax.set_title('fill style')

plt.show()
```

## 下载这个示例

- [下载python源码: marker_fillstyle_reference.py](https://matplotlib.org/_downloads/marker_fillstyle_reference.py)
- [下载Jupyter notebook: marker_fillstyle_reference.ipynb](https://matplotlib.org/_downloads/marker_fillstyle_reference.ipynb)