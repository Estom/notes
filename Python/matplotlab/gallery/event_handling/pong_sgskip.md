# Pong

一个使用Matplotlib的小游戏演示。

此示例需要[pipong.py](https://matplotlib.org/_downloads/9a2d2c527d869cd1b03d9560d75d6a71/pipong.py)

```python
import time


import matplotlib.pyplot as plt
import pipong


fig, ax = plt.subplots()
canvas = ax.figure.canvas
animation = pipong.Game(ax)

# disable the default key bindings
if fig.canvas.manager.key_press_handler_id is not None:
    canvas.mpl_disconnect(fig.canvas.manager.key_press_handler_id)


# reset the blitting background on redraw
def handle_redraw(event):
    animation.background = None


# bootstrap after the first draw
def start_anim(event):
    canvas.mpl_disconnect(start_anim.cid)

    def local_draw():
        if animation.ax._cachedRenderer:
            animation.draw(None)
    start_anim.timer.add_callback(local_draw)
    start_anim.timer.start()
    canvas.mpl_connect('draw_event', handle_redraw)


start_anim.cid = canvas.mpl_connect('draw_event', start_anim)
start_anim.timer = animation.canvas.new_timer()
start_anim.timer.interval = 1

tstart = time.time()

plt.show()
print('FPS: %f' % (animation.cnt/(time.time() - tstart)))
```

## 下载这个示例
            
- [下载python源码: pong_sgskip.py](https://matplotlib.org/_downloads/pong_sgskip.py)
- [下载Jupyter notebook: pong_sgskip.ipynb](https://matplotlib.org/_downloads/pong_sgskip.ipynb)