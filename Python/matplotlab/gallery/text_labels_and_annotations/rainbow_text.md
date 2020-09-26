# 彩虹文本

该示例演示如何将多个文本对象串在一起。

## 过去

在2012年2月的matplotlib-users列表中，GökhanSever提出以下问题：

matplotlib中有一种可以部分指定字符串的颜色的方法吗？

例子:

```python
plt.ylabel("Today is cloudy.") How can I show "today" as red, "is" as green and "cloudy." as blue?
```

感谢。

Paul Ivanov 的回答：

![彩虹文本](https://matplotlib.org/_images/sphx_glr_rainbow_text_001.png)

```python
import matplotlib.pyplot as plt
from matplotlib import transforms


def rainbow_text(x, y, strings, colors, ax=None, **kw):
    """
    Take a list of ``strings`` and ``colors`` and place them next to each
    other, with text strings[i] being shown in colors[i].

    This example shows how to do both vertical and horizontal text, and will
    pass all keyword arguments to plt.text, so you can set the font size,
    family, etc.

    The text will get added to the ``ax`` axes, if provided, otherwise the
    currently active axes will be used.
    """
    if ax is None:
        ax = plt.gca()
    t = ax.transData
    canvas = ax.figure.canvas

    # horizontal version
    for s, c in zip(strings, colors):
        text = ax.text(x, y, s + " ", color=c, transform=t, **kw)
        text.draw(canvas.get_renderer())
        ex = text.get_window_extent()
        t = transforms.offset_copy(
            text.get_transform(), x=ex.width, units='dots')

    # vertical version
    for s, c in zip(strings, colors):
        text = ax.text(x, y, s + " ", color=c, transform=t,
                       rotation=90, va='bottom', ha='center', **kw)
        text.draw(canvas.get_renderer())
        ex = text.get_window_extent()
        t = transforms.offset_copy(
            text.get_transform(), y=ex.height, units='dots')


rainbow_text(0, 0, "all unicorns poop rainbows ! ! !".split(),
             ['red', 'cyan', 'brown', 'green', 'blue', 'purple', 'black'],
             size=16)

plt.show()
```

## 下载这个示例
            
- [下载python源码: rainbow_text.py](https://matplotlib.org/_downloads/rainbow_text.py)
- [下载Jupyter notebook: rainbow_text.ipynb](https://matplotlib.org/_downloads/rainbow_text.ipynb)