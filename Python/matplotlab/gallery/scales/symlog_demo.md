# Symlog演示

示例使用symlog（对称对数）轴缩放。

![Symlog演示](https://matplotlib.org/_images/sphx_glr_symlog_demo_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

dt = 0.01
x = np.arange(-50.0, 50.0, dt)
y = np.arange(0, 100.0, dt)

plt.subplot(311)
plt.plot(x, y)
plt.xscale('symlog')
plt.ylabel('symlogx')
plt.grid(True)
plt.gca().xaxis.grid(True, which='minor')  # minor grid on too

plt.subplot(312)
plt.plot(y, x)
plt.yscale('symlog')
plt.ylabel('symlogy')

plt.subplot(313)
plt.plot(x, np.sin(x / 3.0))
plt.xscale('symlog')
plt.yscale('symlog', linthreshy=0.015)
plt.grid(True)
plt.ylabel('symlog both')

plt.tight_layout()
plt.show()
```

## 下载这个示例
            
- [下载python源码: symlog_demo.py](https://matplotlib.org/_downloads/symlog_demo.py)
- [下载Jupyter notebook: symlog_demo.ipynb](https://matplotlib.org/_downloads/symlog_demo.ipynb)