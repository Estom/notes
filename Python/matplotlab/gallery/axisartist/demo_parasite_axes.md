# 演示寄生轴

创建寄生轴。这些轴将与主体轴共享x比例，但在y方向显示不同的比例。

请注意，此方法使用 [parasite_axes](https://matplotlib.org/api/_as_gen/mpl_toolkits.axes_grid1.parasite_axes.html#module-mpl_toolkits.axes_grid1.parasite_axes) 的 [HostAxes](https://matplotlib.org/api/_as_gen/mpl_toolkits.axes_grid1.parasite_axes.HostAxes.html#mpl_toolkits.axes_grid1.parasite_axes.HostAxes) 和 [ParasiteAxes](https://matplotlib.org/api/_as_gen/mpl_toolkits.axes_grid1.parasite_axes.ParasiteAxes.html#mpl_toolkits.axes_grid1.parasite_axes.ParasiteAxes)。 在 [Demo Parasite Axes2](https://matplotlib.org/api/toolkits/axes_grid1.html#toolkit-axesgrid1-index) 示例中可以找到使用[Matplotlib axes_grid1 Toolkit](https://matplotlib.org/api/toolkits/axisartist.html#toolkit-axisartist-index) 和 Matplotlib axisartist Toolkit的替代方法。 使用通常的matplotlib子图的替代方法显示在 [Multiple Yaxis With Spines](https://matplotlib.org/gallery/ticks_and_spines/multiple_yaxis_with_spines.html) 示例中。

![演示寄生轴](https://matplotlib.org/_images/sphx_glr_demo_parasite_axes_001.png)

```python
from mpl_toolkits.axisartist.parasite_axes import HostAxes, ParasiteAxes
import matplotlib.pyplot as plt


fig = plt.figure(1)

host = HostAxes(fig, [0.15, 0.1, 0.65, 0.8])
par1 = ParasiteAxes(host, sharex=host)
par2 = ParasiteAxes(host, sharex=host)
host.parasites.append(par1)
host.parasites.append(par2)

host.set_ylabel("Density")
host.set_xlabel("Distance")

host.axis["right"].set_visible(False)
par1.axis["right"].set_visible(True)
par1.set_ylabel("Temperature")

par1.axis["right"].major_ticklabels.set_visible(True)
par1.axis["right"].label.set_visible(True)

par2.set_ylabel("Velocity")
offset = (60, 0)
new_axisline = par2._grid_helper.new_fixed_axis
par2.axis["right2"] = new_axisline(loc="right", axes=par2, offset=offset)

fig.add_axes(host)

host.set_xlim(0, 2)
host.set_ylim(0, 2)

host.set_xlabel("Distance")
host.set_ylabel("Density")
par1.set_ylabel("Temperature")

p1, = host.plot([0, 1, 2], [0, 1, 2], label="Density")
p2, = par1.plot([0, 1, 2], [0, 3, 2], label="Temperature")
p3, = par2.plot([0, 1, 2], [50, 30, 15], label="Velocity")

par1.set_ylim(0, 4)
par2.set_ylim(1, 65)

host.legend()

host.axis["left"].label.set_color(p1.get_color())
par1.axis["right"].label.set_color(p2.get_color())
par2.axis["right2"].label.set_color(p3.get_color())

plt.show()
```

## 下载这个示例
            
- [下载python源码: demo_parasite_axes.py](https://matplotlib.org/_downloads/demo_parasite_axes.py)
- [下载Jupyter notebook: demo_parasite_axes.ipynb](https://matplotlib.org/_downloads/demo_parasite_axes.ipynb)