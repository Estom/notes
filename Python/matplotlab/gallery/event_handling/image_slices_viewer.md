# 图像切片查看器

滚动三维阵列的二维图像切片。

![图像切片查看器](https://matplotlib.org/_images/sphx_glr_image_slices_viewer_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt


class IndexTracker(object):
    def __init__(self, ax, X):
        self.ax = ax
        ax.set_title('use scroll wheel to navigate images')

        self.X = X
        rows, cols, self.slices = X.shape
        self.ind = self.slices//2

        self.im = ax.imshow(self.X[:, :, self.ind])
        self.update()

    def onscroll(self, event):
        print("%s %s" % (event.button, event.step))
        if event.button == 'up':
            self.ind = (self.ind + 1) % self.slices
        else:
            self.ind = (self.ind - 1) % self.slices
        self.update()

    def update(self):
        self.im.set_data(self.X[:, :, self.ind])
        ax.set_ylabel('slice %s' % self.ind)
        self.im.axes.figure.canvas.draw()


fig, ax = plt.subplots(1, 1)

X = np.random.rand(20, 20, 40)

tracker = IndexTracker(ax, X)


fig.canvas.mpl_connect('scroll_event', tracker.onscroll)
plt.show()
```

## 下载这个示例
            
- [下载python源码: image_slices_viewer.py](https://matplotlib.org/_downloads/image_slices_viewer.py)
- [下载Jupyter notebook: image_slices_viewer.ipynb](https://matplotlib.org/_downloads/image_slices_viewer.ipynb)