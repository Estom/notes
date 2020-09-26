# 相对线的文本旋转

matplotlib中的文本对象通常相对于屏幕坐标系旋转(即，无论轴如何更改，沿水平和垂直之间的直线旋转45度打印文本)。但是，有时需要围绕打印上的某个内容旋转文本。在这种情况下，正确的角度将不是该对象在打印坐标系中的角度，而是该对象在屏幕坐标系中显示的角度。此角度是通过将角度从打印转换为屏幕坐标系来找到的，如下面的示例所示。

![相对线的文本旋转示例](https://matplotlib.org/_images/sphx_glr_text_rotation_relative_to_line_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

# Plot diagonal line (45 degrees)
h = plt.plot(np.arange(0, 10), np.arange(0, 10))

# set limits so that it no longer looks on screen to be 45 degrees
plt.xlim([-10, 20])

# Locations to plot text
l1 = np.array((1, 1))
l2 = np.array((5, 5))

# Rotate angle
angle = 45
trans_angle = plt.gca().transData.transform_angles(np.array((45,)),
                                                   l2.reshape((1, 2)))[0]

# Plot text
th1 = plt.text(l1[0], l1[1], 'text not rotated correctly', fontsize=16,
               rotation=angle, rotation_mode='anchor')
th2 = plt.text(l2[0], l2[1], 'text rotated correctly', fontsize=16,
               rotation=trans_angle, rotation_mode='anchor')

plt.show()
```

## 下载这个示例
            
- [下载python源码: text_rotation_relative_to_line.py](https://matplotlib.org/_downloads/text_rotation_relative_to_line.py)
- [下载Jupyter notebook: text_rotation_relative_to_line.ipynb](https://matplotlib.org/_downloads/text_rotation_relative_to_line.ipynb)