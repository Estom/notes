# 从值列表中设置刻度标签

使用ax.set_xticks会导致在当前选择的刻度上设置刻度标签。 但是，您可能希望允许matplotlib动态选择刻度数及其间距。

在这种情况下，最好从刻度线上的值确定刻度标签。 以下示例显示了如何执行此操作。

注意：这里使用MaxNLocator来确保刻度值取整数值。

![从值列表中设置刻度标签示例](https://matplotlib.org/_images/sphx_glr_tick_labels_from_values_001.png)

```python
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter, MaxNLocator
fig, ax = plt.subplots()
xs = range(26)
ys = range(26)
labels = list('abcdefghijklmnopqrstuvwxyz')


def format_fn(tick_val, tick_pos):
    if int(tick_val) in xs:
        return labels[int(tick_val)]
    else:
        return ''


ax.xaxis.set_major_formatter(FuncFormatter(format_fn))
ax.xaxis.set_major_locator(MaxNLocator(integer=True))
ax.plot(xs, ys)
plt.show()
```

## 下载这个示例
            
- [下载python源码: tick_labels_from_values.py](https://matplotlib.org/_downloads/tick_labels_from_values.py)
- [下载Jupyter notebook: tick_labels_from_values.ipynb](https://matplotlib.org/_downloads/tick_labels_from_values.ipynb)