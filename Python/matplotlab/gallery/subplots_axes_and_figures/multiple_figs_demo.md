# 多外形演示

使用多个图形窗口和子图形。

```python
import matplotlib.pyplot as plt
import numpy as np

t = np.arange(0.0, 2.0, 0.01)
s1 = np.sin(2*np.pi*t)
s2 = np.sin(4*np.pi*t)
```

Create figure 1

```python
plt.figure(1)
plt.subplot(211)
plt.plot(t, s1)
plt.subplot(212)
plt.plot(t, 2*s1)
```

![多外形演示](https://matplotlib.org/_images/sphx_glr_multiple_figs_demo_001.png)

Create figure 2

```python
plt.figure(2)
plt.plot(t, s2)
```

![多外形演示2](https://matplotlib.org/_images/sphx_glr_multiple_figs_demo_003.png)

Now switch back to figure 1 and make some changes

```python
plt.figure(1)
plt.subplot(211)
plt.plot(t, s2, 's')
ax = plt.gca()
ax.set_xticklabels([])

plt.show()
```

![多外形演示3](https://matplotlib.org/_images/sphx_glr_multiple_figs_demo_003.png)

## 下载这个示例
            
- [下载python源码: multiple_figs_demo.py](https://matplotlib.org/_downloads/multiple_figs_demo.py)
- [下载Jupyter notebook: multiple_figs_demo.ipynb](https://matplotlib.org/_downloads/multiple_figs_demo.ipynb)