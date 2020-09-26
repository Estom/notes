# 演示带轴分割器的颜色条

![演示带轴分割器的颜色条](https://matplotlib.org/_images/sphx_glr_demo_colorbar_with_axes_divider_001.png)

```python
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1.axes_divider import make_axes_locatable
from mpl_toolkits.axes_grid1.colorbar import colorbar

fig, (ax1, ax2) = plt.subplots(1, 2)
fig.subplots_adjust(wspace=0.5)

im1 = ax1.imshow([[1, 2], [3, 4]])
ax1_divider = make_axes_locatable(ax1)
cax1 = ax1_divider.append_axes("right", size="7%", pad="2%")
cb1 = colorbar(im1, cax=cax1)

im2 = ax2.imshow([[1, 2], [3, 4]])
ax2_divider = make_axes_locatable(ax2)
cax2 = ax2_divider.append_axes("top", size="7%", pad="2%")
cb2 = colorbar(im2, cax=cax2, orientation="horizontal")
cax2.xaxis.set_ticks_position("top")

plt.show()
```

## 下载这个示例
            
- [下载python源码: demo_colorbar_with_axes_divider.py](https://matplotlib.org/_downloads/demo_colorbar_with_axes_divider.py)
- [下载Jupyter notebook: demo_colorbar_with_axes_divider.ipynb](https://matplotlib.org/_downloads/demo_colorbar_with_axes_divider.ipynb)