# 图像演示

在Matplotlib中绘制图像的许多方法。

在Matplotlib中绘制图像最常见的方法是使用 [imShow()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.imshow.html#matplotlib.axes.Axes.imshow)。下面的示例演示了imShow的许多功能以及您可以创建的许多图像。

```python
import numpy as np
import matplotlib.cm as cm
import matplotlib.pyplot as plt
import matplotlib.cbook as cbook
from matplotlib.path import Path
from matplotlib.patches import PathPatch
```

首先，我们将生成一个简单的二元正态分布。

```python
delta = 0.025
x = y = np.arange(-3.0, 3.0, delta)
X, Y = np.meshgrid(x, y)
Z1 = np.exp(-X**2 - Y**2)
Z2 = np.exp(-(X - 1)**2 - (Y - 1)**2)
Z = (Z1 - Z2) * 2

fig, ax = plt.subplots()
im = ax.imshow(Z, interpolation='bilinear', cmap=cm.RdYlGn,
               origin='lower', extent=[-3, 3, -3, 3],
               vmax=abs(Z).max(), vmin=-abs(Z).max())

plt.show()
```

![图像演示示例](https://matplotlib.org/_images/sphx_glr_image_demo_001.png)

还可以显示图片的图像。

```python
# A sample image
with cbook.get_sample_data('ada.png') as image_file:
    image = plt.imread(image_file)

fig, ax = plt.subplots()
ax.imshow(image)
ax.axis('off')  # clear x-axis and y-axis


# And another image

w, h = 512, 512

with cbook.get_sample_data('ct.raw.gz', asfileobj=True) as datafile:
    s = datafile.read()
A = np.fromstring(s, np.uint16).astype(float).reshape((w, h))
A /= A.max()

fig, ax = plt.subplots()
extent = (0, 25, 0, 25)
im = ax.imshow(A, cmap=plt.cm.hot, origin='upper', extent=extent)

markers = [(15.9, 14.5), (16.8, 15)]
x, y = zip(*markers)
ax.plot(x, y, 'o')

ax.set_title('CT density')

plt.show()
```

![图像演示示例2](https://matplotlib.org/_images/sphx_glr_image_demo_002.png)

![图像演示示例3](https://matplotlib.org/_images/sphx_glr_image_demo_003.png)

## 插值图像

也可以在显示图像之前对其进行插值。请注意，因为这可能会影响数据的外观，但它有助于实现您想要的外观。下面我们将显示相同的（小）数组，使用三种不同的插值方法进行插值。

A[i, j]处的像素的中心绘制在 i + 0.5，i + 0.5 处。 如果使用interpolation ='nearest'，则由(i，j) 和 (i + 1, j + 1) 限定的区域将具有相同的颜色。如果使用插值，像素中心的颜色与最近的颜色相同，但其他像素将在相邻像素之间进行插值。

早期版本的matplotlib（<0.63）试图通过设置视图限制来隐藏边缘效果，以便它们不可见。最近在antigrain中的一个误差修复，以及利用此修复的matplotlib._image模块中的一个新实现，不再需要它。为了防止边缘效应，在进行插值时，matplotlib._image模块现在用边缘周围相同的像素填充输入数组。 例如，如果你有一个5x5数组，颜色a-y如下：

```
a b c d e
f g h i j
k l m n o
p q r s t
u v w x y
```

_image模块创建填充数组：

```
a a b c d e e
a a b c d e e
f f g h i j j
k k l m n o o
p p q r s t t
o u v w x y y
o u v w x y y
```

进行插值/调整大小，然后提取中心区域。这允许你绘制没有边缘效果的阵列的整个范围，例如，使用不同的插值方法将多个不同大小的图像叠加在一起 - 请参阅[图层图像](https://matplotlib.org/gallery/images_contours_and_fields/layer_images.html)。它还意味着性能损失，因为必须创建这个新的临时填充数组。复杂的插值也意味着性能损失，因此如果您需要最大性能或具有非常大的图像，建议插值=“最近”。

```python
A = np.random.rand(5, 5)

fig, axs = plt.subplots(1, 3, figsize=(10, 3))
for ax, interp in zip(axs, ['nearest', 'bilinear', 'bicubic']):
    ax.imshow(A, interpolation=interp)
    ax.set_title(interp.capitalize())
    ax.grid(True)

plt.show()
```

![图像演示示例4](https://matplotlib.org/_images/sphx_glr_image_demo_004.png)

可以使用“原点”参数指定图像应以数组原点 x[0, 0] 绘制在左上角还是右下角。您还可以在matplotLibrary c文件中控制默认设置Image.Source。有关此主题的更多信息，请参阅关于起源和范围的完整指南。

```python
x = np.arange(120).reshape((10, 12))

interp = 'bilinear'
fig, axs = plt.subplots(nrows=2, sharex=True, figsize=(3, 5))
axs[0].set_title('blue should be up')
axs[0].imshow(x, origin='upper', interpolation=interp)

axs[1].set_title('blue should be down')
axs[1].imshow(x, origin='lower', interpolation=interp)
plt.show()
```

![图像演示示例5](https://matplotlib.org/_images/sphx_glr_image_demo_005.png)

最后，我们将使用剪辑路径显示图像。

```python
delta = 0.025
x = y = np.arange(-3.0, 3.0, delta)
X, Y = np.meshgrid(x, y)
Z1 = np.exp(-X**2 - Y**2)
Z2 = np.exp(-(X - 1)**2 - (Y - 1)**2)
Z = (Z1 - Z2) * 2

path = Path([[0, 1], [1, 0], [0, -1], [-1, 0], [0, 1]])
patch = PathPatch(path, facecolor='none')

fig, ax = plt.subplots()
ax.add_patch(patch)

im = ax.imshow(Z, interpolation='bilinear', cmap=cm.gray,
               origin='lower', extent=[-3, 3, -3, 3],
               clip_path=patch, clip_on=True)
im.set_clip_path(patch)

plt.show()
```

![图像演示示例6](https://matplotlib.org/_images/sphx_glr_image_demo_006.png)

## 参考

下面的示例演示了以下函数和方法的使用：

```python
import matplotlib
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
matplotlib.artist.Artist.set_clip_path
matplotlib.patches.PathPatch
```

## 下载这个示例

- [下载python源码: image_demo.py](https://matplotlib.org/_downloads/image_demo.py)
- [下载Jupyter notebook: image_demo.ipynb](https://matplotlib.org/_downloads/image_demo.ipynb)