# 演示Imagegrid Aspect

![演示Imagegrid Aspect](https://matplotlib.org/_images/sphx_glr_demo_imagegrid_aspect_001.png)

```python
import matplotlib.pyplot as plt

from mpl_toolkits.axes_grid1 import ImageGrid
fig = plt.figure(1)

grid1 = ImageGrid(fig, 121, (2, 2), axes_pad=0.1,
                  aspect=True, share_all=True)

for i in [0, 1]:
    grid1[i].set_aspect(2)


grid2 = ImageGrid(fig, 122, (2, 2), axes_pad=0.1,
                  aspect=True, share_all=True)


for i in [1, 3]:
    grid2[i].set_aspect(2)

plt.show()
```

## 下载这个示例
            
- [下载python源码: demo_imagegrid_aspect.py](https://matplotlib.org/_downloads/demo_imagegrid_aspect.py)
- [下载Jupyter notebook: demo_imagegrid_aspect.ipynb](https://matplotlib.org/_downloads/demo_imagegrid_aspect.ipynb)