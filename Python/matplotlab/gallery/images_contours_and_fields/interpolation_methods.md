# imshow或matshow的插值

这个示例显示了[imshow()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.imshow.html#matplotlib.axes.Axes.imshow) 和[matshow()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.matshow.html#matplotlib.axes.Axes.matshow)的插值方法之间的区别。

如果插值为无，则默认为图像。插值RC参数。如果插值是 “none” ，则不执行插值的Agg，ps和pdf后端。其他后端将默认为“nearest”。

对于Agg、ps和pdf后端，当大图像缩小时，``interpolation = 'none'`` 工作得很好，而当小图像被放大时，interpolation = ``'interpolation = 'none'`` 则运行正常。

```python
import matplotlib.pyplot as plt
import numpy as np

methods = [None, 'none', 'nearest', 'bilinear', 'bicubic', 'spline16',
           'spline36', 'hanning', 'hamming', 'hermite', 'kaiser', 'quadric',
           'catrom', 'gaussian', 'bessel', 'mitchell', 'sinc', 'lanczos']

# Fixing random state for reproducibility
np.random.seed(19680801)

grid = np.random.rand(4, 4)

fig, axs = plt.subplots(nrows=3, ncols=6, figsize=(9.3, 6),
                        subplot_kw={'xticks': [], 'yticks': []})

fig.subplots_adjust(left=0.03, right=0.97, hspace=0.3, wspace=0.05)

for ax, interp_method in zip(axs.flat, methods):
    ax.imshow(grid, interpolation=interp_method, cmap='viridis')
    ax.set_title(str(interp_method))

plt.tight_layout()
plt.show()
```

![imshow或matshow的插值](https://matplotlib.org/_images/sphx_glr_interpolation_methods_001.png)

## 参考

下面的示例演示了以下函数和方法的使用：

```python
import matplotlib
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
```

## 下载这个示例

- [下载python源码: interpolation_methods.py](https://matplotlib.org/_downloads/interpolation_methods.py)
- [下载Jupyter notebook: interpolation_methods.ipynb](https://matplotlib.org/_downloads/interpolation_methods.ipynb)