# Ginput 演示

这提供了交互功能的使用示例，例如ginput。

```python
import matplotlib.pyplot as plt
import numpy as np
t = np.arange(10)
plt.plot(t, np.sin(t))
print("Please click")
x = plt.ginput(3)
print("clicked", x)
plt.show()
```

## 下载这个示例
            
- [下载python源码: ginput_demo_sgskip.py](https://matplotlib.org/_downloads/ginput_demo_sgskip.py)
- [下载Jupyter notebook: ginput_demo_sgskip.ipynb](https://matplotlib.org/_downloads/ginput_demo_sgskip.ipynb)