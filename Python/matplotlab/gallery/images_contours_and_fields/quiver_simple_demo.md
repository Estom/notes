# 箭图简单演示

带[quiverkey](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.quiver.html#matplotlib.axes.Axes.quiver)的[箭袋图](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.quiver.html#matplotlib.axes.Axes.quiver)的简单示例。

有关更高级的选项，请参阅演示[高级箭袋和quiverkey功能](https://matplotlib.org/gallery/images_contours_and_fields/quiver_demo.html)。

```python
import matplotlib.pyplot as plt
import numpy as np

X = np.arange(-10, 10, 1)
Y = np.arange(-10, 10, 1)
U, V = np.meshgrid(X, Y)

fig, ax = plt.subplots()
q = ax.quiver(X, Y, U, V)
ax.quiverkey(q, X=0.3, Y=1.1, U=10,
             label='Quiver key, length = 10', labelpos='E')

plt.show()
```

![箭图简单演示](https://matplotlib.org/_images/sphx_glr_quiver_simple_demo_001.png)

## 参考

此示例中显示了以下函数和方法的用法：

```python
import matplotlib
matplotlib.axes.Axes.quiver
matplotlib.pyplot.quiver
matplotlib.axes.Axes.quiverkey
matplotlib.pyplot.quiverkey
```

## 下载这个示例

- [下载python源码: quiver_simple_demo.py](https://matplotlib.org/_downloads/quiver_simple_demo.py)
- [下载Jupyter notebook: quiver_simple_demo.ipynb](https://matplotlib.org/_downloads/quiver_simple_demo.ipynb)