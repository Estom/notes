# Colormap参考

Matplotlib附带的色彩映射参考。

通过将 ``_r`` 附加到名称（例如，``viridis_r``），可以获得每个这些颜色映射的反转版本。

请参阅在[Matplotlib中选择Colormaps](https://matplotlib.org/tutorials/colors/colormaps.html)以深入讨论色彩映射，包括colorblind-friendlyliness。

```python
import numpy as np
import matplotlib.pyplot as plt


cmaps = [('Perceptually Uniform Sequential', [
            'viridis', 'plasma', 'inferno', 'magma', 'cividis']),
         ('Sequential', [
            'Greys', 'Purples', 'Blues', 'Greens', 'Oranges', 'Reds',
            'YlOrBr', 'YlOrRd', 'OrRd', 'PuRd', 'RdPu', 'BuPu',
            'GnBu', 'PuBu', 'YlGnBu', 'PuBuGn', 'BuGn', 'YlGn']),
         ('Sequential (2)', [
            'binary', 'gist_yarg', 'gist_gray', 'gray', 'bone', 'pink',
            'spring', 'summer', 'autumn', 'winter', 'cool', 'Wistia',
            'hot', 'afmhot', 'gist_heat', 'copper']),
         ('Diverging', [
            'PiYG', 'PRGn', 'BrBG', 'PuOr', 'RdGy', 'RdBu',
            'RdYlBu', 'RdYlGn', 'Spectral', 'coolwarm', 'bwr', 'seismic']),
         ('Cyclic', ['twilight', 'twilight_shifted', 'hsv']),
         ('Qualitative', [
            'Pastel1', 'Pastel2', 'Paired', 'Accent',
            'Dark2', 'Set1', 'Set2', 'Set3',
            'tab10', 'tab20', 'tab20b', 'tab20c']),
         ('Miscellaneous', [
            'flag', 'prism', 'ocean', 'gist_earth', 'terrain', 'gist_stern',
            'gnuplot', 'gnuplot2', 'CMRmap', 'cubehelix', 'brg',
            'gist_rainbow', 'rainbow', 'jet', 'nipy_spectral', 'gist_ncar'])]


gradient = np.linspace(0, 1, 256)
gradient = np.vstack((gradient, gradient))


def plot_color_gradients(cmap_category, cmap_list):
    # Create figure and adjust figure height to number of colormaps
    nrows = len(cmap_list)
    figh = 0.35 + 0.15 + (nrows + (nrows-1)*0.1)*0.22
    fig, axes = plt.subplots(nrows=nrows, figsize=(6.4, figh))
    fig.subplots_adjust(top=1-.35/figh, bottom=.15/figh, left=0.2, right=0.99)

    axes[0].set_title(cmap_category + ' colormaps', fontsize=14)

    for ax, name in zip(axes, cmap_list):
        ax.imshow(gradient, aspect='auto', cmap=plt.get_cmap(name))
        ax.text(-.01, .5, name, va='center', ha='right', fontsize=10,
                transform=ax.transAxes)

    # Turn off *all* ticks & spines, not just the ones with colormaps.
    for ax in axes:
        ax.set_axis_off()


for cmap_category, cmap_list in cmaps:
    plot_color_gradients(cmap_category, cmap_list)

plt.show()
```

![Colormap参考示例](https://matplotlib.org/_images/sphx_glr_colormap_reference_001.png)

![Colormap参考示例2](https://matplotlib.org/_images/sphx_glr_colormap_reference_002.png)

![Colormap参考示例3](https://matplotlib.org/_images/sphx_glr_colormap_reference_003.png)

![Colormap参考示例4](https://matplotlib.org/_images/sphx_glr_colormap_reference_004.png)

![Colormap参考示例5](https://matplotlib.org/_images/sphx_glr_colormap_reference_005.png)

![Colormap参考示例6](https://matplotlib.org/_images/sphx_glr_colormap_reference_006.png)

![Colormap参考示例7](https://matplotlib.org/_images/sphx_glr_colormap_reference_007.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.colors
matplotlib.axes.Axes.imshow
matplotlib.figure.Figure.text
matplotlib.axes.Axes.set_axis_off
```

## 下载这个示例
            
- [下载python源码: colormap_reference.py](https://matplotlib.org/_downloads/colormap_reference.py)
- [下载Jupyter notebook: colormap_reference.ipynb](https://matplotlib.org/_downloads/colormap_reference.ipynb)