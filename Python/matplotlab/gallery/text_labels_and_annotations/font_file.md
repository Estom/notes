# 在Matplotlib中使用TTF字体文件

虽然为字体实例显式指向单个ttf文件通常不是一个好主意，但您可以使用 ``font_manager.FontProperties`` *fname* 参数执行此操作。

在这里，我们使用Matplotlib附带的计算机现代罗马字体（``cmr10``）。

有关更灵活的解决方案，请参见[配置字体系列](https://matplotlib.org/gallery/text_labels_and_annotations/font_family_rc_sgskip.html)和[字体演示(面向对象的样式)](https://matplotlib.org/gallery/text_labels_and_annotations/fonts_demo.html)。

```python
import os
from matplotlib import font_manager as fm, rcParams
import matplotlib.pyplot as plt

fig, ax = plt.subplots()

fpath = os.path.join(rcParams["datapath"], "fonts/ttf/cmr10.ttf")
prop = fm.FontProperties(fname=fpath)
fname = os.path.split(fpath)[1]
ax.set_title('This is a special font: {}'.format(fname), fontproperties=prop)
ax.set_xlabel('This is the default font')

plt.show()
```

![在Matplotlib中使用TTF字体文件](https://matplotlib.org/_images/sphx_glr_font_file_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.font_manager.FontProperties
matplotlib.axes.Axes.set_title
```

## 下载这个示例
            
- [下载python源码: font_file.py](https://matplotlib.org/_downloads/font_file.py)
- [下载Jupyter notebook: font_file.ipynb](https://matplotlib.org/_downloads/font_file.ipynb)