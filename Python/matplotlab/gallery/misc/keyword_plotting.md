# 用关键字绘图

在某些情况下，您可以使用允许您使用字符串访问特定变量的格式的数据。 例如，使用 [numpy.recarray](https://docs.scipy.org/doc/numpy/reference/generated/numpy.recarray.html#numpy.recarray) 或[pandas.DataFrame](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.html#pandas.DataFrame)。

Matplotlib允许您使用data关键字参数提供此类对象。如果提供，则可以生成具有与这些变量对应的字符串的图。

![用关键字绘图示例](https://matplotlib.org/_images/sphx_glr_keyword_plotting_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
np.random.seed(19680801)

data = {'a': np.arange(50),
        'c': np.random.randint(0, 50, 50),
        'd': np.random.randn(50)}
data['b'] = data['a'] + 10 * np.random.randn(50)
data['d'] = np.abs(data['d']) * 100

fig, ax = plt.subplots()
ax.scatter('a', 'b', c='c', s='d', data=data)
ax.set(xlabel='entry a', ylabel='entry b')
plt.show()
```

## 下载这个示例
            
- [下载python源码: keyword_plotting.py](https://matplotlib.org/_downloads/keyword_plotting.py)
- [下载Jupyter notebook: keyword_plotting.ipynb](https://matplotlib.org/_downloads/keyword_plotting.ipynb)