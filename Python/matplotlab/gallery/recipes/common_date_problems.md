# 修复常见的日期困扰

Matplotlib允许您原生地绘制python日期时间实例，并且在大多数情况下可以很好地选择刻度位置和字符串格式。 有一些事情没有得到如此优雅的处理，这里有一些技巧可以帮助你解决它们。我们将在numpy记录数组中加载一些包含datetime.date对象的样本日期数据：

```python
In [63]: datafile = cbook.get_sample_data('goog.npz')

In [64]: r = np.load(datafile)['price_data'].view(np.recarray)

In [65]: r.dtype
Out[65]: dtype([('date', '<M8[D]'), ('', '|V4'), ('open', '<f8'),
                ('high', '<f8'), ('low', '<f8'), ('close', '<f8'),
                ('volume', '<i8'),  ('adj_close', '<f8')])

In [66]: r.date
Out[66]:
array(['2004-08-19', '2004-08-20', '2004-08-23', ..., '2008-10-10',
       '2008-10-13', '2008-10-14'], dtype='datetime64[D]')
```

字段日期的NumPy记录数组的dtype是datetime64[D]，这意味着它是'day'单位的64位np.datetime64。 虽然这种格式更便于携带，但Matplotlib无法原生地绘制此格式。 我们可以通过将日期更改为[datetime.date](https://docs.python.org/3/library/datetime.html#datetime.date)实例来绘制此数据，这可以通过转换为对象数组来实现：

```python
In [67]: r.date.astype('O')
array([datetime.date(2004, 8, 19), datetime.date(2004, 8, 20),
       datetime.date(2004, 8, 23), ..., datetime.date(2008, 10, 10),
       datetime.date(2008, 10, 13), datetime.date(2008, 10, 14)],
      dtype=object)
```

此转换后的数组的dtype现在是对象，而是填充了datetime.date实例。

如果您绘制数据，

```python
In [67]: plot(r.date.astype('O'), r.close)
Out[67]: [<matplotlib.lines.Line2D object at 0x92a6b6c>]
```

你会看到x刻度标签都被压扁了。

```python
import matplotlib.cbook as cbook
import matplotlib.dates as mdates
import numpy as np
import matplotlib.pyplot as plt

with cbook.get_sample_data('goog.npz') as datafile:
    r = np.load(datafile)['price_data'].view(np.recarray)

# Matplotlib prefers datetime instead of np.datetime64.
date = r.date.astype('O')
fig, ax = plt.subplots()
ax.plot(date, r.close)
ax.set_title('Default date handling can cause overlapping labels')
```

![修复常见的日期困扰示例](https://matplotlib.org/_images/sphx_glr_common_date_problems_001.png)

另一个烦恼是，如果您将鼠标悬停在窗口上并在x和y坐标处查看matplotlib工具栏（[交互式导航](https://matplotlib.org/users/navigation_toolbar.html#navigation-toolbar)）的右下角，您会看到x位置的格式与刻度标签的格式相同， 例如，“2004年12月”。

我们想要的是工具栏中的位置具有更高的精确度，例如，为我们提供鼠标悬停的确切日期。 为了解决第一个问题，我们可以使用[matplotlib.figure.Figure.autofmt_xdate()](https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.autofmt_xdate) 来修复第二个问题，我们可以使用ax.fmt_xdata属性，该属性可以设置为任何带标量并返回字符串的函数。 matplotlib内置了许多日期格式化程序，因此我们将使用其中之一。


```python
fig, ax = plt.subplots()
ax.plot(date, r.close)

# rotate and align the tick labels so they look better
fig.autofmt_xdate()

# use a more precise date string for the x axis locations in the
# toolbar
ax.fmt_xdata = mdates.DateFormatter('%Y-%m-%d')
ax.set_title('fig.autofmt_xdate fixes the labels')
```

![修复常见的日期困扰2](https://matplotlib.org/_images/sphx_glr_common_date_problems_002.png)

现在，当您将鼠标悬停在绘制的数据上时，您将在工具栏中看到日期格式字符串，如2004-12-01。

```python
plt.show()
```

## 下载这个示例
            
- [下载python源码: common_date_problems.py](https://matplotlib.org/_downloads/common_date_problems.py)
- [下载Jupyter notebook: common_date_problems.ipynb](https://matplotlib.org/_downloads/common_date_problems.ipynb)