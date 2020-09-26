# 美元符刻度

使用 [FormatStrFormatter](https://matplotlib.org/api/ticker_api.html#matplotlib.ticker.FormatStrFormatter) 在y轴标签上添加美元符号。

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# Fixing random state for reproducibility
np.random.seed(19680801)

fig, ax = plt.subplots()
ax.plot(100*np.random.rand(20))

formatter = ticker.FormatStrFormatter('$%1.2f')
ax.yaxis.set_major_formatter(formatter)

for tick in ax.yaxis.get_major_ticks():
    tick.label1On = False
    tick.label2On = True
    tick.label2.set_color('green')

plt.show()
```

![美元符号刻度示例](https://matplotlib.org/_images/sphx_glr_dollar_ticks_001.png)

## 参考

此示例中显示了以下函数，方法，类和模块的使用：

```python
import matplotlib
matplotlib.ticker
matplotlib.ticker.FormatStrFormatter
matplotlib.axis.Axis.set_major_formatter
matplotlib.axis.Axis.get_major_ticks
matplotlib.axis.Tick
```

## 下载这个示例
            
- [下载python源码: dollar_ticks.py](https://matplotlib.org/_downloads/dollar_ticks.py)
- [下载Jupyter notebook: dollar_ticks.ipynb](https://matplotlib.org/_downloads/dollar_ticks.ipynb)