# CanvasAgg演示

此示例展示了如何直接使用AGG后端创建图像，对于希望完全控制其代码而不使用pylot界面来管理图形、图形关闭等的Web应用程序开发人员来说，这可能是有用的。

**注意：**没有必要避免使用图形前端 - 只需将后端设置为“Agg”就足够了。

在这个例子中，我们展示了如何将画布的内容保存到文件，以及如何将它们提取到一个字符串，该字符串可以传递给PIL或放在一个numpy数组中。 后一种功能允许例如使用没有文档到磁盘的cp脚本。

```python
from matplotlib.backends.backend_agg import FigureCanvasAgg
from matplotlib.figure import Figure
import numpy as np

fig = Figure(figsize=(5, 4), dpi=100)
# A canvas must be manually attached to the figure (pyplot would automatically
# do it).  This is done by instantiating the canvas with the figure as
# argument.
canvas = FigureCanvasAgg(fig)

# Do some plotting.
ax = fig.add_subplot(111)
ax.plot([1, 2, 3])

# Option 1: Save the figure to a file; can also be a file-like object (BytesIO,
# etc.).
fig.savefig("test.png")

# Option 2: Save the figure to a string.
canvas.draw()
s, (width, height) = canvas.print_to_buffer()

# Option 2a: Convert to a NumPy array.
X = np.fromstring(s, np.uint8).reshape((height, width, 4))

# Option 2b: Pass off to PIL.
from PIL import Image
im = Image.frombytes("RGBA", (width, height), s)

# Uncomment this line to display the image using ImageMagick's `display` tool.
# im.show()
```

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.backends.backend_agg.FigureCanvasAgg
matplotlib.figure.Figure
matplotlib.figure.Figure.add_subplot
matplotlib.figure.Figure.savefig
matplotlib.axes.Axes.plot
```

## 下载这个示例
            
- [下载python源码: canvasagg.py](https://matplotlib.org/_downloads/canvasagg.py)
- [下载Jupyter notebook: canvasagg.ipynb](https://matplotlib.org/_downloads/canvasagg.ipynb)