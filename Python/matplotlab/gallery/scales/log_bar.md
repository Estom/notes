# 对数条形图

绘制具有对数y轴的条形图。

![对数条形图示例](https://matplotlib.org/_images/sphx_glr_log_bar_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

data = ((3, 1000), (10, 3), (100, 30), (500, 800), (50, 1))

dim = len(data[0])
w = 0.75
dimw = w / dim

fig, ax = plt.subplots()
x = np.arange(len(data))
for i in range(len(data[0])):
    y = [d[i] for d in data]
    b = ax.bar(x + i * dimw, y, dimw, bottom=0.001)

ax.set_xticks(x + dimw / 2, map(str, x))
ax.set_yscale('log')

ax.set_xlabel('x')
ax.set_ylabel('y')

plt.show()
```

## 下载这个示例
            
- [下载python源码: log_bar.py](https://matplotlib.org/_downloads/log_bar.py)
- [下载Jupyter notebook: log_bar.ipynb](https://matplotlib.org/_downloads/log_bar.ipynb)