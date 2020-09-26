# 水平条形图

这个例子展示了一个简单的水平条形图。

![水平条形图示](https://matplotlib.org/_images/sphx_glr_barh_001.png);

```python
import matplotlib.pyplot as plt
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)


plt.rcdefaults()
fig, ax = plt.subplots()

# Example data
people = ('Tom', 'Dick', 'Harry', 'Slim', 'Jim')
y_pos = np.arange(len(people))
performance = 3 + 10 * np.random.rand(len(people))
error = np.random.rand(len(people))

ax.barh(y_pos, performance, xerr=error, align='center',
        color='green', ecolor='black')
ax.set_yticks(y_pos)
ax.set_yticklabels(people)
ax.invert_yaxis()  # labels read top-to-bottom
ax.set_xlabel('Performance')
ax.set_title('How fast do you want to go today?')

plt.show()
```

## 下载这个示例

- [下载python源码: barh.py](https://matplotlib.org/_downloads/barh.py)
- [下载Jupyter notebook: barh.ipynb](https://matplotlib.org/_downloads/barh.ipynb)