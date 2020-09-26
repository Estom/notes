# 图轴的进入和离开

通过更改进入和离开时的框架颜色来说明图形和轴进入和离开事件

```python
import matplotlib.pyplot as plt


def enter_axes(event):
    print('enter_axes', event.inaxes)
    event.inaxes.patch.set_facecolor('yellow')
    event.canvas.draw()


def leave_axes(event):
    print('leave_axes', event.inaxes)
    event.inaxes.patch.set_facecolor('white')
    event.canvas.draw()


def enter_figure(event):
    print('enter_figure', event.canvas.figure)
    event.canvas.figure.patch.set_facecolor('red')
    event.canvas.draw()


def leave_figure(event):
    print('leave_figure', event.canvas.figure)
    event.canvas.figure.patch.set_facecolor('grey')
    event.canvas.draw()
```

```python
fig1, (ax, ax2) = plt.subplots(2, 1)
fig1.suptitle('mouse hover over figure or axes to trigger events')

fig1.canvas.mpl_connect('figure_enter_event', enter_figure)
fig1.canvas.mpl_connect('figure_leave_event', leave_figure)
fig1.canvas.mpl_connect('axes_enter_event', enter_axes)
fig1.canvas.mpl_connect('axes_leave_event', leave_axes)
```

![图轴的进入和离开示例](https://matplotlib.org/_images/sphx_glr_figure_axes_enter_leave_001.png)

```python
fig2, (ax, ax2) = plt.subplots(2, 1)
fig2.suptitle('mouse hover over figure or axes to trigger events')

fig2.canvas.mpl_connect('figure_enter_event', enter_figure)
fig2.canvas.mpl_connect('figure_leave_event', leave_figure)
fig2.canvas.mpl_connect('axes_enter_event', enter_axes)
fig2.canvas.mpl_connect('axes_leave_event', leave_axes)

plt.show()
```

![图轴的进入和离开示例2](https://matplotlib.org/_images/sphx_glr_figure_axes_enter_leave_002.png)

## 下载这个示例
            
- [下载python源码: figure_axes_enter_leave.py](https://matplotlib.org/_downloads/figure_axes_enter_leave.py)
- [下载Jupyter notebook: figure_axes_enter_leave.ipynb](https://matplotlib.org/_downloads/figure_axes_enter_leave.ipynb)