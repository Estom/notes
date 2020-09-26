# 使用字典控制文本和标签的样式

此示例显示如何通过创建跨多个函数传递的选项字典来跨多个文本对象和标签共享参数。

![使用字典控制文本和标签的样式示例](https://matplotlib.org/_images/sphx_glr_text_fontdict_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt


font = {'family': 'serif',
        'color':  'darkred',
        'weight': 'normal',
        'size': 16,
        }

x = np.linspace(0.0, 5.0, 100)
y = np.cos(2*np.pi*x) * np.exp(-x)

plt.plot(x, y, 'k')
plt.title('Damped exponential decay', fontdict=font)
plt.text(2, 0.65, r'$\cos(2 \pi t) \exp(-t)$', fontdict=font)
plt.xlabel('time (s)', fontdict=font)
plt.ylabel('voltage (mV)', fontdict=font)

# Tweak spacing to prevent clipping of ylabel
plt.subplots_adjust(left=0.15)
plt.show()
```

## 下载这个示例
            
- [下载python源码: text_fontdict.py](https://matplotlib.org/_downloads/text_fontdict.py)
- [下载Jupyter notebook: text_fontdict.ipynb](https://matplotlib.org/_downloads/text_fontdict.ipynb)