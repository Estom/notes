# 旋转自定义刻度标签

使用用户定义的旋转演示自定义刻度标签。

![旋转自定义刻度标签示例](https://matplotlib.org/_images/sphx_glr_ticklabels_rotation_001.png)

```python
import matplotlib.pyplot as plt


x = [1, 2, 3, 4]
y = [1, 4, 9, 6]
labels = ['Frogs', 'Hogs', 'Bogs', 'Slogs']

plt.plot(x, y, 'ro')
# You can specify a rotation for the tick labels in degrees or with keywords.
plt.xticks(x, labels, rotation='vertical')
# Pad margins so that markers don't get clipped by the axes
plt.margins(0.2)
# Tweak spacing to prevent clipping of tick-labels
plt.subplots_adjust(bottom=0.15)
plt.show()
```

## 下载这个示例
            
- [下载python源码: ticklabels_rotation.py](https://matplotlib.org/_downloads/ticklabels_rotation.py)
- [下载Jupyter notebook: ticklabels_rotation.ipynb](https://matplotlib.org/_downloads/ticklabels_rotation.ipynb)