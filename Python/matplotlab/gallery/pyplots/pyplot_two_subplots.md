# Pyplot 绘制两个子图

使用pyplot.subplot创建带有两个子图的图形。

```python
import numpy as np
import matplotlib.pyplot as plt

def f(t):
    return np.exp(-t) * np.cos(2*np.pi*t)

t1 = np.arange(0.0, 5.0, 0.1)
t2 = np.arange(0.0, 5.0, 0.02)

plt.figure(1)
plt.subplot(211)
plt.plot(t1, f(t1), 'bo', t2, f(t2), 'k')

plt.subplot(212)
plt.plot(t2, np.cos(2*np.pi*t2), 'r--')
plt.show()
```

![Pyplot 绘制两个子图示例](https://matplotlib.org/_images/sphx_glr_pyplot_two_subplots_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.pyplot.figure
matplotlib.pyplot.subplot
```

## 下载这个示例
            
- [下载python源码: pyplot_two_subplots.py](https://matplotlib.org/_downloads/pyplot_two_subplots.py)
- [下载Jupyter notebook: pyplot_two_subplots.ipynb](https://matplotlib.org/_downloads/pyplot_two_subplots.ipynb)