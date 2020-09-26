# 配置字体系列

你可以明确地设置为给定字体样式拾取的字体系列(例如，‘serif’、‘sans-serif’或‘monSpace’)。

在下面的示例中，我们只允许一个字体系列（Tahoma）用于sans-serif字体样式。你是font.family rc param的默认系列，例如：

```python
rcParams['font.family'] = 'sans-serif'
```

并为font.family设置一个字体样式列表，以尝试按顺序查找：

```python
rcParams['font.sans-serif'] = ['Tahoma', 'DejaVu Sans',
                               'Lucida Grande', 'Verdana']
```

```python
from matplotlib import rcParams
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Tahoma']
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.plot([1, 2, 3], label='test')

ax.legend()
plt.show()
```

## 下载这个示例
            
- [下载python源码: font_family_rc_sgskip.py](https://matplotlib.org/_downloads/font_family_rc_sgskip.py)
- [下载Jupyter notebook: font_family_rc_sgskip.ipynb](https://matplotlib.org/_downloads/font_family_rc_sgskip.ipynb)