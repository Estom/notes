# 绘制事件集的示例

绘制两条曲线，然后使用EventCollections标记每条曲线的相应轴上的x和y数据点的位置

![绘制事件集的示例](https://matplotlib.org/_images/sphx_glr_eventcollection_demo_001.png);

```python
import matplotlib.pyplot as plt
from matplotlib.collections import EventCollection
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)

# create random data
xdata = np.random.random([2, 10])

# split the data into two parts
xdata1 = xdata[0, :]
xdata2 = xdata[1, :]

# sort the data so it makes clean curves
xdata1.sort()
xdata2.sort()

# create some y data points
ydata1 = xdata1 ** 2
ydata2 = 1 - xdata2 ** 3

# plot the data
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
ax.plot(xdata1, ydata1, 'r', xdata2, ydata2, 'b')

# create the events marking the x data points
xevents1 = EventCollection(xdata1, color=[1, 0, 0], linelength=0.05)
xevents2 = EventCollection(xdata2, color=[0, 0, 1], linelength=0.05)

# create the events marking the y data points
yevents1 = EventCollection(ydata1, color=[1, 0, 0], linelength=0.05,
                           orientation='vertical')
yevents2 = EventCollection(ydata2, color=[0, 0, 1], linelength=0.05,
                           orientation='vertical')

# add the events to the axis
ax.add_collection(xevents1)
ax.add_collection(xevents2)
ax.add_collection(yevents1)
ax.add_collection(yevents2)

# set the limits
ax.set_xlim([0, 1])
ax.set_ylim([0, 1])

ax.set_title('line plot with data points')

# display the plot
plt.show()
```

## 下载这个示例

- [下载python源码: eventcollection_demo.py](https://matplotlib.org/_downloads/eventcollection_demo.py)
- [下载Jupyter notebook: eventcollection_demo.ipynb](https://matplotlib.org/_downloads/eventcollection_demo.ipynb)