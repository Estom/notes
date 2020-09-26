# Major和Minor的演示

演示如何使用Major和Minor代码。

两个相关的用户空类是Locators和Formatters。定位器确定刻度的位置，格式化程序控制刻度的格式。

默认情况下，小刻度线是关闭的（NullLocator和NullFormatter）。您可以通过设置次要定位器来转换w / o标签上的次要刻度。您还可以通过设置次要格式化程序为次要股票代码打开标签

制作一个主刻度线为20的倍数和小刻度为5的倍数的图。标记主要刻度与％d格式但不标记次刻度。

MultipleLocator自动收报机类用于在一些基数的倍数上放置滴答。 FormatStrFormatter使用字符串格式字符串（例如，'％d'或'％1.2f'或'％1.1f cm'）来格式化刻度线

pyplot interface grid命令一起更改y轴和y轴的主刻度线的网格设置。如果要控制给定轴的次刻度的网格，请使用例子中的方式。

```python
ax.xaxis.grid(True, which='minor')
```

请注意，您不应在不同的Axis之间使用相同的定位器，因为定位器存储对Axis数据和视图限制的引用。

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import (MultipleLocator, FormatStrFormatter,
                               AutoMinorLocator)

majorLocator = MultipleLocator(20)
majorFormatter = FormatStrFormatter('%d')
minorLocator = MultipleLocator(5)


t = np.arange(0.0, 100.0, 0.1)
s = np.sin(0.1 * np.pi * t) * np.exp(-t * 0.01)

fig, ax = plt.subplots()
ax.plot(t, s)

ax.xaxis.set_major_locator(majorLocator)
ax.xaxis.set_major_formatter(majorFormatter)

# for the minor ticks, use no labels; default NullFormatter
ax.xaxis.set_minor_locator(minorLocator)

plt.show()
```

![Major和Minor的示例](https://matplotlib.org/_images/sphx_glr_major_minor_demo_001.png)

主要和次要刻度的自动刻度选择。

使用交互式平移和缩放来查看滴答间隔如何变化。每个主要间隔将有4或5个次要滴答间隔，具体取决于主要间隔。

可以为AutoMinorLocator提供一个参数，以指定每个主要区间的固定数量的次要区间，例如：minorLocator = AutoMinorLocator(2) 将导致主要区间之间的单个小标记。

```python
minorLocator = AutoMinorLocator()


t = np.arange(0.0, 100.0, 0.01)
s = np.sin(2 * np.pi * t) * np.exp(-t * 0.01)

fig, ax = plt.subplots()
ax.plot(t, s)

ax.xaxis.set_minor_locator(minorLocator)

ax.tick_params(which='both', width=2)
ax.tick_params(which='major', length=7)
ax.tick_params(which='minor', length=4, color='r')

plt.show()
```

![Major和Minor的示例2](https://matplotlib.org/_images/sphx_glr_major_minor_demo_002.png)

## 下载这个示例
            
- [下载python源码: major_minor_demo.py](https://matplotlib.org/_downloads/major_minor_demo.py)
- [下载Jupyter notebook: major_minor_demo.ipynb](https://matplotlib.org/_downloads/major_minor_demo.ipynb)