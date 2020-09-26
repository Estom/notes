# 自定义图类

您可以传递一个自定义的图构造函数，以确定是否要从默认图中派生。 这个简单的例子创建了一个带有图标题的图形。

![自定义图类示例](https://matplotlib.org/_images/sphx_glr_custom_figure_class_001.png)

```python
import matplotlib.pyplot as plt
from matplotlib.figure import Figure


class MyFigure(Figure):
    def __init__(self, *args, figtitle='hi mom', **kwargs):
        """
        custom kwarg figtitle is a figure title
        """
        super().__init__(*args, **kwargs)
        self.text(0.5, 0.95, figtitle, ha='center')


fig = plt.figure(FigureClass=MyFigure, figtitle='my title')
ax = fig.subplots()
ax.plot([1, 2, 3])

plt.show()
```

## 下载这个示例
            
- [下载python源码: custom_figure_class.py](https://matplotlib.org/_downloads/custom_figure_class.py)
- [下载Jupyter notebook: custom_figure_class.ipynb](https://matplotlib.org/_downloads/custom_figure_class.ipynb)