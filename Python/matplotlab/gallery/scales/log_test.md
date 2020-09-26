# 对数轴

这是使用semilogx为x轴分配对数刻度的示例。

![对数轴示例](https://matplotlib.org/_images/sphx_glr_log_test_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

fig, ax = plt.subplots()

dt = 0.01
t = np.arange(dt, 20.0, dt)

ax.semilogx(t, np.exp(-t / 5.0))
ax.grid()

plt.show()
```

## 下载这个示例
            
- [下载python源码: log_test.py](https://matplotlib.org/_downloads/log_test.py)
- [下载Jupyter notebook: log_test.ipynb](https://matplotlib.org/_downloads/log_test.ipynb)