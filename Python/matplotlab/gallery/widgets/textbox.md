# 文本框

允许使用Textbox小部件输入文本。

您可以使用“文本框”小部件让用户提供需要显示的任何文本，包括公式。 您可以使用提交按钮创建具有给定输入的绘图。

![文本框示例](https://matplotlib.org/_images/sphx_glr_textbox_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import TextBox
fig, ax = plt.subplots()
plt.subplots_adjust(bottom=0.2)
t = np.arange(-2.0, 2.0, 0.001)
s = t ** 2
initial_text = "t ** 2"
l, = plt.plot(t, s, lw=2)


def submit(text):
    ydata = eval(text)
    l.set_ydata(ydata)
    ax.set_ylim(np.min(ydata), np.max(ydata))
    plt.draw()

axbox = plt.axes([0.1, 0.05, 0.8, 0.075])
text_box = TextBox(axbox, 'Evaluate', initial=initial_text)
text_box.on_submit(submit)

plt.show()
```

## 下载这个示例
            
- [下载python源码: textbox.py](https://matplotlib.org/_downloads/textbox.py)
- [下载Jupyter notebook: textbox.ipynb](https://matplotlib.org/_downloads/textbox.ipynb)