# Hinton图

Hinton图对于可视化2D阵列的值（例如，权重矩阵）是有用的：正值和负值分别由白色和黑色方块表示，并且每个方块的大小表示每个值的大小。

David Warde-Farley在SciPy Cookbook上的初步想法

![Hinton图示例](https://matplotlib.org/_images/sphx_glr_hinton_demo_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt


def hinton(matrix, max_weight=None, ax=None):
    """Draw Hinton diagram for visualizing a weight matrix."""
    ax = ax if ax is not None else plt.gca()

    if not max_weight:
        max_weight = 2 ** np.ceil(np.log(np.abs(matrix).max()) / np.log(2))

    ax.patch.set_facecolor('gray')
    ax.set_aspect('equal', 'box')
    ax.xaxis.set_major_locator(plt.NullLocator())
    ax.yaxis.set_major_locator(plt.NullLocator())

    for (x, y), w in np.ndenumerate(matrix):
        color = 'white' if w > 0 else 'black'
        size = np.sqrt(np.abs(w) / max_weight)
        rect = plt.Rectangle([x - size / 2, y - size / 2], size, size,
                             facecolor=color, edgecolor=color)
        ax.add_patch(rect)

    ax.autoscale_view()
    ax.invert_yaxis()


if __name__ == '__main__':
    # Fixing random state for reproducibility
    np.random.seed(19680801)

    hinton(np.random.rand(20, 20) - 0.5)
    plt.show()
```

## 下载这个示例
            
- [下载python源码: hinton_demo.py](https://matplotlib.org/_downloads/hinton_demo.py)
- [下载Jupyter notebook: hinton_demo.ipynb](https://matplotlib.org/_downloads/hinton_demo.ipynb)