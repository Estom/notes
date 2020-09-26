# 交互功能

这提供了交互功能的使用示例，例如ginput，waitforbuttonpress和手动clabel放置。

必须使用具有图形用户界面的后端以交互方式运行此脚本（例如，使用GTK3Agg后端，而不是PS后端）。

另见： ginput_demo.py

```python
import time

import numpy as np
import matplotlib.pyplot as plt


def tellme(s):
    print(s)
    plt.title(s, fontsize=16)
    plt.draw()
```

单击三个点定义三角形

```python
plt.clf()
plt.axis([-1., 1., -1., 1.])
plt.setp(plt.gca(), autoscale_on=False)

tellme('You will define a triangle, click to begin')

plt.waitforbuttonpress()

while True:
    pts = []
    while len(pts) < 3:
        tellme('Select 3 corners with mouse')
        pts = np.asarray(plt.ginput(3, timeout=-1))
        if len(pts) < 3:
            tellme('Too few points, starting over')
            time.sleep(1)  # Wait a second

    ph = plt.fill(pts[:, 0], pts[:, 1], 'r', lw=2)

    tellme('Happy? Key click for yes, mouse click for no')

    if plt.waitforbuttonpress():
        break

    # Get rid of fill
    for p in ph:
        p.remove()
```

现在轮廓根据三角形角的距离 - 只是一个例子

```python
# Define a nice function of distance from individual pts
def f(x, y, pts):
    z = np.zeros_like(x)
    for p in pts:
        z = z + 1/(np.sqrt((x - p[0])**2 + (y - p[1])**2))
    return 1/z


X, Y = np.meshgrid(np.linspace(-1, 1, 51), np.linspace(-1, 1, 51))
Z = f(X, Y, pts)

CS = plt.contour(X, Y, Z, 20)

tellme('Use mouse to select contour label locations, middle button to finish')
CL = plt.clabel(CS, manual=True)
```

现在做一个缩放

```python
tellme('Now do a nested zoom, click to begin')
plt.waitforbuttonpress()

while True:
    tellme('Select two corners of zoom, middle mouse button to finish')
    pts = np.asarray(plt.ginput(2, timeout=-1))

    if len(pts) < 2:
        break

    pts = np.sort(pts, axis=0)
    plt.axis(pts.T.ravel())

tellme('All Done!')
plt.show()
```

## 下载这个示例
            
- [下载python源码: ginput_manual_clabel_sgskip.py](https://matplotlib.org/_downloads/ginput_manual_clabel_sgskip.py)
- [下载Jupyter notebook: ginput_manual_clabel_sgskip.ipynb](https://matplotlib.org/_downloads/ginput_manual_clabel_sgskip.ipynb)