# 衰变

这个例子展示了：
- 使用生成器来驱动动画，
- 在动画期间更改轴限制。

![衰变示例](https://matplotlib.org/_images/sphx_glr_animate_decay_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation


def data_gen(t=0):
    cnt = 0
    while cnt < 1000:
        cnt += 1
        t += 0.1
        yield t, np.sin(2*np.pi*t) * np.exp(-t/10.)


def init():
    ax.set_ylim(-1.1, 1.1)
    ax.set_xlim(0, 10)
    del xdata[:]
    del ydata[:]
    line.set_data(xdata, ydata)
    return line,

fig, ax = plt.subplots()
line, = ax.plot([], [], lw=2)
ax.grid()
xdata, ydata = [], []


def run(data):
    # update the data
    t, y = data
    xdata.append(t)
    ydata.append(y)
    xmin, xmax = ax.get_xlim()

    if t >= xmax:
        ax.set_xlim(xmin, 2*xmax)
        ax.figure.canvas.draw()
    line.set_data(xdata, ydata)

    return line,

ani = animation.FuncAnimation(fig, run, data_gen, blit=False, interval=10,
                              repeat=False, init_func=init)
plt.show()
```

## 下载这个示例
            
- [下载python源码: animate_decay.py](https://matplotlib.org/_downloads/animate_decay.py)
- [下载Jupyter notebook: animate_decay.ipynb](https://matplotlib.org/_downloads/animate_decay.ipynb)