# Pyplot 绘制三条线

在一次调用 [plot](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.plot.html#matplotlib.pyplot.plot) 绘图中绘制三个线图。

```python
import numpy as np
import matplotlib.pyplot as plt

# evenly sampled time at 200ms intervals
t = np.arange(0., 5., 0.2)

# red dashes, blue squares and green triangles
plt.plot(t, t, 'r--', t, t**2, 'bs', t, t**3, 'g^')
plt.show()
```

![Pyplot 绘制三条线示例](https://matplotlib.org/_images/sphx_glr_pyplot_three_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.pyplot.plot
matplotlib.axes.Axes.plot
```

## 下载这个示例
            
- [下载python源码: pyplot_three.py](https://matplotlib.org/_downloads/pyplot_three.py)
- [下载Jupyter notebook: pyplot_three.ipynb](https://matplotlib.org/_downloads/pyplot_three.ipynb)