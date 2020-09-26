# 从颜色列表创建颜色映射

有关创建和操作色彩映射的更多详细信息，请参阅[在Matplotlib中创建色彩映射](https://matplotlib.org/tutorials/colors/colormap-manipulation.html)。

可以使用LinearSegmentedColormap的[from_list()](https://matplotlib.org/api/_as_gen/matplotlib.colors.LinearSegmentedColormap.html#matplotlib.colors.LinearSegmentedColormap.from_list)方法从颜色列表创建[颜色映射](https://matplotlib.org/tutorials/colors/colormaps.html)。您必须传递一个RGB元组列表，用于定义从0到1的颜色混合。

## 创建自定义色彩映射

也可以为色彩映射创建自定义映射。 这是通过创建字典来实现的，该字典指定RGB通道如何从cmap的一端变为另一端。

示例：假设您希望红色在下半部分从0增加到1，绿色在中间半部分增加到相同，而在上半部分则为蓝色。 然后你会用：

```python
cdict = {'red':   ((0.0,  0.0, 0.0),
                   (0.5,  1.0, 1.0),
                   (1.0,  1.0, 1.0)),

         'green': ((0.0,  0.0, 0.0),
                   (0.25, 0.0, 0.0),
                   (0.75, 1.0, 1.0),
                   (1.0,  1.0, 1.0)),

         'blue':  ((0.0,  0.0, 0.0),
                   (0.5,  0.0, 0.0),
                   (1.0,  1.0, 1.0))}
```

如果在这个例子中，r，g和b组件中没有不连续性，那么它很简单：上面每个元组的第二个和第三个元素是相同的 - 称之为“y”。 第一个元素（“x”）定义了0到1整个范围内的插值间隔，它必须跨越整个范围。换句话说，x的值将0到1范围划分为一组段，并且y给出每个段的端点颜色值。 

现在考虑绿色。cdict['green']表示对于0 <= x <= 0.25，y为零; 没有绿色。0.25 < x <= 0.75，y从0到1线性变化.x > 0.75，y保持为1，全绿色。

如果存在不连续性，则会更复杂一些。将给定颜色的cdict条目中每行中的3个元素标记为（x, y0, y1）。然后，对于x[i] 和 x[i + 1]之间的x值，在 y1[i] 和 y0[i + 1] 之间内插颜色值。

回到指南里的例子，看看cdict['red']; 因为y0！= y1，它表示对于x从0到0.5，红色从0增加到1，但随后它向下跳跃，因此对于x从0.5到1，红色从0.7增加到1.绿色斜坡从0开始 当x从0变为0.5时变为1，然后跳回0，当x从0.5变为1时，斜坡变回1：

```python
row i:   x  y0  y1
                /
               /
row i+1: x  y0  y1
```

以上是试图表明对于x[i]到 x[i + 1] 范围内的x，插值在 y1[i] 和 y0[i + 1] 之间。因此，永远不会使用y0[0] 和 y1[-1]。

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

# Make some illustrative fake data:

x = np.arange(0, np.pi, 0.1)
y = np.arange(0, 2 * np.pi, 0.1)
X, Y = np.meshgrid(x, y)
Z = np.cos(X) * np.sin(Y) * 10
```

--- 列表中的色彩映射 ---

```python
colors = [(1, 0, 0), (0, 1, 0), (0, 0, 1)]  # R -> G -> B
n_bins = [3, 6, 10, 100]  # Discretizes the interpolation into bins
cmap_name = 'my_list'
fig, axs = plt.subplots(2, 2, figsize=(6, 9))
fig.subplots_adjust(left=0.02, bottom=0.06, right=0.95, top=0.94, wspace=0.05)
for n_bin, ax in zip(n_bins, axs.ravel()):
    # Create the colormap
    cm = LinearSegmentedColormap.from_list(
        cmap_name, colors, N=n_bin)
    # Fewer bins will result in "coarser" colomap interpolation
    im = ax.imshow(Z, interpolation='nearest', origin='lower', cmap=cm)
    ax.set_title("N bins: %s" % n_bin)
    fig.colorbar(im, ax=ax)
```

![从颜色列表创建颜色映射示例](https://matplotlib.org/_images/sphx_glr_custom_cmap_001.png)

--- 自定义色彩映射 ---

```python
cdict1 = {'red':   ((0.0, 0.0, 0.0),
                   (0.5, 0.0, 0.1),
                   (1.0, 1.0, 1.0)),

         'green': ((0.0, 0.0, 0.0),
                   (1.0, 0.0, 0.0)),

         'blue':  ((0.0, 0.0, 1.0),
                   (0.5, 0.1, 0.0),
                   (1.0, 0.0, 0.0))
        }

cdict2 = {'red':   ((0.0, 0.0, 0.0),
                   (0.5, 0.0, 1.0),
                   (1.0, 0.1, 1.0)),

         'green': ((0.0, 0.0, 0.0),
                   (1.0, 0.0, 0.0)),

         'blue':  ((0.0, 0.0, 0.1),
                   (0.5, 1.0, 0.0),
                   (1.0, 0.0, 0.0))
        }

cdict3 = {'red':  ((0.0, 0.0, 0.0),
                   (0.25, 0.0, 0.0),
                   (0.5, 0.8, 1.0),
                   (0.75, 1.0, 1.0),
                   (1.0, 0.4, 1.0)),

         'green': ((0.0, 0.0, 0.0),
                   (0.25, 0.0, 0.0),
                   (0.5, 0.9, 0.9),
                   (0.75, 0.0, 0.0),
                   (1.0, 0.0, 0.0)),

         'blue':  ((0.0, 0.0, 0.4),
                   (0.25, 1.0, 1.0),
                   (0.5, 1.0, 0.8),
                   (0.75, 0.0, 0.0),
                   (1.0, 0.0, 0.0))
        }

# Make a modified version of cdict3 with some transparency
# in the middle of the range.
cdict4 = {**cdict3,
          'alpha': ((0.0, 1.0, 1.0),
                #   (0.25,1.0, 1.0),
                    (0.5, 0.3, 0.3),
                #   (0.75,1.0, 1.0),
                    (1.0, 1.0, 1.0)),
          }
```

现在我们将使用此示例来说明处理自定义色彩映射的3种方法。首先，最直接和明确的：

```python
blue_red1 = LinearSegmentedColormap('BlueRed1', cdict1)
```

其次，显式创建地图并注册它。与第一种方法一样，此方法适用于任何类型的Colormap，而不仅仅是LinearSegmentedColormap：

```python
blue_red2 = LinearSegmentedColormap('BlueRed2', cdict2)
plt.register_cmap(cmap=blue_red2)
```

第三，仅对于LinearSegmentedColormap，将所有内容保留为register_cmap：

```python
plt.register_cmap(name='BlueRed3', data=cdict3)  # optional lut kwarg
plt.register_cmap(name='BlueRedAlpha', data=cdict4)
```

制作图：

```python
fig, axs = plt.subplots(2, 2, figsize=(6, 9))
fig.subplots_adjust(left=0.02, bottom=0.06, right=0.95, top=0.94, wspace=0.05)

# Make 4 subplots:

im1 = axs[0, 0].imshow(Z, interpolation='nearest', cmap=blue_red1)
fig.colorbar(im1, ax=axs[0, 0])

cmap = plt.get_cmap('BlueRed2')
im2 = axs[1, 0].imshow(Z, interpolation='nearest', cmap=cmap)
fig.colorbar(im2, ax=axs[1, 0])

# Now we will set the third cmap as the default.  One would
# not normally do this in the middle of a script like this;
# it is done here just to illustrate the method.

plt.rcParams['image.cmap'] = 'BlueRed3'

im3 = axs[0, 1].imshow(Z, interpolation='nearest')
fig.colorbar(im3, ax=axs[0, 1])
axs[0, 1].set_title("Alpha = 1")

# Or as yet another variation, we can replace the rcParams
# specification *before* the imshow with the following *after*
# imshow.
# This sets the new default *and* sets the colormap of the last
# image-like item plotted via pyplot, if any.
#

# Draw a line with low zorder so it will be behind the image.
axs[1, 1].plot([0, 10 * np.pi], [0, 20 * np.pi], color='c', lw=20, zorder=-1)

im4 = axs[1, 1].imshow(Z, interpolation='nearest')
fig.colorbar(im4, ax=axs[1, 1])

# Here it is: changing the colormap for the current image and its
# colorbar after they have been plotted.
im4.set_cmap('BlueRedAlpha')
axs[1, 1].set_title("Varying alpha")
#

fig.suptitle('Custom Blue-Red colormaps', fontsize=16)
fig.subplots_adjust(top=0.9)

plt.show()
```

![从颜色列表创建颜色映射示例2](https://matplotlib.org/_images/sphx_glr_custom_cmap_002.png)

### 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
matplotlib.figure.Figure.colorbar
matplotlib.pyplot.colorbar
matplotlib.colors
matplotlib.colors.LinearSegmentedColormap
matplotlib.colors.LinearSegmentedColormap.from_list
matplotlib.cm
matplotlib.cm.ScalarMappable.set_cmap
matplotlib.pyplot.register_cmap
matplotlib.cm.register_cmap
```

## 下载这个示例
            
- [下载python源码: custom_cmap.py](https://matplotlib.org/_downloads/custom_cmap.py)
- [下载Jupyter notebook: custom_cmap.ipynb](https://matplotlib.org/_downloads/custom_cmap.ipynb)