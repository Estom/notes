# 轻松创建子图

在matplotlib的早期版本中，如果你想使用pythonic API并创建一个图形实例，并从中创建一个子图的网格，可能有共享轴，它涉及相当数量的样板代码。例如：

```python
import matplotlib.pyplot as plt
import numpy as np

x = np.random.randn(50)

# old style
fig = plt.figure()
ax1 = fig.add_subplot(221)
ax2 = fig.add_subplot(222, sharex=ax1, sharey=ax1)
ax3 = fig.add_subplot(223, sharex=ax1, sharey=ax1)
ax3 = fig.add_subplot(224, sharex=ax1, sharey=ax1)
```

![轻松创建子图示例](https://matplotlib.org/_images/sphx_glr_create_subplots_001.png)

费尔南多·佩雷斯提供了一个很好的方法来创建子图的一切 ``subplots()``（最后注意“s”），并为整个群体打开x和y共享。您可以单独打开轴...

```python
# new style method 1; unpack the axes
fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, sharex=True, sharey=True)
ax1.plot(x)
```

![轻松创建子图示例2](https://matplotlib.org/_images/sphx_glr_create_subplots_002.png)

或者将它们作为支持numpy索引的numrows x numcolumns对象数组返回

```python
# new style method 2; use an axes array
fig, axs = plt.subplots(2, 2, sharex=True, sharey=True)
axs[0, 0].plot(x)

plt.show()
```

![轻松创建子图示例3](https://matplotlib.org/_images/sphx_glr_create_subplots_003.png)

## 下载这个示例
            
- [下载python源码: create_subplots.py](https://matplotlib.org/_downloads/create_subplots.py)
- [下载Jupyter notebook: create_subplots.ipynb](https://matplotlib.org/_downloads/create_subplots.ipynb)