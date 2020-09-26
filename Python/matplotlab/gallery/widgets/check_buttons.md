# 复选按钮

使用复选按钮打开和关闭视觉元素。

该程序显示了“检查按钮”的使用，类似于复选框。 显示了3种不同的正弦波，我们可以选择使用复选按钮显示哪些波形。

![复选按钮示例](https://matplotlib.org/_images/sphx_glr_check_buttons_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import CheckButtons

t = np.arange(0.0, 2.0, 0.01)
s0 = np.sin(2*np.pi*t)
s1 = np.sin(4*np.pi*t)
s2 = np.sin(6*np.pi*t)

fig, ax = plt.subplots()
l0, = ax.plot(t, s0, visible=False, lw=2, color='k', label='2 Hz')
l1, = ax.plot(t, s1, lw=2, color='r', label='4 Hz')
l2, = ax.plot(t, s2, lw=2, color='g', label='6 Hz')
plt.subplots_adjust(left=0.2)

lines = [l0, l1, l2]

# Make checkbuttons with all plotted lines with correct visibility
rax = plt.axes([0.05, 0.4, 0.1, 0.15])
labels = [str(line.get_label()) for line in lines]
visibility = [line.get_visible() for line in lines]
check = CheckButtons(rax, labels, visibility)


def func(label):
    index = labels.index(label)
    lines[index].set_visible(not lines[index].get_visible())
    plt.draw()

check.on_clicked(func)

plt.show()
```

## 下载这个示例
            
- [下载python源码: check_buttons.py](https://matplotlib.org/_downloads/check_buttons.py)
- [下载Jupyter notebook: check_buttons.ipynb](https://matplotlib.org/_downloads/check_buttons.ipynb)