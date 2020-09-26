# MRI

此示例说明如何将（MRI）图像读入NumPy阵列，并使用imshow以灰度显示。

![MRI示例](https://matplotlib.org/_images/sphx_glr_mri_demo_001.png)

```python
import matplotlib.pyplot as plt
import matplotlib.cbook as cbook
import matplotlib.cm as cm
import numpy as np


# Data are 256x256 16 bit integers
with cbook.get_sample_data('s1045.ima.gz') as dfile:
    im = np.fromstring(dfile.read(), np.uint16).reshape((256, 256))

fig, ax = plt.subplots(num="MRI_demo")
ax.imshow(im, cmap=cm.gray)
ax.axis('off')

plt.show()
```

## 下载这个示例
            
- [下载python源码: mri_demo.py](https://matplotlib.org/_downloads/mri_demo.py)
- [下载Jupyter notebook: mri_demo.ipynb](https://matplotlib.org/_downloads/mri_demo.ipynb)