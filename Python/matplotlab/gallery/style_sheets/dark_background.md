# 黑色的背景样式表

此示例演示了 “dark_background” 样式，该样式使用白色表示通常为黑色的元素（文本，边框等）。请注意，并非所有绘图元素都默认为由rc参数定义的颜色。

![黑色的背景样式表示例](https://matplotlib.org/_images/sphx_glr_dark_background_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt


plt.style.use('dark_background')

fig, ax = plt.subplots()

L = 6
x = np.linspace(0, L)
ncolors = len(plt.rcParams['axes.prop_cycle'])
shift = np.linspace(0, L, ncolors, endpoint=False)
for s in shift:
    ax.plot(x, np.sin(x + s), 'o-')
ax.set_xlabel('x-axis')
ax.set_ylabel('y-axis')
ax.set_title("'dark_background' style sheet")

plt.show()
```

## 下载这个示例
            
- [下载python源码: dark_background.py](https://matplotlib.org/_downloads/dark_background.py)
- [下载Jupyter notebook: dark_background.ipynb](https://matplotlib.org/_downloads/dark_background.ipynb)