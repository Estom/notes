# 带有单位的注释

该示例说明了如何使用厘米级绘图创建文本和箭头注释。

此示例需要 [basic_units.py](https://matplotlib.org/_downloads/3a73b4cd6e12aa53ff277b1b80d631c1/basic_units.py)

![带有单位的注释示例](https://matplotlib.org/_images/sphx_glr_annotate_with_units_001.png)

```python
import matplotlib.pyplot as plt
from basic_units import cm

fig, ax = plt.subplots()

ax.annotate("Note 01", [0.5*cm, 0.5*cm])

# xy and text both unitized
ax.annotate('local max', xy=(3*cm, 1*cm), xycoords='data',
            xytext=(0.8*cm, 0.95*cm), textcoords='data',
            arrowprops=dict(facecolor='black', shrink=0.05),
            horizontalalignment='right', verticalalignment='top')

# mixing units w/ nonunits
ax.annotate('local max', xy=(3*cm, 1*cm), xycoords='data',
            xytext=(0.8, 0.95), textcoords='axes fraction',
            arrowprops=dict(facecolor='black', shrink=0.05),
            horizontalalignment='right', verticalalignment='top')


ax.set_xlim(0*cm, 4*cm)
ax.set_ylim(0*cm, 4*cm)
plt.show()
```
## 下载这个示例
            
- [下载python源码: annotate_with_units.py](https://matplotlib.org/_downloads/annotate_with_units.py)
- [下载Jupyter notebook: annotate_with_units.ipynb](https://matplotlib.org/_downloads/annotate_with_units.ipynb)