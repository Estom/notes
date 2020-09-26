# 艺术家中的艺术家

重写基本方法，以便一个艺术家对象可以包含另一个艺术家对象。在这种情况下，该行包含一个文本实例来为其添加标签。

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as lines
import matplotlib.transforms as mtransforms
import matplotlib.text as mtext


class MyLine(lines.Line2D):
    def __init__(self, *args, **kwargs):
        # we'll update the position when the line data is set
        self.text = mtext.Text(0, 0, '')
        lines.Line2D.__init__(self, *args, **kwargs)

        # we can't access the label attr until *after* the line is
        # initiated
        self.text.set_text(self.get_label())

    def set_figure(self, figure):
        self.text.set_figure(figure)
        lines.Line2D.set_figure(self, figure)

    def set_axes(self, axes):
        self.text.set_axes(axes)
        lines.Line2D.set_axes(self, axes)

    def set_transform(self, transform):
        # 2 pixel offset
        texttrans = transform + mtransforms.Affine2D().translate(2, 2)
        self.text.set_transform(texttrans)
        lines.Line2D.set_transform(self, transform)

    def set_data(self, x, y):
        if len(x):
            self.text.set_position((x[-1], y[-1]))

        lines.Line2D.set_data(self, x, y)

    def draw(self, renderer):
        # draw my label at the end of the line with 2 pixel offset
        lines.Line2D.draw(self, renderer)
        self.text.draw(renderer)

# Fixing random state for reproducibility
np.random.seed(19680801)


fig, ax = plt.subplots()
x, y = np.random.rand(2, 20)
line = MyLine(x, y, mfc='red', ms=12, label='line label')
#line.text.set_text('line label')
line.text.set_color('red')
line.text.set_fontsize(16)

ax.add_line(line)

plt.show()
```

![艺术家中的艺术家](https://matplotlib.org/_images/sphx_glr_line_with_text_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.lines
matplotlib.lines.Line2D
matplotlib.lines.Line2D.set_data
matplotlib.artist
matplotlib.artist.Artist
matplotlib.artist.Artist.draw
matplotlib.artist.Artist.set_transform
matplotlib.text
matplotlib.text.Text
matplotlib.text.Text.set_color
matplotlib.text.Text.set_fontsize
matplotlib.text.Text.set_position
matplotlib.axes.Axes.add_line
matplotlib.transforms
matplotlib.transforms.Affine2D
```

## 下载这个示例
            
- [下载python源码: line_with_text.py](https://matplotlib.org/_downloads/line_with_text.py)
- [下载Jupyter notebook: line_with_text.ipynb](https://matplotlib.org/_downloads/line_with_text.ipynb)