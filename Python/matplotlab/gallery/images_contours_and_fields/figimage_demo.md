# Figimage 演示

这说明了在没有轴对象的情况下，直接将图像放置在图形中。

```python
import numpy as np
import matplotlib
import matplotlib.pyplot as plt


fig = plt.figure()
Z = np.arange(10000).reshape((100, 100))
Z[:, 50:] = 1

im1 = fig.figimage(Z, xo=50, yo=0, origin='lower')
im2 = fig.figimage(Z, xo=100, yo=100, alpha=.8, origin='lower')

plt.show()
```

![Figimage 演示](https://matplotlib.org/_images/sphx_glr_figimage_demo_001.png)

## 参考

本例中显示了下列函数、方法、类和模块的使用：

```python
matplotlib.figure.Figure
matplotlib.figure.Figure.figimage
matplotlib.pyplot.figimage
```

## 下载这个示例

- [下载python源码: figimage_demo.py](https://matplotlib.org/_downloads/figimage_demo.py)
- [下载Jupyter notebook: figimage_demo.ipynb](https://matplotlib.org/_downloads/figimage_demo.ipynb)