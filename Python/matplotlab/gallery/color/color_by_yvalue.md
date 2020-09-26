# 通过y-value绘制颜色

使用掩码数组以y值绘制具有不同颜色的线。

```python
import numpy as np
import matplotlib.pyplot as plt

t = np.arange(0.0, 2.0, 0.01)
s = np.sin(2 * np.pi * t)

upper = 0.77
lower = -0.77


supper = np.ma.masked_where(s < upper, s)
slower = np.ma.masked_where(s > lower, s)
smiddle = np.ma.masked_where(np.logical_or(s < lower, s > upper), s)

fig, ax = plt.subplots()
ax.plot(t, smiddle, t, slower, t, supper)
plt.show()
```

![y-value绘制颜色示例](https://matplotlib.org/_images/sphx_glr_color_by_yvalue_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.plot
matplotlib.pyplot.plot
```

## 下载这个示例
            
- [下载python源码: color_by_yvalue.py](https://matplotlib.org/_downloads/color_by_yvalue.py)
- [下载Jupyter notebook: color_by_yvalue.ipynb](https://matplotlib.org/_downloads/color_by_yvalue.ipynb)