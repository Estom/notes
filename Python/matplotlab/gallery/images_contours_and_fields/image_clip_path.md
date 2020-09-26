# 使用补丁剪切图像

演示的图像，已被一个圆形补丁裁剪。

```python
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import matplotlib.cbook as cbook


with cbook.get_sample_data('grace_hopper.png') as image_file:
    image = plt.imread(image_file)

fig, ax = plt.subplots()
im = ax.imshow(image)
patch = patches.Circle((260, 200), radius=200, transform=ax.transData)
im.set_clip_path(patch)

ax.axis('off')
plt.show()
```

![使用补丁剪切图像示例](https://matplotlib.org/_images/sphx_glr_image_clip_path_001.png)

## 参考

下面的示例演示了以下函数和方法的使用：

```python
import matplotlib
matplotlib.axes.Axes.imshow
matplotlib.pyplot.imshow
matplotlib.artist.Artist.set_clip_path
```

## 下载这个示例

- [下载python源码: image_clip_path.py](https://matplotlib.org/_downloads/image_clip_path.py)
- [下载Jupyter notebook: image_clip_path.ipynb](https://matplotlib.org/_downloads/image_clip_path.ipynb)