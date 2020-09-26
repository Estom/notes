# 简单Coord03注释示例

![简单Coord03注释示例](https://matplotlib.org/_images/sphx_glr_annotate_simple_coord03_001.png)

```python
import matplotlib.pyplot as plt
from matplotlib.text import OffsetFrom


fig, ax = plt.subplots(figsize=(3, 2))
an1 = ax.annotate("Test 1", xy=(0.5, 0.5), xycoords="data",
                  va="center", ha="center",
                  bbox=dict(boxstyle="round", fc="w"))

offset_from = OffsetFrom(an1, (0.5, 0))
an2 = ax.annotate("Test 2", xy=(0.1, 0.1), xycoords="data",
                  xytext=(0, -10), textcoords=offset_from,
                  # xytext is offset points from "xy=(0.5, 0), xycoords=an1"
                  va="top", ha="center",
                  bbox=dict(boxstyle="round", fc="w"),
                  arrowprops=dict(arrowstyle="->"))
plt.show()
```

## 下载这个示例
            
- [下载python源码: annotate_simple_coord03.py](https://matplotlib.org/_downloads/annotate_simple_coord03.py)
- [下载Jupyter notebook: annotate_simple_coord03.ipynb](https://matplotlib.org/_downloads/annotate_simple_coord03.ipynb)