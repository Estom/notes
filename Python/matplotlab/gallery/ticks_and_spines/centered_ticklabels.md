# 居中TickLabels

有时将ticklabels置于中心是件好事。 Matplotlib目前将标签与刻度线关联，标签可以使用水平对齐属性对齐“中心”，“左”或“右”：

```python
ax.xaxis.set_tick_params(horizontalalignment='right')
```

但这并没有帮助将标签置于刻度之间。一种解决方案是“伪造它”。 使用次要刻度在主要刻度之间放置一个刻度。这是一个标记月份的示例，以ticks为中心。

![居中TickLabels示例](https://matplotlib.org/_images/sphx_glr_centered_ticklabels_001.png)

```python
import numpy as np
import matplotlib.cbook as cbook
import matplotlib.dates as dates
import matplotlib.ticker as ticker
import matplotlib.pyplot as plt

# load some financial data; apple's stock price
with cbook.get_sample_data('aapl.npz') as fh:
    r = np.load(fh)['price_data'].view(np.recarray)
r = r[-250:]  # get the last 250 days
# Matplotlib works better with datetime.datetime than np.datetime64, but the
# latter is more portable.
date = r.date.astype('O')

fig, ax = plt.subplots()
ax.plot(date, r.adj_close)

ax.xaxis.set_major_locator(dates.MonthLocator())
ax.xaxis.set_minor_locator(dates.MonthLocator(bymonthday=15))

ax.xaxis.set_major_formatter(ticker.NullFormatter())
ax.xaxis.set_minor_formatter(dates.DateFormatter('%b'))

for tick in ax.xaxis.get_minor_ticks():
    tick.tick1line.set_markersize(0)
    tick.tick2line.set_markersize(0)
    tick.label1.set_horizontalalignment('center')

imid = len(r) // 2
ax.set_xlabel(str(date[imid].year))
plt.show()
```

## 下载这个示例
            
- [下载python源码: centered_ticklabels.py](https://matplotlib.org/_downloads/centered_ticklabels.py)
- [下载Jupyter notebook: centered_ticklabels.ipynb](https://matplotlib.org/_downloads/centered_ticklabels.ipynb)