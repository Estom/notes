# Pie 绘制饼图演示

使用 [pie()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.pie.html#matplotlib.axes.Axes.pie). 制作饼图。

此示例演示了一些饼图功能，如标签、可变大小、自动标记百分比、偏移切片和添加阴影。

```python
import matplotlib.pyplot as plt

# Some data
labels = 'Frogs', 'Hogs', 'Dogs', 'Logs'
fracs = [15, 30, 45, 10]

# Make figure and axes
fig, axs = plt.subplots(2, 2)

# A standard pie plot
axs[0, 0].pie(fracs, labels=labels, autopct='%1.1f%%', shadow=True)

# Shift the second slice using explode
axs[0, 1].pie(fracs, labels=labels, autopct='%.0f%%', shadow=True,
              explode=(0, 0.1, 0, 0))

# Adapt radius and text size for a smaller pie
patches, texts, autotexts = axs[1, 0].pie(fracs, labels=labels,
                                          autopct='%.0f%%',
                                          textprops={'size': 'smaller'},
                                          shadow=True, radius=0.5)
# Make percent texts even smaller
plt.setp(autotexts, size='x-small')
autotexts[0].set_color('white')

# Use a smaller explode and turn of the shadow for better visibility
patches, texts, autotexts = axs[1, 1].pie(fracs, labels=labels,
                                          autopct='%.0f%%',
                                          textprops={'size': 'smaller'},
                                          shadow=False, radius=0.5,
                                          explode=(0, 0.05, 0, 0))
plt.setp(autotexts, size='x-small')
autotexts[0].set_color('white')

plt.show()
```

![Pie 绘制饼图演示](https://matplotlib.org/_images/sphx_glr_pie_demo2_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.pie
matplotlib.pyplot.pie
```

## 下载这个示例
            
- [下载python源码: pie_demo2.py](https://matplotlib.org/_downloads/pie_demo2.py)
- [下载Jupyter notebook: pie_demo2.ipynb](https://matplotlib.org/_downloads/pie_demo2.ipynb)