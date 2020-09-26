# 时间序列的自定义刻度格式化程序

当绘制时间序列（例如，金融时间序列）时，人们经常想要省去没有数据的日子，即周末。下面的示例显示了如何使用“索引格式化程序”来实现所需的绘图。

![时间序列的自定义刻度格式化程序示例](https://matplotlib.org/_images/sphx_glr_date_index_formatter_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cbook as cbook
import matplotlib.ticker as ticker

# Load a numpy record array from yahoo csv data with fields date, open, close,
# volume, adj_close from the mpl-data/example directory. The record array
# stores the date as an np.datetime64 with a day unit ('D') in the date column.
with cbook.get_sample_data('goog.npz') as datafile:
    r = np.load(datafile)['price_data'].view(np.recarray)
r = r[-30:]  # get the last 30 days
# Matplotlib works better with datetime.datetime than np.datetime64, but the
# latter is more portable.
date = r.date.astype('O')

# first we'll do it the default way, with gaps on weekends
fig, axes = plt.subplots(ncols=2, figsize=(8, 4))
ax = axes[0]
ax.plot(date, r.adj_close, 'o-')
ax.set_title("Default")
fig.autofmt_xdate()

# next we'll write a custom formatter
N = len(r)
ind = np.arange(N)  # the evenly spaced plot indices


def format_date(x, pos=None):
    thisind = np.clip(int(x + 0.5), 0, N - 1)
    return date[thisind].strftime('%Y-%m-%d')

ax = axes[1]
ax.plot(ind, r.adj_close, 'o-')
ax.xaxis.set_major_formatter(ticker.FuncFormatter(format_date))
ax.set_title("Custom tick formatter")
fig.autofmt_xdate()

plt.show()
```

## 下载这个示例
            
- [下载python源码: date_index_formatter.py](https://matplotlib.org/_downloads/date_index_formatter.py)
- [下载Jupyter notebook: date_index_formatter.ipynb](https://matplotlib.org/_downloads/date_index_formatter.ipynb)