# 透明、花式的图形

有时您在绘制数据之前就知道数据的样子，并且可能知道例如右上角没有太多数据。然后，您可以安全地创建不覆盖数据的图例：

```python
ax.legend(loc='upper right')
```

其他时候你不知道你的数据在哪里，默认的loc ='best'会尝试放置图例：

```python
ax.legend()
```

但是，您的图例可能会与您的数据重叠，在这些情况下，使图例框架透明是很好的。

![透明、花式的图形示例](https://matplotlib.org/_images/sphx_glr_transparent_legends_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

np.random.seed(1234)
fig, ax = plt.subplots(1)
ax.plot(np.random.randn(300), 'o-', label='normal distribution')
ax.plot(np.random.rand(300), 's-', label='uniform distribution')
ax.set_ylim(-3, 3)

ax.legend(fancybox=True, framealpha=0.5)
ax.set_title('fancy, transparent legends')

plt.show()
```

## 下载这个示例
            
- [下载python源码: transparent_legends.py](https://matplotlib.org/_downloads/transparent_legends.py)
- [下载Jupyter notebook: transparent_legends.ipynb](https://matplotlib.org/_downloads/transparent_legends.ipynb)