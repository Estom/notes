# 图像缩略图

您可以使用matplotlib从现有图像生成缩略图。matplotlib本身支持输入端的PNG文件，如果安装了PIL，则透明地支持其他图像类型。

```python
# build thumbnails of all images in a directory
import sys
import os
import glob
import matplotlib.image as image


if len(sys.argv) != 2:
    print('Usage: python %s IMAGEDIR' % __file__)
    raise SystemExit
indir = sys.argv[1]
if not os.path.isdir(indir):
    print('Could not find input directory "%s"' % indir)
    raise SystemExit

outdir = 'thumbs'
if not os.path.exists(outdir):
    os.makedirs(outdir)

for fname in glob.glob(os.path.join(indir, '*.png')):
    basedir, basename = os.path.split(fname)
    outfile = os.path.join(outdir, basename)
    fig = image.thumbnail(fname, outfile, scale=0.15)
    print('saved thumbnail of %s to %s' % (fname, outfile))
```

## 下载这个示例
            
- [下载python源码: image_thumbnail_sgskip.py](https://matplotlib.org/_downloads/image_thumbnail_sgskip.py)
- [下载Jupyter notebook: image_thumbnail_sgskip.ipynb](https://matplotlib.org/_downloads/image_thumbnail_sgskip.ipynb)