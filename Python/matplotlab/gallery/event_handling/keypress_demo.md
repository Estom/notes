# 按键演示

显示如何连接到按键事件

![按键演示](https://matplotlib.org/_images/sphx_glr_keypress_demo_001.png)

```python
import sys
import numpy as np
import matplotlib.pyplot as plt


def press(event):
    print('press', event.key)
    sys.stdout.flush()
    if event.key == 'x':
        visible = xl.get_visible()
        xl.set_visible(not visible)
        fig.canvas.draw()

# Fixing random state for reproducibility
np.random.seed(19680801)


fig, ax = plt.subplots()

fig.canvas.mpl_connect('key_press_event', press)

ax.plot(np.random.rand(12), np.random.rand(12), 'go')
xl = ax.set_xlabel('easy come, easy go')
ax.set_title('Press a key')
plt.show()
```

## 下载这个示例
            
- [下载python源码: keypress_demo.py](https://matplotlib.org/_downloads/keypress_demo.py)
- [下载Jupyter notebook: keypress_demo.ipynb](https://matplotlib.org/_downloads/keypress_demo.ipynb)