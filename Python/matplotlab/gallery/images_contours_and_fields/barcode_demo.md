# 条形码示例

该演示展示了如何生成一维图像或“条形码”。

```python
import matplotlib.pyplot as plt
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)


# the bar
x = np.where(np.random.rand(500) > 0.7, 1.0, 0.0)

axprops = dict(xticks=[], yticks=[])
barprops = dict(aspect='auto', cmap=plt.cm.binary, interpolation='nearest')

fig = plt.figure()

# a vertical barcode
ax1 = fig.add_axes([0.1, 0.3, 0.1, 0.6], **axprops)
ax1.imshow(x.reshape((-1, 1)), **barprops)

# a horizontal barcode
ax2 = fig.add_axes([0.3, 0.1, 0.6, 0.1], **axprops)
ax2.imshow(x.reshape((1, -1)), **barprops)


plt.show()
```

![条形码示例](https://matplotlib.org/_images/sphx_glr_barcode_demo_001.png)

## 参考

此示例中显示了以下函数，方法和类的使用：

```python
import matplotlib
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
```

## 下载这个示例

- [下载python源码: barcode_demo.py](https://matplotlib.org/_downloads/barcode_demo.py)
- [下载Jupyter notebook: barcode_demo.ipynb](https://matplotlib.org/_downloads/barcode_demo.ipynb)