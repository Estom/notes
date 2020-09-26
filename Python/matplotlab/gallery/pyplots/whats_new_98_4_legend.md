# 0.98.4版本图例新特性

创建图例并使用阴影和长方体对其进行调整。

```python
import matplotlib.pyplot as plt
import numpy as np


ax = plt.subplot(111)
t1 = np.arange(0.0, 1.0, 0.01)
for n in [1, 2, 3, 4]:
    plt.plot(t1, t1**n, label="n=%d"%(n,))

leg = plt.legend(loc='best', ncol=2, mode="expand", shadow=True, fancybox=True)
leg.get_frame().set_alpha(0.5)


plt.show()
```

![新特性图例示例](https://matplotlib.org/_images/sphx_glr_whats_new_98_4_legend_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.legend
matplotlib.pyplot.legend
matplotlib.legend.Legend
matplotlib.legend.Legend.get_frame
```

## 下载这个示例
            
- [下载python源码: whats_new_98_4_legend.py](https://matplotlib.org/_downloads/whats_new_98_4_legend.py)
- [下载Jupyter notebook: whats_new_98_4_legend.ipynb](https://matplotlib.org/_downloads/whats_new_98_4_legend.ipynb)