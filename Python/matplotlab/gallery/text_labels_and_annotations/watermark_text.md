# 文字水印

添加文字水印。

```python
import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)


fig, ax = plt.subplots()
ax.plot(np.random.rand(20), '-o', ms=20, lw=2, alpha=0.7, mfc='orange')
ax.grid()

fig.text(0.95, 0.05, 'Property of MPL',
         fontsize=50, color='gray',
         ha='right', va='bottom', alpha=0.5)

plt.show()
```

![文字水印示例](https://matplotlib.org/_images/sphx_glr_watermark_text_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.figure.Figure.text
```

## 下载这个示例
            
- [下载python源码: watermark_text.py](https://matplotlib.org/_downloads/watermark_text.py)
- [下载Jupyter notebook: watermark_text.ipynb](https://matplotlib.org/_downloads/watermark_text.ipynb)