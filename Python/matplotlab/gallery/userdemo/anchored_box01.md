# 锚定Box01

![锚定Box01示例](https://matplotlib.org/_images/sphx_glr_anchored_box01_001.png)

```python
import matplotlib.pyplot as plt
from matplotlib.offsetbox import AnchoredText


fig, ax = plt.subplots(figsize=(3, 3))

at = AnchoredText("Figure 1a",
                  prop=dict(size=15), frameon=True, loc='upper left')
at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
ax.add_artist(at)

plt.show()
```

## 下载这个示例
            
- [下载python源码: anchored_box01.py](https://matplotlib.org/_downloads/anchored_box01.py)
- [下载Jupyter notebook: anchored_box01.ipynb](https://matplotlib.org/_downloads/anchored_box01.ipynb)