# 基本饼图

演示一个基本的饼图和一些额外的功能。

除了基本饼图外，此演示还显示了以下几个可选功能：

- 切片标签。
- 自动标记百分比。
- 用 ``explode`` 偏移切片。
- 投影。
- 自定义起始角度

请注意，自定义起点角度：

默认的起始``角度(startangle)``为0，这将在正x轴上开始“Frogs”切片。此示例将 ``startangle设置为90`` ，以便将所有对象逆时针旋转90度，并且青蛙切片从正y轴开始。

```python
import matplotlib.pyplot as plt

# Pie chart, where the slices will be ordered and plotted counter-clockwise:
labels = 'Frogs', 'Hogs', 'Dogs', 'Logs'
sizes = [15, 30, 45, 10]
explode = (0, 0.1, 0, 0)  # only "explode" the 2nd slice (i.e. 'Hogs')

fig1, ax1 = plt.subplots()
ax1.pie(sizes, explode=explode, labels=labels, autopct='%1.1f%%',
        shadow=True, startangle=90)
ax1.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.

plt.show()
```

![基本饼图示例](https://matplotlib.org/_images/sphx_glr_pie_features_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.pie
matplotlib.pyplot.pie
```

## 下载这个示例
            
- [下载python源码: pie_features.py](https://matplotlib.org/_downloads/pie_features.py)
- [下载Jupyter notebook: pie_features.ipynb](https://matplotlib.org/_downloads/pie_features.ipynb)