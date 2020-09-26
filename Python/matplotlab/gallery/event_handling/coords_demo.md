# Coords 演示

如何通过连接到移动和单击事件来与绘图画布交互的示例

![Coords 演示](https://matplotlib.org/_images/sphx_glr_coords_demo_001.png)

```python
import sys
import matplotlib.pyplot as plt
import numpy as np

t = np.arange(0.0, 1.0, 0.01)
s = np.sin(2 * np.pi * t)
fig, ax = plt.subplots()
ax.plot(t, s)


def on_move(event):
    # get the x and y pixel coords
    x, y = event.x, event.y

    if event.inaxes:
        ax = event.inaxes  # the axes instance
        print('data coords %f %f' % (event.xdata, event.ydata))


def on_click(event):
    # get the x and y coords, flip y from top to bottom
    x, y = event.x, event.y
    if event.button == 1:
        if event.inaxes is not None:
            print('data coords %f %f' % (event.xdata, event.ydata))


binding_id = plt.connect('motion_notify_event', on_move)
plt.connect('button_press_event', on_click)

if "test_disconnect" in sys.argv:
    print("disconnecting console coordinate printout...")
    plt.disconnect(binding_id)

plt.show()
```

## 下载这个示例
            
- [下载python源码: coords_demo.py](https://matplotlib.org/_downloads/coords_demo.py)
- [下载Jupyter notebook: coords_demo.ipynb](https://matplotlib.org/_downloads/coords_demo.ipynb)