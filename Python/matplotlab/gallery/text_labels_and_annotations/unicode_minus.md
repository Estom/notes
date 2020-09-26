# Unicode 负表示

您可以使用正确的排版[Unicode 负号](https://en.wikipedia.org/wiki/Plus_and_minus_signs#Character_codes)或ASCII连字符表示负好，有些开发者倾向于这样做。 

[rcParams["axes.unicode_minus"]](https://matplotlib.org/tutorials/introductory/customizing.html#matplotlib-rcparams)控制默认行为。

默认是使用Unicode负号。

![负数示例](https://matplotlib.org/_images/sphx_glr_unicode_minus_001.png)

```python
import numpy as np
import matplotlib
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)


matplotlib.rcParams['axes.unicode_minus'] = False
fig, ax = plt.subplots()
ax.plot(10*np.random.randn(100), 10*np.random.randn(100), 'o')
ax.set_title('Using hyphen instead of Unicode minus')
plt.show()
```

## 下载这个示例
            
- [下载python源码: unicode_minus.py](https://matplotlib.org/_downloads/unicode_minus.py)
- [下载Jupyter notebook: unicode_minus.ipynb](https://matplotlib.org/_downloads/unicode_minus.ipynb)