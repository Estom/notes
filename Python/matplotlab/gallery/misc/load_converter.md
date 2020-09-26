# 负载转换器

![负载转换器示例](https://matplotlib.org/_images/sphx_glr_load_converter_001.png)

输出：

```python
loading /home/tcaswell/mc3/envs/dd37/lib/python3.7/site-packages/matplotlib/mpl-data/sample_data/msft.csv
```

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cbook as cbook
from matplotlib.dates import bytespdate2num

datafile = cbook.get_sample_data('msft.csv', asfileobj=False)
print('loading', datafile)

dates, closes = np.loadtxt(datafile, delimiter=',',
                           converters={0: bytespdate2num('%d-%b-%y')},
                           skiprows=1, usecols=(0, 2), unpack=True)

fig, ax = plt.subplots()
ax.plot_date(dates, closes, '-')
fig.autofmt_xdate()
plt.show()
```

## 下载这个示例
            
- [下载python源码: load_converter.py](https://matplotlib.org/_downloads/load_converter.py)
- [下载Jupyter notebook: load_converter.ipynb](https://matplotlib.org/_downloads/load_converter.ipynb)