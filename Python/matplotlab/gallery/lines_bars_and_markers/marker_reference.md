# 标记参考

使用Matplotlib参考填充，未填充和自定义标记类型。

有关所有标记的列表，请参阅 [matplotlib.markers](https://matplotlib.org/api/markers_api.html#module-matplotlib.markers) 文档。 另请参阅 [标记填充样式](/gallery/lines_bars_and_markers/marker_fillstyle_reference.html) 和 [标记路径示例](https://matplotlib.org/gallery/shapes_and_collections/marker_path.html)。

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D


points = np.ones(3)  # Draw 3 points for each line
text_style = dict(horizontalalignment='right', verticalalignment='center',
                  fontsize=12, fontdict={'family': 'monospace'})
marker_style = dict(linestyle=':', color='0.8', markersize=10,
                    mfc="C0", mec="C0")


def format_axes(ax):
    ax.margins(0.2)
    ax.set_axis_off()
    ax.invert_yaxis()


def nice_repr(text):
    return repr(text).lstrip('u')


def math_repr(text):
    tx = repr(text).lstrip('u').strip("'").strip("$")
    return r"'\${}\$'".format(tx)


def split_list(a_list):
    i_half = len(a_list) // 2
    return (a_list[:i_half], a_list[i_half:])
```

## 填充和未填充标记类型

绘制所有未填充的标记

```python
fig, axes = plt.subplots(ncols=2)
fig.suptitle('un-filled markers', fontsize=14)

# Filter out filled markers and marker settings that do nothing.
unfilled_markers = [m for m, func in Line2D.markers.items()
                    if func != 'nothing' and m not in Line2D.filled_markers]

for ax, markers in zip(axes, split_list(unfilled_markers)):
    for y, marker in enumerate(markers):
        ax.text(-0.5, y, nice_repr(marker), **text_style)
        ax.plot(y * points, marker=marker, **marker_style)
        format_axes(ax)

plt.show()
```

![未填充标记图示](https://matplotlib.org/_images/sphx_glr_marker_reference_001.png)

绘制所有填满的标记。

```python
fig, axes = plt.subplots(ncols=2)
for ax, markers in zip(axes, split_list(Line2D.filled_markers)):
    for y, marker in enumerate(markers):
        ax.text(-0.5, y, nice_repr(marker), **text_style)
        ax.plot(y * points, marker=marker, **marker_style)
        format_axes(ax)
fig.suptitle('filled markers', fontsize=14)

plt.show()
```

![已填充充标记图示](https://matplotlib.org/_images/sphx_glr_marker_reference_002.png)

## 带有MathText的自定义标记

使用[MathText](https://matplotlib.org/tutorials/text/mathtext.html)，使用自定义标记符号，例如“$\$ u266B”。有关STIX字体符号的概述，请参阅[STIX字体表](http://www.stixfonts.org/allGlyphs.html)。另请参阅[STIX字体演示](https://matplotlib.org/gallery/text_labels_and_annotations/stix_fonts_demo.html)。

```python
fig, ax = plt.subplots()
fig.subplots_adjust(left=0.4)

marker_style.update(mec="None", markersize=15)
markers = ["$1$", r"$\frac{1}{2}$", "$f$", "$\u266B$",
           r"$\mathcircled{m}$"]


for y, marker in enumerate(markers):
    ax.text(-0.5, y, math_repr(marker), **text_style)
    ax.plot(y * points, marker=marker, **marker_style)
format_axes(ax)

plt.show()
```

![带有MathText的自定义标记图示](https://matplotlib.org/_images/sphx_glr_marker_reference_003.png)

## 下载这个示例

- [下载python源码: marker_reference.py](https://matplotlib.org/_downloads/marker_reference.py)
- [下载Jupyter notebook: marker_reference.ipynb](https://matplotlib.org/_downloads/marker_reference.ipynb)