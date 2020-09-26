# 子图工具栏

Matplotlib有一个工具栏可用于调整子图(suplot)间距。

![子图工具栏示例](https://matplotlib.org/_images/sphx_glr_subplot_toolbar_001.png)

![子图工具栏示例2](https://matplotlib.org/_images/sphx_glr_subplot_toolbar_002.png)

```python
import matplotlib.pyplot as plt
import numpy as np

fig, axs = plt.subplots(2, 2)

axs[0, 0].imshow(np.random.random((100, 100)))

axs[0, 1].imshow(np.random.random((100, 100)))

axs[1, 0].imshow(np.random.random((100, 100)))

axs[1, 1].imshow(np.random.random((100, 100)))

plt.subplot_tool()
plt.show()
```

## 下载这个示例
            
- [下载python源码: subplot_toolbar.py](https://matplotlib.org/_downloads/subplot_toolbar.py)
- [下载Jupyter notebook: subplot_toolbar.ipynb](https://matplotlib.org/_downloads/subplot_toolbar.ipynb)