# 茎状图示

茎图的绘制是从基线到y坐标的垂直线绘制cosine(x) w.r.t x，使用 '-.' 作为绘制垂直线的图案。

```python
import matplotlib.pyplot as plt
import numpy as np

# returns 10 evenly spaced samples from 0.1 to 2*PI
x = np.linspace(0.1, 2 * np.pi, 10)

markerline, stemlines, baseline = plt.stem(x, np.cos(x), '-.')

# setting property of baseline with color red and linewidth 2
plt.setp(baseline, color='r', linewidth=2)

plt.show()
```

![茎状图示图例3](https://matplotlib.org/_images/sphx_glr_stem_plot_001.png)

此示例使用了： * [matplotlib.axes.Axes.stem()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.stem.html#matplotlib.axes.Axes.stem)

## 下载这个示例

- [下载python源码: stem_plot.py](https://matplotlib.org/_downloads/stem_plot.py)
- [下载Jupyter notebook: stem_plot.ipynb](https://matplotlib.org/_downloads/stem_plot.ipynb)