# 线型样式参考

Matplotlib附带的线型参考。

![线型样式参考图示](https://matplotlib.org/_images/sphx_glr_line_styles_reference_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt


color = 'cornflowerblue'
points = np.ones(5)  # Draw 5 points for each line
text_style = dict(horizontalalignment='right', verticalalignment='center',
                  fontsize=12, fontdict={'family': 'monospace'})


def format_axes(ax):
    ax.margins(0.2)
    ax.set_axis_off()


# Plot all line styles.
fig, ax = plt.subplots()

linestyles = ['-', '--', '-.', ':']
for y, linestyle in enumerate(linestyles):
    ax.text(-0.1, y, repr(linestyle), **text_style)
    ax.plot(y * points, linestyle=linestyle, color=color, linewidth=3)
    format_axes(ax)
    ax.set_title('line styles')

plt.show()
```

## 下载这个示例

- [下载python源码: line_styles_reference.py](https://matplotlib.org/_downloads/line_styles_reference.py)
- [下载Jupyter notebook: line_styles_reference.ipynb](https://matplotlib.org/_downloads/line_styles_reference.ipynb)
