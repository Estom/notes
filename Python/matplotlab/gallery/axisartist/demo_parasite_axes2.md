# 演示寄生轴2

寄生轴的演示。

以下代码是寄生虫轴的示例。 它旨在展示如何在一个单独的图上绘制多个不同的值。 请注意，在此示例中，par1和par2都调用twinx，这意味着两者都直接绑定到x轴。 从那里，这两个轴中的每一个可以彼此分开地表现，这意味着它们可以从它们自身以及x轴上获取单独的值。

请注意，此方法使用 [parasite_axes](https://matplotlib.org/api/_as_gen/mpl_toolkits.axes_grid1.parasite_axes.html#module-mpl_toolkits.axes_grid1.parasite_axes) 的 [HostAxes](https://matplotlib.org/api/_as_gen/mpl_toolkits.axes_grid1.parasite_axes.HostAxes.html#mpl_toolkits.axes_grid1.parasite_axes.HostAxes) 和 [ParasiteAxes](https://matplotlib.org/api/_as_gen/mpl_toolkits.axes_grid1.parasite_axes.ParasiteAxes.html#mpl_toolkits.axes_grid1.parasite_axes.ParasiteAxes)。 在 [Demo Parasite Axes2](https://matplotlib.org/api/toolkits/axes_grid1.html#toolkit-axesgrid1-index) 示例中可以找到使用[Matplotlib axes_grid1 Toolkit](https://matplotlib.org/api/toolkits/axisartist.html#toolkit-axisartist-index) 和 Matplotlib axisartist Toolkit的替代方法。 使用通常的matplotlib子图的替代方法显示在 [Multiple Yaxis With Spines](https://matplotlib.org/gallery/ticks_and_spines/multiple_yaxis_with_spines.html) 示例中。

![演示寄生轴2](https://matplotlib.org/_images/sphx_glr_demo_parasite_axes2_001.png)

```python
from mpl_toolkits.axes_grid1 import host_subplot
import mpl_toolkits.axisartist as AA
import matplotlib.pyplot as plt

host = host_subplot(111, axes_class=AA.Axes)
plt.subplots_adjust(right=0.75)

par1 = host.twinx()
par2 = host.twinx()

offset = 60
new_fixed_axis = par2.get_grid_helper().new_fixed_axis
par2.axis["right"] = new_fixed_axis(loc="right",
                                    axes=par2,
                                    offset=(offset, 0))

par1.axis["right"].toggle(all=True)
par2.axis["right"].toggle(all=True)

host.set_xlim(0, 2)
host.set_ylim(0, 2)

host.set_xlabel("Distance")
host.set_ylabel("Density")
par1.set_ylabel("Temperature")
par2.set_ylabel("Velocity")

p1, = host.plot([0, 1, 2], [0, 1, 2], label="Density")
p2, = par1.plot([0, 1, 2], [0, 3, 2], label="Temperature")
p3, = par2.plot([0, 1, 2], [50, 30, 15], label="Velocity")

par1.set_ylim(0, 4)
par2.set_ylim(1, 65)

host.legend()

host.axis["left"].label.set_color(p1.get_color())
par1.axis["right"].label.set_color(p2.get_color())
par2.axis["right"].label.set_color(p3.get_color())

plt.show()
```

## 下载这个示例
            
- [下载python源码: demo_parasite_axes2.py](https://matplotlib.org/_downloads/demo_parasite_axes2.py)
- [下载Jupyter notebook: demo_parasite_axes2.ipynb](https://matplotlib.org/_downloads/demo_parasite_axes2.ipynb)