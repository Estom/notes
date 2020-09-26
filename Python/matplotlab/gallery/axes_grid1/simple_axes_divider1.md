# 简单轴分割器示例1

![简单轴分割器示例1](https://matplotlib.org/_images/sphx_glr_simple_axes_divider1_001.png)

```python
from mpl_toolkits.axes_grid1 import Size, Divider
import matplotlib.pyplot as plt


fig1 = plt.figure(1, (6, 6))

# fixed size in inch
horiz = [Size.Fixed(1.), Size.Fixed(.5), Size.Fixed(1.5),
         Size.Fixed(.5)]
vert = [Size.Fixed(1.5), Size.Fixed(.5), Size.Fixed(1.)]

rect = (0.1, 0.1, 0.8, 0.8)
# divide the axes rectangle into grid whose size is specified by horiz * vert
divider = Divider(fig1, rect, horiz, vert, aspect=False)

# the rect parameter will be ignore as we will set axes_locator
ax1 = fig1.add_axes(rect, label="1")
ax2 = fig1.add_axes(rect, label="2")
ax3 = fig1.add_axes(rect, label="3")
ax4 = fig1.add_axes(rect, label="4")

ax1.set_axes_locator(divider.new_locator(nx=0, ny=0))
ax2.set_axes_locator(divider.new_locator(nx=0, ny=2))
ax3.set_axes_locator(divider.new_locator(nx=2, ny=2))
ax4.set_axes_locator(divider.new_locator(nx=2, nx1=4, ny=0))

plt.show()
```

## 下载这个示例
            
- [下载python源码: simple_axes_divider1.py](https://matplotlib.org/_downloads/simple_axes_divider1.py)
- [下载Jupyter notebook: simple_axes_divider1.ipynb](https://matplotlib.org/_downloads/simple_axes_divider1.ipynb)