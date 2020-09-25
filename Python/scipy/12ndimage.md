
## ndimage用途
SciPy的ndimage子模块专用于图像处理。这里，ndimage表示一个n维图像。
图像处理中一些最常见的任务如下:

* 输入/输出/显示图像
* 基本操作:裁剪，翻转，旋转等图像过滤
* 去噪，锐化等图像分割 
* 标记对应于不同对象的像素
* 分类
* 特征提取
* 注册/配准


## 示例
```
# 导入图像
from scipy import misc
f = misc.face()
misc.imsave('face.png', f) # uses the Image module (PIL)

import matplotlib.pyplot as plt
plt.imshow(f)
plt.show()

# 基本信息

from scipy import misc
f = misc.face()
misc.imsave('face.png', f) # uses the Image module (PIL)

face = misc.face(gray = False)
print (face.mean(), face.max(), face.min())

## 几何裁剪

from scipy import misc
f = misc.face()
misc.imsave('face.png', f) # uses the Image module (PIL)
face = misc.face(gray = True)
lx, ly = face.shape

crop_face = face[int(lx/4): -int(lx/4), int(ly/4): -int(ly/4)]

import matplotlib.pyplot as plt
plt.imshow(crop_face)
plt.show()

# 倒置图像
from scipy import misc

face = misc.face()
flip_ud_face = np.flipud(face)

import matplotlib.pyplot as plt
plt.imshow(flip_ud_face)
plt.show()

# 旋转图像
# rotation
from scipy import misc,ndimage
face = misc.face()
rotate_face = ndimage.rotate(face, 45)

import matplotlib.pyplot as plt
plt.imshow(rotate_face)
plt.show()

# 模糊滤镜

from scipy import misc
face = misc.face()
blurred_face = ndimage.gaussian_filter(face, sigma=3)
import matplotlib.pyplot as plt
plt.imshow(blurred_face)
plt.show()

# 边缘检测
import scipy.ndimage as nd
import numpy as np

im = np.zeros((256, 256))
im[64:-64, 64:-64] = 1
im[90:-90,90:-90] = 2
im = ndimage.gaussian_filter(im, 8)

import matplotlib.pyplot as plt
plt.imshow(im)
plt.show()

```

