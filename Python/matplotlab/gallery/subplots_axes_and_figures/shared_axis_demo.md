# 共享轴演示

通过将轴实例作为sharex或sharey kwarg传递，可以将一个轴的x或y轴限制与另一个轴共享。

更改一个轴上的轴限制将自动反映在另一个轴上，反之亦然，因此当您使用工具栏导航时，轴将在其共享轴上相互跟随。同样适用于轴缩放的变化（例如，log vs linear）。但是，刻度标签可能存在差异，例如，您可以选择性地关闭一个轴上的刻度标签。

下面的示例显示了如何在各个轴上自定义刻度标签。共享轴共享刻度定位器，刻度格式化程序，视图限制和变换（例如，对数，线性）。但是，ticklabels本身并不共享属性。这是一个功能而不是误差，因为您可能希望在上轴上使刻度标签更小，例如，在下面的示例中。

如果要关闭给定轴的刻度标签（例如，在子图（211）或子图（212）上），则无法执行标准技巧：

```python
setp(ax2, xticklabels=[])
```

因为这会更改在所有轴之间共享的Tick格式化程序。但您可以更改标签的可见性，这是一个特性：

```python
setp(ax2.get_xticklabels(), visible=False)
```

![共享轴演示](https://matplotlib.org/_images/sphx_glr_shared_axis_demo_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

t = np.arange(0.01, 5.0, 0.01)
s1 = np.sin(2 * np.pi * t)
s2 = np.exp(-t)
s3 = np.sin(4 * np.pi * t)

ax1 = plt.subplot(311)
plt.plot(t, s1)
plt.setp(ax1.get_xticklabels(), fontsize=6)

# share x only
ax2 = plt.subplot(312, sharex=ax1)
plt.plot(t, s2)
# make these tick labels invisible
plt.setp(ax2.get_xticklabels(), visible=False)

# share x and y
ax3 = plt.subplot(313, sharex=ax1, sharey=ax1)
plt.plot(t, s3)
plt.xlim(0.01, 5.0)
plt.show()
```

## 下载这个示例
            
- [下载python源码: shared_axis_demo.py](https://matplotlib.org/_downloads/shared_axis_demo.py)
- [下载Jupyter notebook: shared_axis_demo.ipynb](https://matplotlib.org/_downloads/shared_axis_demo.ipynb)