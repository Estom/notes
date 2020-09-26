# 标记饼图和空心饼图

欢迎来到Matplotlib面包店。我们将通过 pie 方法 [(pie method)](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.pie.html#matplotlib.axes.Axes.pie) 创建一个饼图和一个空心饼图表，并展示如何使用[图例](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.legend.html#matplotlib.axes.Axes.legend)和[注释](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.annotate.html#matplotlib.axes.Axes.annotate)来标记它们。

与往常一样，我们将从定义导入开始，并创建一个带有子图的图形。现在是吃派的时候了。从饼图开始，我们从数据和标签列表中创建数据。

我们可以为``autopct``参数提供一个函数，它将通过显示绝对值来扩展自动百分比标记；我们从相对数据和已知的所有值之和计算出后者。

然后，我们创建饼图并存储返回的对象以供日后使用。返回元组的第一个返回元素是楔形列表。这些是[matplotlib.patches.WEdge](https://matplotlib.org/api/_as_gen/matplotlib.patches.Wedge.html#matplotlib.patches.Wedge) 补丁，可以直接用作图例的句柄。我们可以使用图例的bbox_to_anchor参数将图例放在饼图之外。这里我们使用轴坐标（1,0,0.5,1）和“中间左”的位置;即图例的左中心点位于边界框的左中心点，在轴坐标中从（1,0）到（1.5,1）。

然后我们创建馅饼并存储返回的对象，以备以后使用。返回的元组的第一个返回元素是楔体列表。这些是[matplotlib.patches.WEdge](https://matplotlib.org/api/_as_gen/matplotlib.patches.Wedge.html#matplotlib.patches.Wedge) 面片，可以直接用作图例的句柄。我们可以使用图例的 ``bbox_to_anchor`` 参数将图例放置在饼图外部。这里我们使用坐标轴(1, 0, 0.5, 1) 和位置 ``中心左(center left)``，即图例的左中心点将位于边界框的左中心点，坐标轴从(1, 0)到(1.5, 1)。

```python
import numpy as np
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(6, 3), subplot_kw=dict(aspect="equal"))

recipe = ["375 g flour",
          "75 g sugar",
          "250 g butter",
          "300 g berries"]

data = [float(x.split()[0]) for x in recipe]
ingredients = [x.split()[-1] for x in recipe]


def func(pct, allvals):
    absolute = int(pct/100.*np.sum(allvals))
    return "{:.1f}%\n({:d} g)".format(pct, absolute)


wedges, texts, autotexts = ax.pie(data, autopct=lambda pct: func(pct, data),
                                  textprops=dict(color="w"))

ax.legend(wedges, ingredients,
          title="Ingredients",
          loc="center left",
          bbox_to_anchor=(1, 0, 0.5, 1))

plt.setp(autotexts, size=8, weight="bold")

ax.set_title("Matplotlib bakery: A pie")

plt.show()
```

![标记饼图和空心饼图示例](https://matplotlib.org/_images/sphx_glr_pie_and_donut_labels_001.png)

现在是空心饼图（甜甜圈）。从空心饼图（甜甜圈）开始，我们将数据转录为数字（将1个鸡蛋转换为50克），并直接绘制馅饼。馅饼？等等......这将是甜甜圈，不是吗？ 好吧，正如我们在这里看到的，甜甜圈是一个馅饼，有一定的宽度设置到楔形，这与它的半径不同。 这很简单。这是通过wedgeprops参数完成的。

然后我们想通过[注释](annotations)标记楔形。我们首先创建一些公共属性的字典，我们稍后可以将其作为关键字参数传递。然后我们迭代所有的楔形和每个楔形

- 计算楔形中心的角度，
- 从那里获得圆周上该角度的点的坐标，
- 确定文本的水平对齐方式，具体取决于该点位于圆圈的哪一侧，
- 使用获得的角度更新连接样式，使注释箭头从甜甜圈向外指向，
- 最后，使用所有先前确定的参数创建注释。

```python
fig, ax = plt.subplots(figsize=(6, 3), subplot_kw=dict(aspect="equal"))

recipe = ["225 g flour",
          "90 g sugar",
          "1 egg",
          "60 g butter",
          "100 ml milk",
          "1/2 package of yeast"]

data = [225, 90, 50, 60, 100, 5]

wedges, texts = ax.pie(data, wedgeprops=dict(width=0.5), startangle=-40)

bbox_props = dict(boxstyle="square,pad=0.3", fc="w", ec="k", lw=0.72)
kw = dict(xycoords='data', textcoords='data', arrowprops=dict(arrowstyle="-"),
          bbox=bbox_props, zorder=0, va="center")

for i, p in enumerate(wedges):
    ang = (p.theta2 - p.theta1)/2. + p.theta1
    y = np.sin(np.deg2rad(ang))
    x = np.cos(np.deg2rad(ang))
    horizontalalignment = {-1: "right", 1: "left"}[int(np.sign(x))]
    connectionstyle = "angle,angleA=0,angleB={}".format(ang)
    kw["arrowprops"].update({"connectionstyle": connectionstyle})
    ax.annotate(recipe[i], xy=(x, y), xytext=(1.35*np.sign(x), 1.4*y),
                 horizontalalignment=horizontalalignment, **kw)

ax.set_title("Matplotlib bakery: A donut")

plt.show()
```

![标记饼图和空心饼图2](https://matplotlib.org/_images/sphx_glr_pie_and_donut_labels_002.png)

这就是空心饼图（甜甜圈）。然而，请注意，如果我们使用这个食谱，材料将足够大约6个甜甜圈-生产一个巨大的甜甜圈是未经测试的，并可能会导致烹饪失败。

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.pie
matplotlib.pyplot.pie
matplotlib.axes.Axes.legend
matplotlib.pyplot.legend
```

## 下载这个示例
            
- [下载python源码: pie_and_donut_labels.py](https://matplotlib.org/_downloads/pie_and_donut_labels.py)
- [下载Jupyter notebook: pie_and_donut_labels.ipynb](https://matplotlib.org/_downloads/pie_and_donut_labels.ipynb)