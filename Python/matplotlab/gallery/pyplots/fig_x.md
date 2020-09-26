# X图

添加线条到图形（没有轴）。

```python
import matplotlib.pyplot as plt
import matplotlib.lines as lines


fig = plt.figure()

l1 = lines.Line2D([0, 1], [0, 1], transform=fig.transFigure, figure=fig)

l2 = lines.Line2D([0, 1], [1, 0], transform=fig.transFigure, figure=fig)

fig.lines.extend([l1, l2])

plt.show()
```

![X图示例](https://matplotlib.org/_images/sphx_glr_fig_x_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.pyplot.figure
matplotlib.lines
matplotlib.lines.Line2D
```

## 下载这个示例
            
- [下载python源码: fig_x.py](https://matplotlib.org/_downloads/fig_x.py)
- [下载Jupyter notebook: fig_x.ipynb](https://matplotlib.org/_downloads/fig_x.ipynb)