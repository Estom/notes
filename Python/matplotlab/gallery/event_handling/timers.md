# 计时器

使用通用计时器对象的简单示例。这用于更新图中标题的时间。

![计时器示例](https://matplotlib.org/_images/sphx_glr_timers_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime


def update_title(axes):
    axes.set_title(datetime.now())
    axes.figure.canvas.draw()

fig, ax = plt.subplots()

x = np.linspace(-3, 3)
ax.plot(x, x ** 2)

# Create a new timer object. Set the interval to 100 milliseconds
# (1000 is default) and tell the timer what function should be called.
timer = fig.canvas.new_timer(interval=100)
timer.add_callback(update_title, ax)
timer.start()

# Or could start the timer on first figure draw
#def start_timer(evt):
#    timer.start()
#    fig.canvas.mpl_disconnect(drawid)
#drawid = fig.canvas.mpl_connect('draw_event', start_timer)

plt.show()
```

## 下载这个示例
            
- [下载python源码: timers.py](https://matplotlib.org/_downloads/timers.py)
- [下载Jupyter notebook: timers.ipynb](https://matplotlib.org/_downloads/timers.ipynb)