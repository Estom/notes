# Agg缓冲区转换数组

将渲染图形转换为其图像(NumPy数组)表示形式。

![Agg缓冲区转换数组示例](https://matplotlib.org/_images/sphx_glr_agg_buffer_to_array_001.png)

![Agg缓冲区转换数组示例2](https://matplotlib.org/_images/sphx_glr_agg_buffer_to_array_002.png)

```python
import matplotlib.pyplot as plt
import numpy as np

# make an agg figure
fig, ax = plt.subplots()
ax.plot([1, 2, 3])
ax.set_title('a simple figure')
fig.canvas.draw()

# grab the pixel buffer and dump it into a numpy array
X = np.array(fig.canvas.renderer._renderer)

# now display the array X as an Axes in a new figure
fig2 = plt.figure()
ax2 = fig2.add_subplot(111, frameon=False)
ax2.imshow(X)
plt.show()
```

## 下载这个示例
            
- [下载python源码: agg_buffer_to_array.py](https://matplotlib.org/_downloads/agg_buffer_to_array.py)
- [下载Jupyter notebook: agg_buffer_to_array.ipynb](https://matplotlib.org/_downloads/agg_buffer_to_array.ipynb)