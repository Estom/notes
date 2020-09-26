# 等高线演示

演示简单的等高线绘制，图像上的等高线带有等高线的颜色条，并标出等高线。

另见[轮廓图像示例](https://matplotlib.org/gallery/images_contours_and_fields/contour_image.html)。

```python
import matplotlib
import numpy as np
import matplotlib.cm as cm
import matplotlib.pyplot as plt


delta = 0.025
x = np.arange(-3.0, 3.0, delta)
y = np.arange(-2.0, 2.0, delta)
X, Y = np.meshgrid(x, y)
Z1 = np.exp(-X**2 - Y**2)
Z2 = np.exp(-(X - 1)**2 - (Y - 1)**2)
Z = (Z1 - Z2) * 2
```

使用默认颜色创建带有标签的简单等高线图。clabel的内联参数将控制标签是否画在轮廓的线段上，移除标签下面的线。

```python
fig, ax = plt.subplots()
CS = ax.contour(X, Y, Z)
ax.clabel(CS, inline=1, fontsize=10)
ax.set_title('Simplest default with labels')
```

![等高线演示示例](https://matplotlib.org/_images/sphx_glr_contour_demo_001.png)

等高线的标签可以手动放置，通过提供位置列表(在数据坐标中)。有关交互式布局，请参见ginput_book_clabel.py。

```python
fig, ax = plt.subplots()
CS = ax.contour(X, Y, Z)
manual_locations = [(-1, -1.4), (-0.62, -0.7), (-2, 0.5), (1.7, 1.2), (2.0, 1.4), (2.4, 1.7)]
ax.clabel(CS, inline=1, fontsize=10, manual=manual_locations)
ax.set_title('labels at selected locations')
```

![等高线演示示例2](https://matplotlib.org/_images/sphx_glr_contour_demo_002.png)

你可以强制所有的等高线是相同的颜色。

```python
fig, ax = plt.subplots()
CS = ax.contour(X, Y, Z, 6,
                 colors='k',  # negative contours will be dashed by default
                 )
ax.clabel(CS, fontsize=9, inline=1)
ax.set_title('Single color - negative contours dashed')
```

![等高线演示示例3](https://matplotlib.org/_images/sphx_glr_contour_demo_003.png)

你可以将负轮廓设置为实线而不是虚线：

```python
matplotlib.rcParams['contour.negative_linestyle'] = 'solid'
fig, ax = plt.subplots()
CS = ax.contour(X, Y, Z, 6,
                 colors='k',  # negative contours will be dashed by default
                 )
ax.clabel(CS, fontsize=9, inline=1)
ax.set_title('Single color - negative contours solid')
```

![等高线演示示例4](https://matplotlib.org/_images/sphx_glr_contour_demo_004.png)

并且你可以手动指定轮廓的颜色。

```python
fig, ax = plt.subplots()
CS = ax.contour(X, Y, Z, 6,
                 linewidths=np.arange(.5, 4, .5),
                 colors=('r', 'green', 'blue', (1, 1, 0), '#afeeee', '0.5')
                 )
ax.clabel(CS, fontsize=9, inline=1)
ax.set_title('Crazy lines')
```

![等高线演示示例5](https://matplotlib.org/_images/sphx_glr_contour_demo_005.png)

也可以使用颜色图来指定颜色；默认的颜色图将用于等高线。

```python
fig, ax = plt.subplots()
im = ax.imshow(Z, interpolation='bilinear', origin='lower',
                cmap=cm.gray, extent=(-3, 3, -2, 2))
levels = np.arange(-1.2, 1.6, 0.2)
CS = ax.contour(Z, levels, origin='lower', cmap='flag',
                linewidths=2, extent=(-3, 3, -2, 2))

# Thicken the zero contour.
zc = CS.collections[6]
plt.setp(zc, linewidth=4)

ax.clabel(CS, levels[1::2],  # label every second level
          inline=1, fmt='%1.1f', fontsize=14)

# make a colorbar for the contour lines
CB = fig.colorbar(CS, shrink=0.8, extend='both')

ax.set_title('Lines with colorbar')

# We can still add a colorbar for the image, too.
CBI = fig.colorbar(im, orientation='horizontal', shrink=0.8)

# This makes the original colorbar look a bit out of place,
# so let's improve its position.

l, b, w, h = ax.get_position().bounds
ll, bb, ww, hh = CB.ax.get_position().bounds
CB.ax.set_position([ll, b + 0.1*h, ww, h*0.8])

plt.show()
```

![等高线演示示例6](https://matplotlib.org/_images/sphx_glr_contour_demo_006.png)

## 参考

下面的示例演示了以下函数和方法的使用：

```python
import matplotlib
matplotlib.axes.Axes.contour
matplotlib.pyplot.contour
matplotlib.figure.Figure.colorbar
matplotlib.pyplot.colorbar
matplotlib.axes.Axes.clabel
matplotlib.pyplot.clabel
matplotlib.axes.Axes.set_position
matplotlib.axes.Axes.get_position
```

## 下载这个示例

- [下载python源码: contour_demo.py](https://matplotlib.org/_downloads/contour_demo.py)
- [下载Jupyter notebook: contour_demo.ipynb](https://matplotlib.org/_downloads/contour_demo.ipynb)