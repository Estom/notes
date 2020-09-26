# 使用子图和GridSpec组合两个子图

有时我们想要在用[子图](https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.subplots)创建的轴布局中组合两个子图。我们可以从轴上获取[GridSpec](https://matplotlib.org/api/_as_gen/matplotlib.gridspec.GridSpec.html#matplotlib.gridspec.GridSpec)，然后移除覆盖的轴并用新的更大的轴填充间隙。 在这里，我们创建一个布局，最后一列中的底部两个轴组合在一起。

请参阅：[使用GridSpec和其他功能自定义图布局](https://matplotlib.org/tutorials/intermediate/gridspec.html)。

![使用子图和GridSpec组合两个子图示例](https://matplotlib.org/_images/sphx_glr_gridspec_and_subplots_001.png)

```python
import matplotlib.pyplot as plt

fig, axs = plt.subplots(ncols=3, nrows=3)
gs = axs[1, 2].get_gridspec()
# remove the underlying axes
for ax in axs[1:, -1]:
    ax.remove()
axbig = fig.add_subplot(gs[1:, -1])
axbig.annotate('Big Axes \nGridSpec[1:, -1]', (0.1, 0.5),
               xycoords='axes fraction', va='center')

fig.tight_layout()
```

## 下载这个示例
            
- [下载python源码: gridspec_and_subplots.py](https://matplotlib.org/_downloads/gridspec_and_subplots.py)
- [下载Jupyter notebook: gridspec_and_subplots.ipynb](https://matplotlib.org/_downloads/gridspec_and_subplots.ipynb)