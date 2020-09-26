# 演示固定尺寸轴

![演示固定尺寸轴](https://matplotlib.org/_images/sphx_glr_demo_fixed_size_axes_001.png)

![演示固定尺寸轴2](https://matplotlib.org/_images/sphx_glr_demo_fixed_size_axes_002.png)

```python
import matplotlib.pyplot as plt

from mpl_toolkits.axes_grid1 import Divider, Size
from mpl_toolkits.axes_grid1.mpl_axes import Axes


def demo_fixed_size_axes():
    fig1 = plt.figure(1, (6, 6))

    # The first items are for padding and the second items are for the axes.
    # sizes are in inch.
    h = [Size.Fixed(1.0), Size.Fixed(4.5)]
    v = [Size.Fixed(0.7), Size.Fixed(5.)]

    divider = Divider(fig1, (0.0, 0.0, 1., 1.), h, v, aspect=False)
    # the width and height of the rectangle is ignored.

    ax = Axes(fig1, divider.get_position())
    ax.set_axes_locator(divider.new_locator(nx=1, ny=1))

    fig1.add_axes(ax)

    ax.plot([1, 2, 3])


def demo_fixed_pad_axes():
    fig = plt.figure(2, (6, 6))

    # The first & third items are for padding and the second items are for the
    # axes. Sizes are in inches.
    h = [Size.Fixed(1.0), Size.Scaled(1.), Size.Fixed(.2)]
    v = [Size.Fixed(0.7), Size.Scaled(1.), Size.Fixed(.5)]

    divider = Divider(fig, (0.0, 0.0, 1., 1.), h, v, aspect=False)
    # the width and height of the rectangle is ignored.

    ax = Axes(fig, divider.get_position())
    ax.set_axes_locator(divider.new_locator(nx=1, ny=1))

    fig.add_axes(ax)

    ax.plot([1, 2, 3])


if __name__ == "__main__":
    demo_fixed_size_axes()
    demo_fixed_pad_axes()

    plt.show()
```

## 下载这个示例
            
- [下载python源码: demo_fixed_size_axes.py](https://matplotlib.org/_downloads/demo_fixed_size_axes.py)
- [下载Jupyter notebook: demo_fixed_size_axes.ipynb](https://matplotlib.org/_downloads/demo_fixed_size_axes.ipynb)