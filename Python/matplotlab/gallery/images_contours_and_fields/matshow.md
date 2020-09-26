# Matshow

简单的 matshow 例子。

```python
import matplotlib.pyplot as plt
import numpy as np


def samplemat(dims):
    """Make a matrix with all zeros and increasing elements on the diagonal"""
    aa = np.zeros(dims)
    for i in range(min(dims)):
        aa[i, i] = i
    return aa


# Display matrix
plt.matshow(samplemat((15, 15)))

plt.show()
```

![matshow示例](https://matplotlib.org/_images/sphx_glr_matshow_001.png)

## 参考

此示例中显示了以下函数和方法的用法：

```python
import matplotlib
matplotlib.axes.Axes.matshow
matplotlib.pyplot.matshow
```

## 下载这个示例

- [下载python源码: matshow.py](https://matplotlib.org/_downloads/matshow.py)
- [下载Jupyter notebook: matshow.ipynb](https://matplotlib.org/_downloads/matshow.ipynb)