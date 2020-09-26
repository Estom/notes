# 着色示例

显示如何制作阴影浮雕图的示例，如Mathematica （http://reference.wolfram.com/mathematica/ref/ReliefPlot.html）或通用映射工具（https://gmt.soest.hawaii.edu/）

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LightSource
from matplotlib.cbook import get_sample_data


def main():
    # Test data
    x, y = np.mgrid[-5:5:0.05, -5:5:0.05]
    z = 5 * (np.sqrt(x**2 + y**2) + np.sin(x**2 + y**2))

    filename = get_sample_data('jacksboro_fault_dem.npz', asfileobj=False)
    with np.load(filename) as dem:
        elev = dem['elevation']

    fig = compare(z, plt.cm.copper)
    fig.suptitle('HSV Blending Looks Best with Smooth Surfaces', y=0.95)

    fig = compare(elev, plt.cm.gist_earth, ve=0.05)
    fig.suptitle('Overlay Blending Looks Best with Rough Surfaces', y=0.95)

    plt.show()


def compare(z, cmap, ve=1):
    # Create subplots and hide ticks
    fig, axs = plt.subplots(ncols=2, nrows=2)
    for ax in axs.flat:
        ax.set(xticks=[], yticks=[])

    # Illuminate the scene from the northwest
    ls = LightSource(azdeg=315, altdeg=45)

    axs[0, 0].imshow(z, cmap=cmap)
    axs[0, 0].set(xlabel='Colormapped Data')

    axs[0, 1].imshow(ls.hillshade(z, vert_exag=ve), cmap='gray')
    axs[0, 1].set(xlabel='Illumination Intensity')

    rgb = ls.shade(z, cmap=cmap, vert_exag=ve, blend_mode='hsv')
    axs[1, 0].imshow(rgb)
    axs[1, 0].set(xlabel='Blend Mode: "hsv" (default)')

    rgb = ls.shade(z, cmap=cmap, vert_exag=ve, blend_mode='overlay')
    axs[1, 1].imshow(rgb)
    axs[1, 1].set(xlabel='Blend Mode: "overlay"')

    return fig


if __name__ == '__main__':
    main()
```

![着色示例](https://matplotlib.org/_images/sphx_glr_shading_example_001.png)

![着色示例2](https://matplotlib.org/_images/sphx_glr_shading_example_002.png) 

## 参考

本例中显示了以下函数、方法和类的使用：

```python
import matplotlib
matplotlib.colors.LightSource
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
```

## 下载这个示例

- [下载python源码: shading_example.py](https://matplotlib.org/_downloads/shading_example.py)
- [下载Jupyter notebook: shading_example.ipynb](https://matplotlib.org/_downloads/shading_example.ipynb)