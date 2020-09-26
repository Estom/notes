# 缩放窗口

此示例显示如何将一个窗口(例如鼠标按键)中的事件连接到另一个体形窗口。

如果单击第一个窗口中的某个点，将调整第二个窗口的z和y限制，以便第二个窗口中缩放的中心将是所单击点的x，y坐标。

请注意，散点图中圆的直径以点**2定义，因此它们的大小与缩放无关。

![缩放窗口示例](https://matplotlib.org/_images/sphx_glr_zoom_window_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

figsrc, axsrc = plt.subplots()
figzoom, axzoom = plt.subplots()
axsrc.set(xlim=(0, 1), ylim=(0, 1), autoscale_on=False,
          title='Click to zoom')
axzoom.set(xlim=(0.45, 0.55), ylim=(0.4, 0.6), autoscale_on=False,
           title='Zoom window')

x, y, s, c = np.random.rand(4, 200)
s *= 200

axsrc.scatter(x, y, s, c)
axzoom.scatter(x, y, s, c)


def onpress(event):
    if event.button != 1:
        return
    x, y = event.xdata, event.ydata
    axzoom.set_xlim(x - 0.1, x + 0.1)
    axzoom.set_ylim(y - 0.1, y + 0.1)
    figzoom.canvas.draw()

figsrc.canvas.mpl_connect('button_press_event', onpress)
plt.show()
```

## 下载这个示例
            
- [下载python源码: zoom_window.py](https://matplotlib.org/_downloads/zoom_window.py)
- [下载Jupyter notebook: zoom_window.ipynb](https://matplotlib.org/_downloads/zoom_window.ipynb)