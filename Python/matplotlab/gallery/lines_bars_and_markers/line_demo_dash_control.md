# 自定义虚线样式

通过破折号序列控制线的划线。 它可以使用[Line2D.set_dashes](https://matplotlib.org/api/_as_gen/matplotlib.lines.Line2D.html#matplotlib.lines.Line2D.set_dashes)进行修改。

破折号序列是一系列点的开/关长度，例如 [3,1]将是由1pt空间隔开的3pt长线。

像[Axes.plot](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.plot.html#matplotlib.axes.Axes.plot) 这样的函数支持将Line属性作为关键字参数传递。 在这种情况下，您可以在创建线时设置划线。

注意：也可以通过[property_cycle](https://matplotlib.org/tutorials/intermediate/color_cycle.html)配置破折号样式，方法是使用关键字破折号将破折号序列列表传递给循环器。这个例子中没有显示。

![自定义虚线样式](https://matplotlib.org/_images/sphx_glr_line_demo_dash_control_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0, 10, 500)
y = np.sin(x)

fig, ax = plt.subplots()

# Using set_dashes() to modify dashing of an existing line
line1, = ax.plot(x, y, label='Using set_dashes()')
line1.set_dashes([2, 2, 10, 2])  # 2pt line, 2pt break, 10pt line, 2pt break

# Using plot(..., dashes=...) to set the dashing when creating a line
line2, = ax.plot(x, y - 0.2, dashes=[6, 2], label='Using the dashes parameter')

ax.legend()
plt.show()
```

## 下载这个示例

- [下载python源码: line_demo_dash_control.py](https://matplotlib.org/_downloads/line_demo_dash_control.py)
- [下载Jupyter notebook: line_demo_dash_control.ipynb](https://matplotlib.org/_downloads/line_demo_dash_control.ipynb)