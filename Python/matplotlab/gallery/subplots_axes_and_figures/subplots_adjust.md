# 调整子图

使用 [subplots_adjust()](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.subplots_adjust.html#matplotlib.pyplot.subplots_adjust) 调整边距和子图的间距。

![调整子图](https://matplotlib.org/_images/sphx_glr_subplots_adjust_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)


plt.subplot(211)
plt.imshow(np.random.random((100, 100)), cmap=plt.cm.BuPu_r)
plt.subplot(212)
plt.imshow(np.random.random((100, 100)), cmap=plt.cm.BuPu_r)

plt.subplots_adjust(bottom=0.1, right=0.8, top=0.9)
cax = plt.axes([0.85, 0.1, 0.075, 0.8])
plt.colorbar(cax=cax)
plt.show()
```

## 下载这个示例
            
- [下载python源码: subplots_adjust.py](https://matplotlib.org/_downloads/subplots_adjust.py)
- [下载Jupyter notebook: subplots_adjust.ipynb](https://matplotlib.org/_downloads/subplots_adjust.ipynb)