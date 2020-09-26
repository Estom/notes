# 放置文本框

使用文本框装饰轴时，有两个有用的技巧是将文本放在轴坐标中（请参阅[转换教程](https://matplotlib.org/tutorials/advanced/transforms_tutorial.html)），因此文本不会随着x或y限制的变化而移动。 您还可以使用文本的bbox属性用[Patch](https://matplotlib.org/api/_as_gen/matplotlib.patches.Patch.html#matplotlib.patches.Patch)实例包围文本 -  bbox关键字参数使用带有Patch属性的键的字典。

![放置文本框](https://matplotlib.org/_images/sphx_glr_placing_text_boxes_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(19680801)

fig, ax = plt.subplots()
x = 30*np.random.randn(10000)
mu = x.mean()
median = np.median(x)
sigma = x.std()
textstr = '\n'.join((
    r'$\mu=%.2f$' % (mu, ),
    r'$\mathrm{median}=%.2f$' % (median, ),
    r'$\sigma=%.2f$' % (sigma, )))

ax.hist(x, 50)
# these are matplotlib.patch.Patch properties
props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)

# place a text box in upper left in axes coords
ax.text(0.05, 0.95, textstr, transform=ax.transAxes, fontsize=14,
        verticalalignment='top', bbox=props)

plt.show()
```

## 下载这个示例
            
- [下载python源码: placing_text_boxes.py](https://matplotlib.org/_downloads/placing_text_boxes.py)
- [下载Jupyter notebook: placing_text_boxes.ipynb](https://matplotlib.org/_downloads/placing_text_boxes.ipynb)