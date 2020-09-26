# 图像水印

使用PNG文件作为水印。

```python
import numpy as np
import matplotlib.cbook as cbook
import matplotlib.image as image
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)


datafile = cbook.get_sample_data('logo2.png', asfileobj=False)
print('loading %s' % datafile)
im = image.imread(datafile)
im[:, :, -1] = 0.5  # set the alpha channel

fig, ax = plt.subplots()

ax.plot(np.random.rand(20), '-o', ms=20, lw=2, alpha=0.7, mfc='orange')
ax.grid()
fig.figimage(im, 10, 10, zorder=3)

plt.show()
```

![图像水印示例](https://matplotlib.org/_images/sphx_glr_watermark_image_001.png)

Out:

```sh
loading /home/tcaswell/mc3/envs/dd37/lib/python3.7/site-packages/matplotlib/mpl-data/sample_data/logo2.png
```

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.image
matplotlib.image.imread
matplotlib.pyplot.imread
matplotlib.figure.Figure.figimage
```

## 下载这个示例

- [下载python源码: watermark_image.py](https://matplotlib.org/_downloads/watermark_image.py)
- [下载Jupyter notebook: watermark_image.ipynb](https://matplotlib.org/_downloads/watermark_image.ipynb)