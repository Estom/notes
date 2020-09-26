# 撰写自定义图例

Composing custom legends piece-by-piece.

**注意**：

For more information on creating and customizing legends, see the following pages:

- [Legend guide](https://matplotlib.org/tutorials/intermediate/legend_guide.html)
- [Legend Demo](https://matplotlib.org/tutorials/intermediate/legend_guide.html)

有时您不希望与已绘制的数据明确关联的图例。例如，假设您已绘制了10行，但不希望每个行都显示图例项。如果您只是绘制线条并调用ax.legend()，您将获得以下内容：

```python
# sphinx_gallery_thumbnail_number = 2
from matplotlib import rcParams, cycler
import matplotlib.pyplot as plt
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)

N = 10
data = [np.logspace(0, 1, 100) + np.random.randn(100) + ii for ii in range(N)]
data = np.array(data).T
cmap = plt.cm.coolwarm
rcParams['axes.prop_cycle'] = cycler(color=cmap(np.linspace(0, 1, N)))

fig, ax = plt.subplots()
lines = ax.plot(data)
ax.legend(lines)
```

![撰写自定义图例](https://matplotlib.org/_images/sphx_glr_custom_legends_001.png)

请注意，每行创建一个图例项。在这种情况下，我们可以使用未明确绑定到绘制数据的Matplotlib对象组成图例。例如：

```python
from matplotlib.lines import Line2D
custom_lines = [Line2D([0], [0], color=cmap(0.), lw=4),
                Line2D([0], [0], color=cmap(.5), lw=4),
                Line2D([0], [0], color=cmap(1.), lw=4)]

fig, ax = plt.subplots()
lines = ax.plot(data)
ax.legend(custom_lines, ['Cold', 'Medium', 'Hot'])
```

![撰写自定义图例2](https://matplotlib.org/_images/sphx_glr_custom_legends_002.png)

还有许多其他Matplotlib对象可以这种方式使用。 在下面的代码中，我们列出了一些常见的代码。

```python
from matplotlib.patches import Patch
from matplotlib.lines import Line2D

legend_elements = [Line2D([0], [0], color='b', lw=4, label='Line'),
                   Line2D([0], [0], marker='o', color='w', label='Scatter',
                          markerfacecolor='g', markersize=15),
                   Patch(facecolor='orange', edgecolor='r',
                         label='Color Patch')]

# Create the figure
fig, ax = plt.subplots()
ax.legend(handles=legend_elements, loc='center')

plt.show()
```

![撰写自定义图例3](https://matplotlib.org/_images/sphx_glr_custom_legends_003.png)

## 下载这个示例
            
- [下载python源码: custom_legends.py](https://matplotlib.org/_downloads/custom_legends.py)
- [下载Jupyter notebook: custom_legends.ipynb](https://matplotlib.org/_downloads/custom_legends.ipynb)