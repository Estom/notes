# 关闭事件

显示图形关闭时发生的连接事件的示例。

![关闭事件示例](https://matplotlib.org/_images/sphx_glr_close_event_001.png)

```python
import matplotlib.pyplot as plt


def handle_close(evt):
    print('Closed Figure!')

fig = plt.figure()
fig.canvas.mpl_connect('close_event', handle_close)

plt.text(0.35, 0.5, 'Close Me!', dict(size=30))
plt.show()
```

## 下载这个示例
            
- [下载python源码: close_event.py](https://matplotlib.org/_downloads/close_event.py)
- [下载Jupyter notebook: close_event.ipynb](https://matplotlib.org/_downloads/close_event.ipynb)