# 自动调整子图

自动调整子图参数。 此示例显示了一种使用[draw_event](https://matplotlib.org/users/event_handling.html)上的回调从ticklabels范围确定subplot参数的方法。

请注意，使用[tight_layout](https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.tight_layout)或 ``constrained_layout`` 可以实现类似的结果; 此示例显示了如何自定义子图参数调整。

```python
import matplotlib.pyplot as plt
import matplotlib.transforms as mtransforms
fig, ax = plt.subplots()
ax.plot(range(10))
ax.set_yticks((2,5,7))
labels = ax.set_yticklabels(('really, really, really', 'long', 'labels'))

def on_draw(event):
   bboxes = []
   for label in labels:
       bbox = label.get_window_extent()
       # the figure transform goes from relative coords->pixels and we
       # want the inverse of that
       bboxi = bbox.inverse_transformed(fig.transFigure)
       bboxes.append(bboxi)

   # this is the bbox that bounds all the bboxes, again in relative
   # figure coords
   bbox = mtransforms.Bbox.union(bboxes)
   if fig.subplotpars.left < bbox.width:
       # we need to move it over
       fig.subplots_adjust(left=1.1*bbox.width) # pad a little
       fig.canvas.draw()
   return False

fig.canvas.mpl_connect('draw_event', on_draw)

plt.show()
```

![自动调整子图](https://matplotlib.org/_images/sphx_glr_auto_subplots_adjust_0011.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.artist.Artist.get_window_extent
matplotlib.transforms.Bbox
matplotlib.transforms.Bbox.inverse_transformed
matplotlib.transforms.Bbox.union
matplotlib.figure.Figure.subplots_adjust
matplotlib.figure.SubplotParams
matplotlib.backend_bases.FigureCanvasBase.mpl_connect
```

## 下载这个示例
            
- [下载python源码: auto_subplots_adjust.py](https://matplotlib.org/_downloads/auto_subplots_adjust.py)
- [下载Jupyter notebook: auto_subplots_adjust.ipynb](https://matplotlib.org/_downloads/auto_subplots_adjust.ipynb)