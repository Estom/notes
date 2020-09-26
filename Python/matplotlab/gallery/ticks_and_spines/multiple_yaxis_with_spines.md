# 多个Yaxis与Spines

使用共享x轴创建多个y轴。这是通过创建一个[双轴](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.twinx.html#matplotlib.axes.Axes.twinx)，转动所有脊柱但右边的一个不可见并使用[set_position](https://matplotlib.org/api/spines_api.html#matplotlib.spines.Spine.set_position)偏移其位置来完成的。

请注意，此方法使用 [matplotlib.axes.Axes](https://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes) 及其Spines。 寄生虫轴的另一种方法显示在[Demo Parasite Axes](https://matplotlib.org/gallery/axisartist/demo_parasite_axes.html) 和 [Demo Parasite Axes2](https://matplotlib.org/gallery/axisartist/demo_parasite_axes2.html)示例中。

![多个Yaxis与Spines示例](https://matplotlib.org/_images/sphx_glr_multiple_yaxis_with_spines_001.png)

```python
import matplotlib.pyplot as plt


def make_patch_spines_invisible(ax):
    ax.set_frame_on(True)
    ax.patch.set_visible(False)
    for sp in ax.spines.values():
        sp.set_visible(False)


fig, host = plt.subplots()
fig.subplots_adjust(right=0.75)

par1 = host.twinx()
par2 = host.twinx()

# Offset the right spine of par2.  The ticks and label have already been
# placed on the right by twinx above.
par2.spines["right"].set_position(("axes", 1.2))
# Having been created by twinx, par2 has its frame off, so the line of its
# detached spine is invisible.  First, activate the frame but make the patch
# and spines invisible.
make_patch_spines_invisible(par2)
# Second, show the right spine.
par2.spines["right"].set_visible(True)

p1, = host.plot([0, 1, 2], [0, 1, 2], "b-", label="Density")
p2, = par1.plot([0, 1, 2], [0, 3, 2], "r-", label="Temperature")
p3, = par2.plot([0, 1, 2], [50, 30, 15], "g-", label="Velocity")

host.set_xlim(0, 2)
host.set_ylim(0, 2)
par1.set_ylim(0, 4)
par2.set_ylim(1, 65)

host.set_xlabel("Distance")
host.set_ylabel("Density")
par1.set_ylabel("Temperature")
par2.set_ylabel("Velocity")

host.yaxis.label.set_color(p1.get_color())
par1.yaxis.label.set_color(p2.get_color())
par2.yaxis.label.set_color(p3.get_color())

tkw = dict(size=4, width=1.5)
host.tick_params(axis='y', colors=p1.get_color(), **tkw)
par1.tick_params(axis='y', colors=p2.get_color(), **tkw)
par2.tick_params(axis='y', colors=p3.get_color(), **tkw)
host.tick_params(axis='x', **tkw)

lines = [p1, p2, p3]

host.legend(lines, [l.get_label() for l in lines])

plt.show()
```

## 下载这个示例
            
- [下载python源码: multiple_yaxis_with_spines.py](https://matplotlib.org/_downloads/multiple_yaxis_with_spines.py)
- [下载Jupyter notebook: multiple_yaxis_with_spines.ipynb](https://matplotlib.org/_downloads/multiple_yaxis_with_spines.ipynb)