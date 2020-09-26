# 演示日期Rrule

展示如何使用Rrule实例制作自定义日期自动收报机 - 这里我们在每5个复活节放置一个刻度线。

有关Rrules的帮助，请参阅https://dateutil.readthedocs.io/en/stable/

![演示日期Rrule示例](https://matplotlib.org/_images/sphx_glr_date_demo_rrule_001.png)

```python
import matplotlib.pyplot as plt
from matplotlib.dates import (YEARLY, DateFormatter,
                              rrulewrapper, RRuleLocator, drange)
import numpy as np
import datetime

# Fixing random state for reproducibility
np.random.seed(19680801)


# tick every 5th easter
rule = rrulewrapper(YEARLY, byeaster=1, interval=5)
loc = RRuleLocator(rule)
formatter = DateFormatter('%m/%d/%y')
date1 = datetime.date(1952, 1, 1)
date2 = datetime.date(2004, 4, 12)
delta = datetime.timedelta(days=100)

dates = drange(date1, date2, delta)
s = np.random.rand(len(dates))  # make up some random y values


fig, ax = plt.subplots()
plt.plot_date(dates, s)
ax.xaxis.set_major_locator(loc)
ax.xaxis.set_major_formatter(formatter)
ax.xaxis.set_tick_params(rotation=30, labelsize=10)

plt.show()
```

## 下载这个示例
            
- [下载python源码: date_demo_rrule.py](https://matplotlib.org/_downloads/date_demo_rrule.py)
- [下载Jupyter notebook: date_demo_rrule.ipynb](https://matplotlib.org/_downloads/date_demo_rrule.ipynb)